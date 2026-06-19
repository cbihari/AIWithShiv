import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/localization/language_service.dart';
import '../../../core/localization/localized_content.dart';
import '../../../shared/widgets/app_state_widgets.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/child_comic_widgets.dart';
import '../../../shared/widgets/comic_widgets.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../progress/presentation/progress_providers.dart';
import 'lesson_providers.dart';

class LearningPathScreen extends ConsumerWidget {
  const LearningPathScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(coursesProvider);
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LanguageService.language,
      builder: (context, language, _) {
        final strings = AppStrings(language);
        return ChildCardScreen(
          title: strings.learningPath,
          backRoute: '/dashboard',
          child: AsyncValueView(
            value: courses,
            isEmpty: (items) => items.isEmpty,
            emptyEmoji: '🤖🤔',
            emptyMessage: language == AppLanguage.hindi
                ? 'अभी lessons नहीं हैं dost!'
                : 'Hmm, no lessons here yet dost!',
            emptySubtitle: language == AppLanguage.hindi
                ? 'Shiv missions तैयार कर रहा है! 🛸'
                : 'Check back soon! Shiv is preparing missions! 🛸',
            onRetry: () => ref.invalidate(coursesProvider),
            loading: const LessonListShimmer(),
            data: (items) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final rawCourse in items) ...[
                  Builder(builder: (context) {
                    final course = LocalizedContent.course(rawCourse, language);
                    return _CourseHeader(
                      strings: strings,
                      title: course.title,
                      description: course.description,
                      xp: course.xp,
                      totalLessons: course.lessonIds.length,
                    );
                  }),
                  const SizedBox(height: 18),
                  _LessonStack(
                    language: language,
                    courseId: rawCourse.id,
                    totalLessons: rawCourse.lessonIds.length,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LessonStack extends ConsumerWidget {
  const _LessonStack({
    required this.language,
    required this.courseId,
    required this.totalLessons,
  });

  final AppLanguage language;
  final String courseId;
  final int totalLessons;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessons = ref.watch(lessonsForCourseProvider(courseId));
    final userId = ref.watch(currentUserIdProvider) ?? 'guest';
    final completed =
        ref.watch(userProgressProvider(userId)).valueOrNull?.completedLessons ??
            const <String>[];
    return AsyncValueView(
      value: lessons,
      isEmpty: (items) => items.isEmpty,
      emptyEmoji: '🤖🤔',
      emptyMessage: language == AppLanguage.hindi
          ? 'अभी lessons नहीं हैं dost!'
          : 'Hmm, no lessons here yet dost!',
      emptySubtitle: language == AppLanguage.hindi
          ? 'Shiv missions तैयार कर रहा है! 🛸'
          : 'Check back soon! Shiv is preparing missions! 🛸',
      onRetry: () => ref.invalidate(lessonsForCourseProvider(courseId)),
      loading: const LessonListShimmer(),
      data: (items) {
        final localizedItems = [
          for (final item in items) LocalizedContent.lesson(item, language),
        ];
        return RefreshIndicator(
          displacement: 24,
          semanticsLabel: language == AppLanguage.hindi
              ? 'Shiv HQ से sync हो रहा है! 🛸'
              : 'Syncing with Shiv HQ! 🛸',
          onRefresh: () async =>
              ref.invalidate(lessonsForCourseProvider(courseId)),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: localizedItems.length,
            itemBuilder: (context, i) => _MissionPathItem(
              showLine: i < localizedItems.length - 1,
              child: _LessonCard(
                number: localizedItems[i].order,
                title: localizedItems[i].title,
                xp: localizedItems[i].xp,
                minutes: localizedItems[i].durationMinutes,
                concepts: localizedItems[i].concepts,
                completed: completed.contains(localizedItems[i].id),
                current: !completed.contains(localizedItems[i].id) &&
                    (i == 0 || completed.contains(localizedItems[i - 1].id)),
                locked: i > 0 && !completed.contains(localizedItems[i - 1].id),
                alignRight: i.isOdd,
                onTap: () => context.go('/lesson/${localizedItems[i].id}'),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CourseHeader extends ConsumerWidget {
  const _CourseHeader({
    required this.strings,
    required this.title,
    required this.description,
    required this.xp,
    required this.totalLessons,
  });

  final AppStrings strings;
  final String title;
  final String description;
  final int xp;
  final int totalLessons;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compact = MediaQuery.sizeOf(context).width < 360;
    final userId = ref.watch(currentUserIdProvider) ?? 'guest';
    final progress = ref.watch(userProgressProvider(userId)).valueOrNull;
    final done =
        (progress?.completedLessons.length ?? 0).clamp(0, totalLessons);
    return Container(
      padding: EdgeInsets.all(compact ? 14 : 18),
      decoration: BoxDecoration(
        color: ComicColors.red,
        border: Border.all(color: ComicColors.ink, width: 4),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: ComicColors.ink, offset: Offset(3, 3), blurRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: comicDisplay(
                    context,
                    fontSize: compact ? 30 : 38,
                    color: ComicColors.cream,
                  ),
                ),
              ),
              SizedBox(width: compact ? 8 : 12),
              Container(
                constraints: BoxConstraints(maxWidth: compact ? 78 : 108),
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 8 : 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: ComicColors.yellow,
                  border: Border.all(color: ComicColors.ink, width: 3),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '⚡ $xp XP',
                    style: comicBody(
                      context,
                      fontSize: compact ? 14 : 16,
                      color: ComicColors.ink,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(
            description,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: comicBody(
              context,
              fontSize: compact ? 15 : 16,
              color: ComicColors.cream,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            strings.lessonsDone(done, totalLessons),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: comicBody(
              context,
              fontSize: compact ? 15 : 16,
              color: ComicColors.cream,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 14,
              value: totalLessons == 0 ? 0 : done / totalLessons,
              backgroundColor: ComicColors.cream,
              color: ComicColors.yellow,
            ),
          ),
        ],
      ),
    );
  }
}

class _MissionPathItem extends StatelessWidget {
  const _MissionPathItem({required this.child, required this.showLine});

  final Widget child;
  final bool showLine;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        child,
        if (showLine)
          SizedBox(
            height: 26,
            child: CustomPaint(
              painter: _DottedLinePainter(),
              size: const Size(2, 26),
            ),
          ),
      ],
    );
  }
}

class _LessonCard extends StatefulWidget {
  const _LessonCard({
    required this.number,
    required this.title,
    required this.xp,
    required this.minutes,
    required this.concepts,
    required this.completed,
    required this.current,
    required this.locked,
    required this.alignRight,
    required this.onTap,
  });

  final int number;
  final String title;
  final int xp;
  final int minutes;
  final List<String> concepts;
  final bool completed;
  final bool current;
  final bool locked;
  final bool alignRight;
  final VoidCallback onTap;

  @override
  State<_LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<_LessonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 360;
    final borderColor = widget.completed
        ? ComicColors.green
        : widget.current
            ? ComicColors.red
            : Colors.grey;
    return Align(
      alignment:
          widget.alignRight ? Alignment.centerRight : Alignment.centerLeft,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          final pulseWidth = widget.current ? 5 + (_pulse.value * 2) : 5.0;
          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: borderColor, width: pulseWidth),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: child,
            ),
          );
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: widget.locked ? null : widget.onTap,
            child: WhiteComicItemCard(
              child: Opacity(
                opacity: widget.locked ? 0.55 : 1,
                child:
                    compact ? _compactContent(context) : _wideContent(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _wideContent(BuildContext context) {
    return Row(
      children: [
        _NumberBadge(
          number: widget.number,
          completed: widget.completed,
          locked: widget.locked,
          compact: false,
        ),
        const SizedBox(width: 14),
        Expanded(child: _LessonTextBlock(widget: widget, compact: false)),
        _TrailingStatus(widget: widget, compact: false),
      ],
    );
  }

  Widget _compactContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NumberBadge(
              number: widget.number,
              completed: widget.completed,
              locked: widget.locked,
              compact: true,
            ),
            const SizedBox(width: 10),
            Expanded(child: _LessonTextBlock(widget: widget, compact: true)),
          ],
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: _TrailingStatus(widget: widget, compact: true),
        ),
      ],
    );
  }
}

class _NumberBadge extends StatelessWidget {
  const _NumberBadge({
    required this.number,
    required this.completed,
    required this.locked,
    required this.compact,
  });

  final int number;
  final bool completed;
  final bool locked;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: compact ? 24 : 28,
      backgroundColor: completed
          ? ComicColors.green
          : locked
              ? Colors.grey
              : ComicColors.red,
      child: Text(
        locked ? '🔒' : '$number',
        style: comicNumber(
          context,
          fontSize: locked ? 20 : (compact ? 28 : 32),
          color: ComicColors.cream,
        ),
      ),
    );
  }
}

class _LessonTextBlock extends StatelessWidget {
  const _LessonTextBlock({required this.widget, required this.compact});

  final _LessonCard widget;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          maxLines: compact ? 3 : 2,
          overflow: TextOverflow.ellipsis,
          style: comicBody(
            context,
            fontSize: compact ? 18 : 20,
            color: ComicColors.ink,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          widget.completed
              ? 'Completed! Shabash!'
              : widget.locked
                  ? 'Complete previous lesson first'
                  : '⏱ ${widget.minutes} min   ⚡ ${widget.xp} XP',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: comicBody(
            context,
            fontSize: compact ? 14 : 16,
            color: widget.completed
                ? ComicColors.green
                : widget.locked
                    ? Colors.grey.shade700
                    : ComicColors.ink,
          ),
        ),
        if (widget.current) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final concept in widget.concepts.take(3))
                Container(
                  constraints: BoxConstraints(maxWidth: compact ? 118 : 170),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: ComicColors.yellow,
                    border: Border.all(
                      color: ComicColors.ink,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    concept,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: comicBody(context, fontSize: compact ? 11 : 12),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _TrailingStatus extends StatelessWidget {
  const _TrailingStatus({required this.widget, required this.compact});

  final _LessonCard widget;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (widget.completed) {
      return Icon(
        Icons.check_circle,
        color: ComicColors.green,
        size: compact ? 30 : 36,
      );
    }
    if (widget.current) {
      return Container(
        constraints: BoxConstraints(maxWidth: compact ? 92 : 110),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 10,
          vertical: compact ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: ComicColors.red,
          border: Border.all(color: ComicColors.ink, width: 2),
          borderRadius: BorderRadius.circular(999),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '▶ START',
            style: comicBody(
              context,
              fontSize: 12,
              color: ComicColors.cream,
            ),
          ),
        ),
      );
    }
    if (!widget.locked) {
      return Container(
        constraints: BoxConstraints(maxWidth: compact ? 76 : 90),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 10,
          vertical: compact ? 5 : 6,
        ),
        decoration: BoxDecoration(
          color: ComicColors.yellow,
          border: Border.all(color: ComicColors.ink, width: 2),
          borderRadius: BorderRadius.circular(999),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '${widget.xp} XP',
            style: comicBody(context, fontSize: compact ? 13 : 14),
          ),
        ),
      );
    }
    return Icon(Icons.lock, size: compact ? 26 : 30, color: Colors.grey);
  }
}

class _DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ComicColors.ink
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (var y = 0.0; y < size.height; y += 8) {
      canvas.drawCircle(Offset(size.width / 2, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
