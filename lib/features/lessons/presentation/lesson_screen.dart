import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/localization/language_service.dart';
import '../../../core/localization/localized_content.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/sound_service.dart';
import '../../../core/services/tts_service.dart';
import '../../../shared/models/lesson.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/child_comic_widgets.dart';
import '../../../shared/widgets/comic_widgets.dart';
import 'lesson_providers.dart';

class LessonScreen extends ConsumerStatefulWidget {
  const LessonScreen({required this.id, super.key});

  final String id;

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  final _scrollController = ScrollController();
  double _progress = 0;
  bool _buttonPressed = false;
  bool _speaking = false;
  int _activePanel = 0;
  DateTime? _startedAt;

  bool get _quizUnlocked => _progress >= 0.8;

  @override
  void initState() {
    super.initState();
    _startedAt = DateTime.now();
    _scrollController.addListener(_updateProgress);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TtsService.instance.initialize();
      AnalyticsService.instance.lessonStarted(widget.id);
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_updateProgress)
      ..dispose();
    TtsService.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lesson = ref.watch(lessonProvider(widget.id));
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LanguageService.language,
      builder: (context, language, _) {
        final strings = AppStrings(language);
        return AsyncValueView(
          value: lesson,
          emptyMessage: strings.lessonNotFound,
          isEmpty: (item) => item == null,
          onRetry: () => ref.invalidate(lessonProvider(widget.id)),
          data: (item) {
            final localizedLesson = LocalizedContent.lesson(item!, language);
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (!didPop) _confirmExit(strings);
              },
              child: _LessonView(
                strings: strings,
                lesson: localizedLesson,
                scrollController: _scrollController,
                progress: _progress,
                quizUnlocked: _quizUnlocked,
                buttonPressed: _buttonPressed,
                speaking: _speaking,
                activePanel: _activePanel,
                onExit: () => _confirmExit(strings),
                onStartQuiz: () => _startQuiz(item.id),
                onReadPanel: _readPanel,
              ),
            );
          },
        );
      },
    );
  }

  void _updateProgress() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final next = max <= 0 ? 1.0 : (_scrollController.offset / max).clamp(0, 1);
    if ((next - _progress).abs() > 0.01) {
      setState(() => _progress = next.toDouble());
    }
  }

  Future<void> _confirmExit(AppStrings strings) async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ComicColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: ComicColors.ink, width: 4),
        ),
        title: Text(
          strings.leaveMission,
          style: comicDisplay(context, fontSize: 34, color: ComicColors.red),
        ),
        content: Text(
          strings.progressNotSaved,
          style: comicBody(context, fontSize: 18, color: ComicColors.ink),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              strings.yesLeave,
              style: comicBody(context, fontSize: 16, color: ComicColors.red),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(strings.keepGoing),
          ),
        ],
      ),
    );
    if (leave == true && mounted) context.go('/learning-path');
  }

  Future<void> _startQuiz(String lessonId) async {
    if (!_quizUnlocked) return;
    final elapsed =
        DateTime.now().difference(_startedAt ?? DateTime.now()).inSeconds;
    await AnalyticsService.instance.lessonCompleted(lessonId, elapsed);
    await SoundService.instance.tap();
    setState(() => _buttonPressed = true);
    await Future<void>.delayed(const Duration(milliseconds: 120));
    if (!mounted) return;
    setState(() => _buttonPressed = false);
    context.go('/quiz/$lessonId');
  }

  Future<void> _readPanel(List<String> panels) async {
    if (_speaking) {
      await TtsService.instance.pause();
      if (mounted) setState(() => _speaking = false);
      return;
    }
    if (!TtsService.instance.isAvailable || panels.isEmpty) return;
    final index = _activePanel.clamp(0, panels.length - 1);
    setState(() => _speaking = true);
    await TtsService.instance.speak(
      panels[index],
      onComplete: () {
        if (!mounted) return;
        final next = (index + 1).clamp(0, panels.length - 1);
        setState(() {
          _speaking = false;
          _activePanel = next;
        });
        if (_scrollController.hasClients && next != index) {
          final max = _scrollController.position.maxScrollExtent;
          _scrollController.animateTo(
            max * (next / panels.length),
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOut,
          );
        }
      },
    );
  }
}

class _LessonView extends StatelessWidget {
  const _LessonView({
    required this.strings,
    required this.lesson,
    required this.scrollController,
    required this.progress,
    required this.quizUnlocked,
    required this.buttonPressed,
    required this.speaking,
    required this.activePanel,
    required this.onExit,
    required this.onStartQuiz,
    required this.onReadPanel,
  });

  final AppStrings strings;
  final Lesson lesson;
  final ScrollController scrollController;
  final double progress;
  final bool quizUnlocked;
  final bool buttonPressed;
  final bool speaking;
  final int activePanel;
  final VoidCallback onExit;
  final VoidCallback onStartQuiz;
  final ValueChanged<List<String>> onReadPanel;

  @override
  Widget build(BuildContext context) {
    final panels = _storyPanels(lesson.story);
    final compactAppBar = MediaQuery.sizeOf(context).width < 360;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7),
      appBar: AppBar(
        backgroundColor: ComicColors.red,
        foregroundColor: ComicColors.cream,
        titleSpacing: compactAppBar ? 0 : null,
        leading: IconButton(
          icon: const Icon(Icons.close, color: ComicColors.cream),
          onPressed: onExit,
        ),
        title: Text(
          lesson.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: comicDisplay(
            context,
            fontSize: compactAppBar ? 22 : 28,
            color: ComicColors.cream,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: compactAppBar ? 4 : 10),
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: compactAppBar ? 58 : 118,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: compactAppBar ? 7 : 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: ComicColors.ink.withValues(alpha: 0.2),
                  border: Border.all(color: ComicColors.cream, width: 2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    compactAppBar
                        ? '${lesson.order}/10'
                        : strings.lessonCount(lesson.order, 10),
                    style: comicBody(
                      context,
                      fontSize: compactAppBar ? 13 : 14,
                      color: ComicColors.cream,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: IndianAdventureComicBackground(
        child: Column(
          children: [
            _LessonProgressBar(progress: progress),
            const _IndianLessonCueStrip(),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 120),
                children: [
                  for (var index = 0; index < panels.length; index++) ...[
                    _StoryPanel(
                      text: panels[index],
                      index: index,
                      isLast: index == panels.length - 1,
                      concepts: lesson.concepts,
                      active: speaking && index == activePanel,
                      strings: strings,
                    ),
                    const SizedBox(height: 18),
                  ],
                  _ConceptChips(concepts: lesson.concepts),
                  const SizedBox(height: 18),
                  _ShivTipBox(concepts: lesson.concepts, strings: strings),
                  const SizedBox(height: 180),
                ],
              ),
            ),
            _BottomLessonAction(
              unlocked: quizUnlocked,
              pressed: buttonPressed,
              strings: strings,
              onPressed: onStartQuiz,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: speaking ? ComicColors.yellow : ComicColors.red,
        foregroundColor: speaking ? ComicColors.ink : ComicColors.cream,
        onPressed:
            TtsService.instance.isAvailable ? () => onReadPanel(panels) : null,
        icon: Text(speaking ? '⏸' : '🔊'),
        label: Text(speaking ? strings.pause : strings.readToMe),
      ),
    );
  }

  List<String> _storyPanels(String story) {
    final sentences = RegExp(r'[^.!?]+[.!?]?')
        .allMatches(story)
        .map((match) => match.group(0)!.trim())
        .where((part) => part.isNotEmpty)
        .toList();
    if (sentences.isEmpty) return [story];
    final panels = <String>[];
    for (var i = 0; i < sentences.length; i += 2) {
      panels.add(sentences.skip(i).take(2).join(' '));
    }
    while (panels.length < 4) {
      panels.add(strings.isHindi
          ? 'Shiv रुककर hero से कहता है कि इस idea को school, tiffin time, या cricket game में imagine करो. Shabash, पढ़ते रहो!'
          : 'Shiv pauses and asks the hero to imagine this idea in school, tiffin time, or a cricket game. Shabash, keep reading!');
    }
    return panels.take(6).toList();
  }
}

class _IndianLessonCueStrip extends StatelessWidget {
  const _IndianLessonCueStrip();

  @override
  Widget build(BuildContext context) {
    final cues = ['🏫 School', '🍱 Tiffin', '🏏 Cricket', '🪔 Rangoli'];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: ComicColors.cream,
        border: Border(bottom: BorderSide(color: ComicColors.ink, width: 3)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final cue in cues)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: cue.contains('Tiffin')
                        ? ComicColors.yellow
                        : cue.contains('Cricket')
                            ? ComicColors.green
                            : cue.contains('Rangoli')
                                ? ComicColors.blue
                                : Colors.white,
                    border: Border.all(color: ComicColors.ink, width: 2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    cue,
                    style: comicBody(context,
                        fontSize: 14, color: ComicColors.ink),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LessonProgressBar extends StatelessWidget {
  const _LessonProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: ComicColors.ink, width: 4),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: ComicColors.ink, width: 3),
          borderRadius: BorderRadius.circular(999),
        ),
        clipBehavior: Clip.antiAlias,
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress.clamp(0, 1),
          child: Container(color: ComicColors.red),
        ),
      ),
    );
  }
}

class _StoryPanel extends StatelessWidget {
  const _StoryPanel({
    required this.text,
    required this.index,
    required this.isLast,
    required this.concepts,
    required this.active,
    required this.strings,
  });

  final String text;
  final int index;
  final bool isLast;
  final List<String> concepts;
  final bool active;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final color = index.isEven ? Colors.white : ComicColors.cream;
    final panelCues = [
      'School scene',
      'Tiffin idea',
      'Cricket clue',
      'Rangoli pattern'
    ];
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: active ? ComicColors.yellow : ComicColors.ink,
          width: active ? 5 : 2.5,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: active ? ComicColors.yellow : ComicColors.ink,
            offset: const Offset(4, 4),
            blurRadius: active ? 14 : 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: ComicColors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: ComicColors.ink, width: 3),
                ),
                child: const Center(
                    child: Text('🤖', style: TextStyle(fontSize: 24))),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: ComicColors.yellow,
                      border: Border.all(color: ComicColors.ink, width: 3),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        strings.shivSays,
                        style: comicBody(
                          context,
                          fontSize: 16,
                          color: ComicColors.ink,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Transform.rotate(
                angle: 0.08,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                  decoration: BoxDecoration(
                    color: ComicColors.blue,
                    border: Border.all(color: ComicColors.ink, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    panelCues[index % panelCues.length],
                    style: comicBody(
                      context,
                      fontSize: 12,
                      color: ComicColors.cream,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            text,
            style: comicBody(context, fontSize: 18, color: ComicColors.ink)
                .copyWith(height: 1.6),
          ),
          if (index == 2) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: ComicColors.yellow,
                border: Border.all(color: ComicColors.ink, width: 3),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                strings.funFact,
                style: comicBody(context, fontSize: 17, color: ComicColors.ink),
              ),
            ),
          ],
          if (isLast) ...[
            const SizedBox(height: 16),
            _ConceptChips(concepts: concepts),
          ],
        ],
      ),
    );
  }
}

class _ConceptChips extends StatelessWidget {
  const _ConceptChips({required this.concepts});

  final List<String> concepts;

  @override
  Widget build(BuildContext context) {
    const colors = [ComicColors.red, ComicColors.blue, ComicColors.yellow];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < concepts.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: colors[i % colors.length],
                  border: Border.all(color: ComicColors.ink, width: 3),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '⭐ ${concepts[i]}',
                  style: comicBody(
                    context,
                    fontSize: 16,
                    color: colors[i % colors.length] == ComicColors.yellow
                        ? ComicColors.ink
                        : ComicColors.cream,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ShivTipBox extends StatelessWidget {
  const _ShivTipBox({required this.concepts, required this.strings});

  final List<String> concepts;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ComicColors.yellow,
        border: Border.all(color: ComicColors.ink, width: 4),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
              color: ComicColors.ink, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 34)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${strings.shivTip}: ${_tip()}',
              style: comicBody(context, fontSize: 18, color: ComicColors.ink)
                  .copyWith(height: 1.45),
            ),
          ),
        ],
      ),
    );
  }

  String _tip() {
    final joined = concepts.join(' ').toLowerCase();
    if (joined.contains('privacy') || joined.contains('password')) {
      if (strings.isHindi) {
        return 'Private चीजें secret tiffin treat जैसी हैं. उन्हें safe रखो और online share करने से पहले adult से पूछो. 😄';
      }
      return 'Private things are like your secret tiffin treat. Keep them safe and ask an adult before sharing anything online. 😄';
    }
    if (joined.contains('prompt') || joined.contains('question')) {
      if (strings.isHindi) {
        return 'Good AI question extra chutney मांगने जैसा है: साफ बोलो क्या चाहिए और helpful details जोड़ो!';
      }
      return 'A good AI question is like asking clearly for extra chutney: say what you want and add helpful details!';
    }
    if (joined.contains('pattern')) {
      if (strings.isHindi) {
        return 'Patterns treasure clues हैं. Red-yellow-red-yellow आपके brain को next clue बताते हैं!';
      }
      return 'Patterns are treasure clues. Red-yellow-red-yellow tells your brain what may come next!';
    }
    if (joined.contains('example') || joined.contains('training')) {
      if (strings.isHindi) {
        return 'AI examples से सीखता है, जैसे आपने देखकर और try करके roti खाना सीखा! 😄';
      }
      return 'AI learns from examples, just like you learned to eat roti by watching Mummy and trying yourself! 😄';
    }
    if (strings.isHindi) {
      return 'AI helper है, boss नहीं. आप और trusted grown-ups final choice करते हो, dost!';
    }
    return 'AI is a helper, not the boss. You and trusted grown-ups make the final choice, dost!';
  }
}

class _BottomLessonAction extends StatelessWidget {
  const _BottomLessonAction({
    required this.unlocked,
    required this.pressed,
    required this.strings,
    required this.onPressed,
  });

  final bool unlocked;
  final bool pressed;
  final AppStrings strings;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: ComicColors.ink, width: 4)),
      ),
      child: AnimatedScale(
        scale: pressed ? 0.95 : 1,
        duration: const Duration(milliseconds: 100),
        child: ComicButton(
          label: unlocked ? strings.startQuiz : strings.keepReading,
          icon: unlocked ? Icons.quiz : Icons.menu_book,
          color: unlocked ? ComicColors.red : Colors.grey,
          expand: true,
          onPressed: unlocked ? onPressed : null,
        ),
      ),
    );
  }
}
