import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/localization/language_service.dart';
import '../../../core/services/accessibility_service.dart';
import '../../../core/services/sound_service.dart';
import '../../../core/services/tts_service.dart';
import '../../../shared/widgets/app_state_widgets.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/child_comic_widgets.dart';
import '../../../shared/widgets/comic_widgets.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../lessons/presentation/lesson_providers.dart';
import '../../progress/presentation/progress_providers.dart';
import '../../shop/presentation/shop_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  static const _avatars = ['🤖', '🦸', '🧑‍🚀', '🧙', '🦊', '🐯'];
  String _heroName = 'Shiv Learner';
  String _ageGroup = 'Little Hero';
  int _avatarIndex = 0;
  bool _soundOn = true;
  bool _ttsOn = true;
  double _ttsRate = 0.85;
  bool _easyReading = false;
  bool _dataSaver = false;
  bool _editingName = false;
  AppLanguage _language = AppLanguage.english;
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(currentUserIdProvider) ?? 'guest';
    final progress = ref.watch(userProgressProvider(userId));
    final courses = ref.watch(coursesProvider);
    final avatarFrame = ref.watch(avatarFrameProvider).valueOrNull ?? '';
    final strings = AppStrings(_language);
    return ChildCardScreen(
      title: strings.heroProfile,
      backRoute: '/dashboard',
      child: AsyncValueView(
        value: progress,
        loading: const ProfileShimmer(),
        onRetry: () => ref.invalidate(userProgressProvider(userId)),
        data: (item) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HeroCard(
              avatar: _avatars[_avatarIndex.clamp(0, _avatars.length - 1)],
              frame: avatarFrame,
              name: _heroName,
              level: item.level,
              ageGroup: _ageGroup,
              editing: _editingName,
              controller: _nameController,
              onEditName: _toggleNameEdit,
              onSaveName: _saveName,
              onAvatarTap: _showAvatarPicker,
            ),
            const SizedBox(height: 18),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.18,
              children: [
                _CountStat(
                    label: strings.totalXpEarned, emoji: '⚡', value: item.xp),
                _CountStat(
                    label: strings.totalCoins, emoji: '🪙', value: item.coins),
                _CountStat(
                  label: strings.lessonsCompleted,
                  emoji: '📚',
                  value: item.completedLessons.length,
                ),
                _CountStat(
                  label: strings.bestStreak,
                  emoji: '🔥',
                  value: item.streakDays,
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              strings.myLearningJourney,
              style:
                  comicDisplay(context, fontSize: 34, color: ComicColors.red),
            ),
            const SizedBox(height: 10),
            AsyncValueView(
              value: courses,
              isEmpty: (items) => items.isEmpty,
              emptyMessage: strings.noCourses,
              onRetry: () => ref.invalidate(coursesProvider),
              data: (items) => Column(
                children: [
                  for (final course in items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _CourseProgressCard(
                        title: course.title,
                        done: item.completedLessons
                            .where((id) => course.lessonIds.contains(id))
                            .length,
                        total: course.lessonIds.length,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _SettingsSection(
              soundOn: _soundOn,
              ttsOn: _ttsOn,
              ttsRate: _ttsRate,
              easyReading: _easyReading,
              dataSaver: _dataSaver,
              language: _language,
              strings: strings,
              onSoundChanged: _setSound,
              onTtsChanged: _setTts,
              onRateChanged: _setTtsRate,
              onEasyReadingChanged: _setEasyReading,
              onDataSaverChanged: _setDataSaver,
              onLanguageChanged: _setLanguage,
              onAge: () => context.go('/age'),
              onName: _toggleNameEdit,
              onAbout: _showAbout,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final muted = await SoundService.instance.isMuted();
    if (!mounted) return;
    final groupKey = prefs.getString('age_group') ?? 'little_hero';
    setState(() {
      _heroName = prefs.getString('hero_name') ?? 'Shiv Learner';
      _nameController.text = _heroName;
      _avatarIndex = prefs.getInt('avatar_index') ?? 0;
      _ageGroup = switch (groupKey) {
        'super_learner' => 'Super Learner',
        'big_explorer' => 'Big Explorer',
        _ => 'Little Hero',
      };
      _soundOn = !muted;
      _ttsOn = prefs.getBool('tts_enabled') ?? true;
      _ttsRate = prefs.getDouble('tts_rate') ?? 0.85;
      _easyReading = prefs.getBool('easy_reading_mode') ?? false;
      _dataSaver = prefs.getBool('data_saver_mode') ?? false;
      _language = LanguageService.language.value;
    });
  }

  void _toggleNameEdit() {
    setState(() {
      _editingName = !_editingName;
      _nameController.text = _heroName;
    });
  }

  Future<void> _saveName() async {
    final next = _nameController.text.trim();
    if (next.isEmpty) return;
    if (_looksLikePrivateName(next)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Try a fun hero nickname instead! Like 'Super Arjun' or 'Captain Priya'! 🦸",
          ),
        ),
      );
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('hero_name', next);
    if (mounted) {
      setState(() {
        _heroName = next;
        _editingName = false;
      });
    }
  }

  Future<void> _setSound(bool value) async {
    await SoundService.instance.setMuted(!value);
    if (mounted) setState(() => _soundOn = value);
  }

  Future<void> _setTts(bool value) async {
    await TtsService.instance.setEnabled(value);
    if (mounted) setState(() => _ttsOn = value);
  }

  Future<void> _setTtsRate(double value) async {
    await TtsService.instance.setRate(value);
    if (mounted) setState(() => _ttsRate = value);
  }

  Future<void> _setEasyReading(bool value) async {
    await AccessibilityService.instance.setEasyReading(value);
    if (mounted) setState(() => _easyReading = value);
  }

  Future<void> _setDataSaver(bool value) async {
    await AccessibilityService.instance.setDataSaver(value);
    if (mounted) setState(() => _dataSaver = value);
  }

  Future<void> _setLanguage(AppLanguage value) async {
    await LanguageService.instance.setLanguage(value);
    await TtsService.instance.stop();
    if (!mounted) return;
    setState(() => _language = value);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings(value).languageChanged)),
    );
  }

  bool _looksLikePrivateName(String value) {
    return RegExp(r'\b\d{10}\b').hasMatch(value) ||
        RegExp(r'^[A-Z][a-z]+ [A-Z][a-z]+( [A-Z][a-z]+)?$').hasMatch(value);
  }

  Future<void> _showAvatarPicker() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: ComicColors.cream,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(18),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (var i = 0; i < _avatars.length; i++)
              GestureDetector(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setInt('avatar_index', i);
                  if (mounted) setState(() => _avatarIndex = i);
                  if (context.mounted) Navigator.pop(context);
                },
                child: CircleAvatar(
                  radius: 38,
                  backgroundColor:
                      i == _avatarIndex ? ComicColors.yellow : ComicColors.blue,
                  child:
                      Text(_avatars[i], style: const TextStyle(fontSize: 34)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showAbout() {
    final strings = AppStrings(_language);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.appTitle),
        content: Text(strings.aboutText),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.nice),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.avatar,
    required this.frame,
    required this.name,
    required this.level,
    required this.ageGroup,
    required this.editing,
    required this.controller,
    required this.onEditName,
    required this.onSaveName,
    required this.onAvatarTap,
  });

  final String avatar;
  final String frame;
  final String name;
  final int level;
  final String ageGroup;
  final bool editing;
  final TextEditingController controller;
  final VoidCallback onEditName;
  final VoidCallback onSaveName;
  final VoidCallback onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [ComicColors.red, ComicColors.yellow],
        ),
        border: Border.all(color: ComicColors.ink, width: 4),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onAvatarTap,
            child: CircleAvatar(
              radius: 58,
              backgroundColor: _frameColor(frame),
              child: CircleAvatar(
                radius: 49,
                backgroundColor: ComicColors.cream,
                child: Text(avatar, style: const TextStyle(fontSize: 54)),
              ),
            ),
          ),
          TextButton(
            onPressed: onAvatarTap,
            child: Text(
              AppStrings(LanguageService.language.value).tapToChange,
              style: comicBody(context, fontSize: 16, color: ComicColors.cream),
            ),
          ),
          if (editing)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: comicBody(context, fontSize: 20),
                    decoration: const InputDecoration(filled: true),
                  ),
                ),
                IconButton(
                    onPressed: onSaveName, icon: const Icon(Icons.check)),
              ],
            )
          else
            GestureDetector(
              onTap: onEditName,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: comicDisplay(
                  context,
                  fontSize: 38,
                  color: ComicColors.cream,
                ),
              ),
            ),
          Text(
            AppStrings(LanguageService.language.value).heroLevel(level),
            style: comicBody(context, fontSize: 20, color: ComicColors.cream),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: ComicColors.cream,
              border: Border.all(color: ComicColors.ink, width: 3),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(ageGroup, style: comicBody(context, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Color _frameColor(String value) {
    return switch (value) {
      'star' => ComicColors.yellow,
      'fire' => ComicColors.red,
      'lightning' => ComicColors.blue,
      'rainbow' => ComicColors.purple,
      _ => ComicColors.cream,
    };
  }
}

class _CountStat extends StatelessWidget {
  const _CountStat({
    required this.label,
    required this.emoji,
    required this.value,
  });

  final String label;
  final String emoji;
  final int value;

  @override
  Widget build(BuildContext context) {
    return WhiteComicItemCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(emoji, style: const TextStyle(fontSize: 30)),
            ),
          ),
          Flexible(
            child: TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: value),
              duration: const Duration(milliseconds: 700),
              builder: (context, current, child) => FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '$current',
                  style: comicNumber(
                    context,
                    fontSize: 34,
                    color: ComicColors.red,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: comicBody(context, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseProgressCard extends StatelessWidget {
  const _CourseProgressCard({
    required this.title,
    required this.done,
    required this.total,
  });

  final String title;
  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final complete = total > 0 && done >= total;
    return WhiteComicItemCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: comicBody(context, fontSize: 18)),
          const SizedBox(height: 6),
          Text('$done/$total lessons done',
              style: comicBody(context, fontSize: 15)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: total == 0 ? 0 : done / total,
            minHeight: 12,
            color: complete ? ComicColors.green : ComicColors.blue,
            backgroundColor: ComicColors.cream,
          ),
          if (complete)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('DONE! Shabash! ✅',
                  style: comicBody(context,
                      fontSize: 16, color: ComicColors.green)),
            ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.strings,
    required this.soundOn,
    required this.ttsOn,
    required this.ttsRate,
    required this.easyReading,
    required this.dataSaver,
    required this.language,
    required this.onSoundChanged,
    required this.onTtsChanged,
    required this.onRateChanged,
    required this.onEasyReadingChanged,
    required this.onDataSaverChanged,
    required this.onLanguageChanged,
    required this.onAge,
    required this.onName,
    required this.onAbout,
  });

  final AppStrings strings;
  final bool soundOn;
  final bool ttsOn;
  final double ttsRate;
  final bool easyReading;
  final bool dataSaver;
  final AppLanguage language;
  final ValueChanged<bool> onSoundChanged;
  final ValueChanged<bool> onTtsChanged;
  final ValueChanged<double> onRateChanged;
  final ValueChanged<bool> onEasyReadingChanged;
  final ValueChanged<bool> onDataSaverChanged;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final VoidCallback onAge;
  final VoidCallback onName;
  final VoidCallback onAbout;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SettingCard(
          title: strings.soundEffects,
          trailing: Switch(value: soundOn, onChanged: onSoundChanged),
        ),
        _SettingCard(
          title: strings.voiceReading,
          trailing: Switch(value: ttsOn, onChanged: onTtsChanged),
        ),
        _SettingCard(
          title: strings.speed(_rateLabel(ttsRate)),
          trailing: SizedBox(
            width: 170,
            child: Slider(
              value: ttsRate,
              min: 0.65,
              max: 1.1,
              divisions: 2,
              label: _rateLabel(ttsRate),
              onChanged: onRateChanged,
            ),
          ),
        ),
        _SettingCard(
          title: strings.easyReading,
          trailing: Switch(value: easyReading, onChanged: onEasyReadingChanged),
        ),
        _SettingCard(
          title: strings.dataSaver,
          trailing: Switch(value: dataSaver, onChanged: onDataSaverChanged),
        ),
        _SettingCard(
          title: strings.appLanguage,
          trailing: SegmentedButton<AppLanguage>(
            segments: const [
              ButtonSegment(value: AppLanguage.english, label: Text('EN')),
              ButtonSegment(value: AppLanguage.hindi, label: Text('हिं')),
            ],
            selected: {language},
            onSelectionChanged: (values) => onLanguageChanged(values.first),
          ),
        ),
        _SettingCard(title: strings.changeAgeGroup, onTap: onAge),
        _SettingCard(title: strings.changeHeroName, onTap: onName),
        _SafetyFirstCard(strings: strings),
        _SettingCard(title: strings.aboutApp, onTap: onAbout),
      ],
    );
  }

  String _rateLabel(double value) {
    if (value < 0.75) return strings.slow;
    if (value > 0.95) return strings.fast;
    return strings.normal;
  }
}

class _SafetyFirstCard extends StatelessWidget {
  const _SafetyFirstCard({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: WhiteComicItemCard(
        child: Text(
          strings.safetyFirst,
        ),
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  const _SettingCard({required this.title, this.trailing, this.onTap});

  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        child: WhiteComicItemCard(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 360 && trailing != null;
              final titleWidget = Text(
                title,
                maxLines: compact ? 2 : 1,
                overflow: TextOverflow.ellipsis,
                style: comicBody(context, fontSize: 18),
              );
              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleWidget,
                    const SizedBox(height: 8),
                    Align(alignment: Alignment.centerLeft, child: trailing),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: titleWidget),
                  trailing ?? const Icon(Icons.chevron_right),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
