import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/ads/ad_service.dart';
import '../../../core/ads/ad_stats_service.dart';
import '../../../core/ads/ad_widgets.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/localization/language_service.dart';
import '../../../core/localization/localized_content.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/sound_service.dart';
import '../../../core/services/tts_service.dart';
import '../../../shared/models/quiz.dart';
import '../../../shared/models/quiz_result.dart';
import '../../../shared/widgets/app_state_widgets.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/child_comic_widgets.dart';
import '../../../shared/widgets/comic_widgets.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../dashboard/presentation/dashboard_providers.dart';
import '../../progress/presentation/progress_providers.dart';
import 'quiz_providers.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({this.lessonId, super.key});

  final String? lessonId;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

enum _QuizPhase { dailyHome, splash, question, complete }

class _QuizScreenState extends ConsumerState<QuizScreen>
    with TickerProviderStateMixin {
  final _answers = <String, Set<int>>{};
  _QuizPhase _phase = _QuizPhase.splash;
  int _questionIndex = 0;
  int? _selectedIndex;
  bool _checked = false;
  bool _showNext = false;
  bool _saving = false;
  QuizResult? _result;
  late final AnimationController _splashController;
  late final AnimationController _celebrationController;

  @override
  void initState() {
    super.initState();
    _phase = widget.lessonId == null ? _QuizPhase.dailyHome : _QuizPhase.splash;
    _splashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (widget.lessonId != null) _startQuizSplash();
  }

  @override
  void dispose() {
    TtsService.instance.stop();
    _splashController.dispose();
    _celebrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quiz = widget.lessonId == null
        ? ref.watch(dailyQuizProvider)
        : ref.watch(quizForLessonProvider(widget.lessonId!));
    final dashboard =
        widget.lessonId == null ? ref.watch(dashboardProvider) : null;

    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LanguageService.language,
      builder: (context, language, _) {
        final strings = AppStrings(language);
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) _handleBack(strings);
          },
          child: AsyncValueView(
            value: quiz,
            isEmpty: (item) => item == null || item.questions.isEmpty,
            emptyEmoji: '🤖😅',
            emptyMessage: strings.questionsLost,
            emptySubtitle: strings.noWorries,
            loading: const QuizShimmer(),
            onRetry: () => widget.lessonId == null
                ? ref.invalidate(dailyQuizProvider)
                : ref.invalidate(quizForLessonProvider(widget.lessonId!)),
            data: (item) {
              final resolvedQuiz = LocalizedContent.quiz(item!, language);
              return switch (_phase) {
                _QuizPhase.dailyHome => AsyncValueView(
                    value: dashboard!,
                    onRetry: () => ref.invalidate(dashboardProvider),
                    data: (state) => _DailyQuizHome(
                      strings: strings,
                      doneToday: _result != null ||
                          (state.progress.lastActivityAt != null &&
                              _isToday(state.progress.lastActivityAt!)),
                      streakDays: state.progress.streakDays,
                      xp: state.progress.xp,
                      result: _result,
                      onStart: _startDailyMission,
                      onBack: () => context.go('/dashboard'),
                    ),
                  ),
                _QuizPhase.splash => _QuizSplash(
                    strings: strings,
                    controller: _splashController,
                  ),
                _QuizPhase.question => _QuestionScreen(
                    strings: strings,
                    quiz: resolvedQuiz,
                    questionIndex: _questionIndex,
                    selectedIndex: _selectedIndex,
                    checked: _checked,
                    showNext: _showNext,
                    saving: _saving,
                    onSelect: (index) {
                      if (!_checked) setState(() => _selectedIndex = index);
                    },
                    onCheck: () => _checkAnswer(resolvedQuiz),
                    onNext: () => _nextQuestion(resolvedQuiz),
                    onRead: () => _readQuestion(resolvedQuiz),
                  ),
                _QuizPhase.complete => _QuizCompleteScreen(
                    strings: strings,
                    result: _result!,
                    totalLessons: 10,
                    isCourseComplete: widget.lessonId != null &&
                        _isLastLesson(resolvedQuiz.lessonId),
                    isDailyQuiz: widget.lessonId == null,
                    controller: _celebrationController,
                    onNextLesson: () => widget.lessonId == null
                        ? context.go('/dashboard')
                        : _goToNextMission(resolvedQuiz.lessonId),
                    onBackToMissions: () => context.go('/learning-path'),
                  ),
              };
            },
          ),
        );
      },
    );
  }

  void _startDailyMission() {
    setState(() => _phase = _QuizPhase.splash);
    _startQuizSplash();
  }

  void _startQuizSplash() {
    _splashController.forward(from: 0);
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted && _phase == _QuizPhase.splash) {
        setState(() => _phase = _QuizPhase.question);
      }
    });
  }

  Future<void> _checkAnswer(Quiz quiz) async {
    final selected = _selectedIndex;
    if (selected == null || _checked) return;
    final question = quiz.questions[_questionIndex];
    final correct = question.acceptedAnswers.contains(selected);
    if (correct) {
      await SoundService.instance.correct();
      await TtsService.instance.speak('Shabash! Correct!');
    } else {
      await HapticFeedback.lightImpact();
      await SoundService.instance.wrong();
      await TtsService.instance.speak(
        'The right answer was ${question.options[question.acceptedAnswers.first]}',
      );
    }
    setState(() {
      _checked = true;
      _answers[question.id] = {selected};
    });
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _showNext = true);
    });
  }

  Future<void> _nextQuestion(Quiz quiz) async {
    final isLast = _questionIndex == quiz.questions.length - 1;
    if (!isLast) {
      setState(() {
        _questionIndex++;
        _selectedIndex = null;
        _checked = false;
        _showNext = false;
      });
      return;
    }
    setState(() => _saving = true);
    final result = await ref
        .read(quizViewModelProvider.notifier)
        .submitSelectedAnswers(quiz, _answers);
    ref
      ..invalidate(dashboardProvider)
      ..invalidate(dailyQuizProvider);
    await SoundService.instance.levelUp();
    if (!mounted || result == null) return;
    await AnalyticsService.instance.quizCompleted(quiz.id, result.score);
    if (widget.lessonId == null) {
      final streak =
          ref.read(dashboardProvider).valueOrNull?.progress.streakDays ?? 0;
      await AnalyticsService.instance.dailyQuizCompleted(streak);
    }
    setState(() {
      _result = result;
      _saving = false;
      _phase = _QuizPhase.complete;
    });
    _celebrationController.repeat(reverse: true);
  }

  Future<void> _handleBack(AppStrings strings) async {
    if (_saving) return;
    if (_phase == _QuizPhase.dailyHome) {
      context.go('/dashboard');
      return;
    }
    if (_phase == _QuizPhase.complete) {
      context.go(widget.lessonId == null ? '/dashboard' : '/learning-path');
      return;
    }

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
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(strings.keepGoing),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(strings.yesLeave),
          ),
        ],
      ),
    );
    if (!mounted || leave != true) return;
    context.go(widget.lessonId == null ? '/dashboard' : '/learning-path');
  }

  bool _isLastLesson(String lessonId) {
    final match = RegExp(r'lesson-(\d+)$').firstMatch(lessonId);
    return match != null && int.parse(match.group(1)!) >= 10;
  }

  bool _isToday(DateTime value) {
    final now = DateTime.now();
    return value.year == now.year &&
        value.month == now.month &&
        value.day == now.day;
  }

  void _goToNextMission(String lessonId) {
    if (_isLastLesson(lessonId)) {
      context.go('/dashboard');
      return;
    }
    final match = RegExp(r'^(.*-lesson-)(\d+)$').firstMatch(lessonId);
    if (match == null) {
      context.go('/dashboard');
      return;
    }
    final prefix = match.group(1)!;
    final current = int.parse(match.group(2)!);
    context.go('/lesson/$prefix${(current + 1).toString().padLeft(2, '0')}');
  }

  Future<void> _readQuestion(Quiz quiz) async {
    final question = quiz.questions[_questionIndex];
    final labels = ['A', 'B', 'C', 'D'];
    final text = [
      question.prompt,
      for (var i = 0; i < question.options.length; i++)
        'Option ${labels[i]}: ${question.options[i]}',
    ].join('. ');
    await TtsService.instance.speak(text);
  }
}

class _QuizSplash extends StatelessWidget {
  const _QuizSplash({required this.strings, required this.controller});

  final AppStrings strings;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ComicColors.red,
      body: Center(
        child: ScaleTransition(
          scale: Tween<double>(begin: 0, end: 1.2)
              .chain(CurveTween(curve: Curves.elasticOut))
              .animate(controller),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⚡', style: TextStyle(fontSize: 96)),
              Text(
                strings.quizTime,
                style: comicDisplay(
                  context,
                  fontSize: 48,
                  color: ComicColors.cream,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                strings.twoQuestions,
                textAlign: TextAlign.center,
                style: comicBody(
                  context,
                  fontSize: 20,
                  color: ComicColors.cream,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyQuizHome extends StatelessWidget {
  const _DailyQuizHome({
    required this.strings,
    required this.doneToday,
    required this.streakDays,
    required this.xp,
    required this.result,
    required this.onStart,
    required this.onBack,
  });

  final AppStrings strings;
  final bool doneToday;
  final int streakDays;
  final int xp;
  final QuizResult? result;
  final VoidCallback onStart;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dateLabel = '${today.day}/${today.month}/${today.year}';
    return Scaffold(
      body: SlapstickComicBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 36,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _SlapstickSoundRow(labels: ['POP!', 'THINK!', 'GO!']),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          onPressed: onBack,
                          icon: const Icon(Icons.close, size: 30),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            strings.dailyQuiz,
                            style: comicDisplay(
                              context,
                              fontSize: 38,
                              color: ComicColors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.86, end: 1),
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.elasticOut,
                      builder: (context, scale, child) {
                        return Transform.scale(scale: scale, child: child);
                      },
                      child: ComicPanel(
                        color:
                            doneToday ? ComicColors.green : ComicColors.yellow,
                        padding: const EdgeInsets.all(22),
                        borderWidth: 4,
                        child: Column(
                          children: [
                            Text(
                              doneToday ? '✅' : '🌟',
                              style: const TextStyle(fontSize: 74),
                            ),
                            Text(
                              doneToday
                                  ? 'Mission Complete for Today!'
                                  : 'Today\'s AI Masti Mission!',
                              textAlign: TextAlign.center,
                              style: comicDisplay(
                                context,
                                fontSize: 36,
                                color: ComicColors.red,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              doneToday
                                  ? _scoreLine()
                                  : 'Date: $dateLabel  •  ⭐⭐⭐',
                              textAlign: TextAlign.center,
                              style: comicBody(context, fontSize: 20),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _MiniStat(
                                    label: 'Streak', value: '$streakDays 🔥'),
                                const SizedBox(width: 10),
                                _MiniStat(label: 'XP', value: '$xp ⚡'),
                              ],
                            ),
                            const SizedBox(height: 18),
                            if (doneToday)
                              const _CountdownToTomorrow()
                            else
                              ComicButton(
                                label: 'START MISSION 🚀',
                                color: ComicColors.red,
                                expand: true,
                                onPressed: onStart,
                              ),
                            const SizedBox(height: 10),
                            Text(
                              doneToday
                                  ? 'Come back tomorrow for a new mini mission.'
                                  : '2 quick questions. Chalo, show your hero brain!',
                              textAlign: TextAlign.center,
                              style: comicBody(context, fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    ComicPanel(
                      color: ComicColors.cream,
                      padding: const EdgeInsets.all(14),
                      borderWidth: 3,
                      child: Text(
                        'Shiv says: one small quiz every day makes a super learner! 🤖',
                        textAlign: TextAlign.center,
                        style: comicBody(context, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _scoreLine() {
    final current = result;
    if (current == null) return 'Shabash! You finished today\'s quiz.';
    return 'You scored ${current.score}/${current.totalQuestions}. Shabash!';
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: ComicColors.cream,
        border: Border.all(color: ComicColors.ink, width: 3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(value, style: comicNumber(context, fontSize: 24)),
          Text(label, style: comicBody(context, fontSize: 15)),
        ],
      ),
    );
  }
}

class _CountdownToTomorrow extends StatefulWidget {
  const _CountdownToTomorrow();

  @override
  State<_CountdownToTomorrow> createState() => _CountdownToTomorrowState();
}

class _CountdownToTomorrowState extends State<_CountdownToTomorrow> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = _remaining.inHours.toString().padLeft(2, '0');
    final minutes = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_remaining.inSeconds % 60).toString().padLeft(2, '0');
    return ComicPanel(
      color: ComicColors.cream,
      padding: const EdgeInsets.all(12),
      borderWidth: 3,
      child: Text(
        'Next quiz in $hours:$minutes:$seconds ⏰',
        textAlign: TextAlign.center,
        style: comicNumber(context, fontSize: 28, color: ComicColors.red),
      ),
    );
  }

  void _tick() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    if (mounted) setState(() => _remaining = tomorrow.difference(now));
  }
}

class _QuestionScreen extends StatelessWidget {
  const _QuestionScreen({
    required this.strings,
    required this.quiz,
    required this.questionIndex,
    required this.selectedIndex,
    required this.checked,
    required this.showNext,
    required this.saving,
    required this.onSelect,
    required this.onCheck,
    required this.onNext,
    required this.onRead,
  });

  final AppStrings strings;
  final Quiz quiz;
  final int questionIndex;
  final int? selectedIndex;
  final bool checked;
  final bool showNext;
  final bool saving;
  final ValueChanged<int> onSelect;
  final VoidCallback onCheck;
  final VoidCallback onNext;
  final VoidCallback onRead;

  @override
  Widget build(BuildContext context) {
    final question = quiz.questions[questionIndex];
    final correctIndex = question.acceptedAnswers.first;
    final selectedCorrect = selectedIndex != null &&
        question.acceptedAnswers.contains(selectedIndex);
    return Scaffold(
      body: SlapstickComicBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const _SlapstickSoundRow(labels: ['WHAM!', 'AHA!', 'ZING!']),
                const SizedBox(height: 8),
                _QuestionTop(
                  strings: strings,
                  current: questionIndex + 1,
                  total: quiz.questions.length,
                  answeredCount: checked ? questionIndex + 1 : questionIndex,
                ),
                const SizedBox(height: 16),
                _PromptCard(
                  strings: strings,
                  prompt: question.prompt,
                  onRead: onRead,
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < question.options.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _OptionCard(
                            letter: String.fromCharCode(65 + i),
                            label: question.options[i],
                            index: i,
                            selected: selectedIndex == i,
                            correct: checked && i == correctIndex,
                            wrong: checked &&
                                selectedIndex == i &&
                                i != correctIndex,
                            locked: checked,
                            onTap: () => onSelect(i),
                          ),
                        ),
                    ],
                  ),
                ),
                if (checked) ...[
                  _FeedbackLine(
                    strings: strings,
                    correct: selectedCorrect,
                    correctOption: question.options[correctIndex],
                  ),
                  const SizedBox(height: 10),
                ],
                if (!checked && selectedIndex != null)
                  ComicButton(
                    label: strings.checkAnswer,
                    color: ComicColors.red,
                    expand: true,
                    onPressed: onCheck,
                  )
                else if (showNext)
                  ComicButton(
                    label: questionIndex == quiz.questions.length - 1
                        ? (saving ? strings.saving : strings.finishMission)
                        : strings.nextQuestion,
                    color: ComicColors.red,
                    expand: true,
                    onPressed: saving ? null : onNext,
                  )
                else
                  const SizedBox(height: 56),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SlapstickSoundRow extends StatelessWidget {
  const _SlapstickSoundRow({required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final colors = [ComicColors.red, ComicColors.yellow, ComicColors.blue];
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 6,
      children: [
        for (var i = 0; i < labels.length; i++)
          Transform.rotate(
            angle: i == 1 ? 0.08 : -0.08,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: colors[i % colors.length],
                border: Border.all(color: ComicColors.ink, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                labels[i],
                style: comicBody(
                  context,
                  fontSize: 12,
                  color: i == 1 ? ComicColors.ink : ComicColors.cream,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _QuestionTop extends StatelessWidget {
  const _QuestionTop({
    required this.strings,
    required this.current,
    required this.total,
    required this.answeredCount,
  });

  final AppStrings strings;
  final int current;
  final int total;
  final int answeredCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: ComicColors.yellow,
            border: Border.all(color: ComicColors.ink, width: 3),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            strings.questionOf(current, total),
            style: comicBody(context, fontSize: 18, color: ComicColors.ink),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < total; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  i < answeredCount ? '●' : '○',
                  style: comicBody(
                    context,
                    fontSize: 24,
                    color:
                        i < answeredCount ? ComicColors.red : ComicColors.ink,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({
    required this.strings,
    required this.prompt,
    required this.onRead,
  });

  final AppStrings strings;
  final String prompt;
  final VoidCallback onRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ComicColors.cream,
        border: Border.all(color: ComicColors.ink, width: 4),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
              color: ComicColors.ink, offset: Offset(3, 3), blurRadius: 0),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              prompt,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: comicBody(context, fontSize: 22, color: ComicColors.ink),
            ),
          ),
          IconButton(
            tooltip: strings.readQuestion,
            onPressed: onRead,
            icon: const Text('🔊', style: TextStyle(fontSize: 24)),
          ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatefulWidget {
  const _OptionCard({
    required this.letter,
    required this.label,
    required this.index,
    required this.selected,
    required this.correct,
    required this.wrong,
    required this.locked,
    required this.onTap,
  });

  final String letter;
  final String label;
  final int index;
  final bool selected;
  final bool correct;
  final bool wrong;
  final bool locked;
  final VoidCallback onTap;

  @override
  State<_OptionCard> createState() => _OptionCardState();
}

class _OptionCardState extends State<_OptionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final badgeColors = [
      ComicColors.red,
      ComicColors.blue,
      ComicColors.yellow,
      ComicColors.green,
    ];
    final fill = widget.correct
        ? ComicColors.green
        : widget.wrong
            ? ComicColors.red
            : Colors.white;
    final borderColor = widget.selected && !widget.locked
        ? ComicColors.yellow
        : widget.correct
            ? ComicColors.green
            : ComicColors.ink;
    return GestureDetector(
      onTapDown: widget.locked ? null : (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.locked ? null : widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 90),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          constraints: const BoxConstraints(minHeight: 64),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: fill,
            border:
                Border.all(color: borderColor, width: widget.selected ? 4 : 2),
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                  color: ComicColors.ink, offset: Offset(3, 3), blurRadius: 0),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: badgeColors[widget.index % badgeColors.length],
                child: Text(
                  widget.letter,
                  style: comicBody(
                    context,
                    fontSize: 18,
                    color:
                        widget.index == 2 ? ComicColors.ink : ComicColors.cream,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  style:
                      comicBody(context, fontSize: 18, color: ComicColors.ink),
                ),
              ),
              if (widget.correct) const Icon(Icons.check_circle, size: 28),
              if (widget.wrong) const Icon(Icons.cancel, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedbackLine extends StatelessWidget {
  const _FeedbackLine({
    required this.strings,
    required this.correct,
    required this.correctOption,
  });

  final AppStrings strings;
  final bool correct;
  final String correctOption;

  @override
  Widget build(BuildContext context) {
    return Text(
      correct
          ? strings.correctFeedback()
          : strings.wrongFeedback(correctOption),
      textAlign: TextAlign.center,
      style: comicBody(
        context,
        fontSize: 20,
        color: correct ? ComicColors.green : ComicColors.red,
      ),
    );
  }
}

class _QuizCompleteScreen extends ConsumerWidget {
  const _QuizCompleteScreen({
    required this.strings,
    required this.result,
    required this.totalLessons,
    required this.isCourseComplete,
    required this.isDailyQuiz,
    required this.controller,
    required this.onNextLesson,
    required this.onBackToMissions,
  });

  final AppStrings strings;
  final QuizResult result;
  final int totalLessons;
  final bool isCourseComplete;
  final bool isDailyQuiz;
  final AnimationController controller;
  final VoidCallback onNextLesson;
  final VoidCallback onBackToMissions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = strings.resultMessage(result.score, result.totalQuestions);
    return Scaffold(
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.lerp(
                      ComicColors.yellow, ComicColors.cream, controller.value)!,
                  Color.lerp(
                      ComicColors.cream, ComicColors.yellow, controller.value)!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: child,
          );
        },
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.6, end: 1),
                    duration: const Duration(milliseconds: 750),
                    curve: Curves.elasticOut,
                    builder: (context, scale, child) {
                      return Transform.scale(scale: scale, child: child);
                    },
                    child: const Text('🏆', style: TextStyle(fontSize: 94)),
                  ),
                  Text(
                    strings.missionComplete,
                    textAlign: TextAlign.center,
                    style: comicDisplay(context,
                        fontSize: 42, color: ComicColors.red),
                  ),
                  const SizedBox(height: 12),
                  ComicPanel(
                    color: Colors.white,
                    padding: const EdgeInsets.all(18),
                    borderWidth: 3,
                    child: Column(
                      children: [
                        Text(
                          strings.scoreLine(
                              result.score, result.totalQuestions),
                          textAlign: TextAlign.center,
                          style: comicBody(context, fontSize: 22),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: comicBody(context, fontSize: 20),
                        ),
                        const SizedBox(height: 14),
                        _CountUp(
                            label: 'XP earned',
                            value: result.earnedXp,
                            suffix: ' XP'),
                        _CountUp(
                            label: 'Coins earned',
                            value: result.earnedCoins,
                            suffix: ' 🪙'),
                        RewardedAdBonusButton(
                          rewardKey: 'quiz_${result.quizId}_bonus_coins',
                          label: 'Watch Short Video for +10 Coins',
                          onRewardEarned: () => _awardBonusCoins(ref, 10),
                        ),
                      ],
                    ),
                  ),
                  if (isCourseComplete) ...[
                    const SizedBox(height: 14),
                    const ActionBurst(
                      text: '🎊 COURSE COMPLETE! You are an AI Hero!',
                    ),
                  ],
                  const SizedBox(height: 18),
                  ComicButton(
                    label: isDailyQuiz || isCourseComplete
                        ? 'Back to Dashboard ▶'
                        : 'Next Lesson ▶',
                    color: ComicColors.red,
                    expand: true,
                    onPressed: () async {
                      await AdService.instance
                          .showInterstitialAd(placement: 'lesson_complete');
                      onNextLesson();
                    },
                  ),
                  const SizedBox(height: 10),
                  if (!isDailyQuiz)
                    OutlinedButton(
                      onPressed: () async {
                        await AdService.instance
                            .showInterstitialAd(placement: 'lesson_complete');
                        onBackToMissions();
                      },
                      child: Text(
                        'Back to Missions 🗺',
                        style: comicBody(context, fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _awardBonusCoins(WidgetRef ref, int coins) async {
    final userId = ref.read(currentUserIdProvider) ?? 'guest';
    final repository = ref.read(progressRepositoryProvider);
    final progress = await repository.getProgress(userId);
    await repository.saveProgress(
      progress.copyWith(coins: progress.coins + coins),
    );
    await AdStatsService.instance.recordRewardedAdWatched(coinsEarned: coins);
    ref
      ..invalidate(dashboardProvider)
      ..invalidate(userProgressProvider(userId));
  }
}

class _CountUp extends StatelessWidget {
  const _CountUp(
      {required this.label, required this.value, required this.suffix});

  final String label;
  final int value;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: const Duration(milliseconds: 900),
      builder: (context, current, child) {
        return Text(
          '+$current$suffix  $label',
          textAlign: TextAlign.center,
          style: comicNumber(context, fontSize: 32, color: ComicColors.red),
        );
      },
    );
  }
}
