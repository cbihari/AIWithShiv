import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/ads/ad_service.dart';
import '../../../core/ads/ad_stats_service.dart';
import '../../../core/ads/ad_widgets.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/localization/language_service.dart';
import '../../../core/localization/localized_content.dart';
import '../../../shared/models/game.dart';
import '../../../shared/widgets/app_state_widgets.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/child_comic_widgets.dart';
import '../../../shared/widgets/comic_widgets.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../dashboard/presentation/dashboard_providers.dart';
import '../../progress/presentation/progress_providers.dart';
import 'game_providers.dart';

class GamesScreen extends ConsumerWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gamesProvider);
    final progress = ref.watch(gameProgressProvider);
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LanguageService.language,
      builder: (context, language, _) {
        final strings = AppStrings(language);
        return ChildCardScreen(
          title: '🎮 ${strings.aiGames}',
          backRoute: '/dashboard',
          child: AsyncValueView(
            value: games,
            loading: const LessonListShimmer(),
            onRetry: () => ref.invalidate(gamesProvider),
            data: (items) {
              final gameProgress =
                  progress.valueOrNull ?? GameProgress.starter('guest');
              final localizedGames = [
                for (final game in items) LocalizedContent.game(game, language),
              ];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ComicPanel(
                    color: ComicColors.yellow,
                    padding: const EdgeInsets.all(14),
                    borderWidth: 3,
                    child: Text(
                      strings.gamesSafety,
                      textAlign: TextAlign.center,
                      style: comicBody(context, fontSize: 17),
                    ),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 560;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: localizedGames.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: wide ? 2 : 1,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          mainAxisExtent: wide ? 190 : 170,
                        ),
                        itemBuilder: (context, index) {
                          final game = localizedGames[index];
                          return _GameCard(
                            game: game,
                            strings: strings,
                            completed:
                                gameProgress.completedGames.contains(game.id),
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({
    required this.game,
    required this.strings,
    required this.completed,
  });

  final LearningGame game;
  final AppStrings strings;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    final colors = [
      ComicColors.red,
      ComicColors.blue,
      ComicColors.yellow,
      ComicColors.green,
      ComicColors.purple,
    ];
    final color = colors[game.id.hashCode.abs() % colors.length];
    final textColor = color == ComicColors.yellow || color == ComicColors.green
        ? ComicColors.ink
        : ComicColors.cream;
    return PressableComicCard(
      color: color,
      onTap: () => context.push(game.route),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            SizedBox(
              width: 58,
              child: FittedBox(child: Text(_emoji(game.id))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 230,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        game.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: comicDisplay(
                          context,
                          fontSize: 30,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${strings.concept}: ${game.concept}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            comicBody(context, fontSize: 15, color: textColor),
                      ),
                      Text(
                        '⏱ ${strings.minutes(game.durationMinutes)}  ${strings.gameReward(game.xpReward, game.coinReward)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            comicBody(context, fontSize: 14, color: textColor),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Flexible(
                            child: _MiniPill(
                              text: completed
                                  ? strings.completed
                                  : strings.unlocked,
                              color: completed
                                  ? ComicColors.green
                                  : ComicColors.yellow,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: _MiniPill(
                              text: strings.startGame,
                              color: ComicColors.cream,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _emoji(String id) {
    return switch (id) {
      'train_robot' => '🤖',
      'ai_detective' => '🕵️',
      'sort_like_ai' => '🧺',
      'robot_treasure_hunt' => '🗺️',
      'spot_ai_mistake' => '🧠',
      _ => '🎮',
    };
  }
}

class _MiniPill extends StatelessWidget {
  const _MiniPill({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: ComicColors.ink, width: 2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(text, style: comicBody(context, fontSize: 13)),
      ),
    );
  }
}

class GameDetailScreen extends ConsumerStatefulWidget {
  const GameDetailScreen({required this.gameId, super.key});

  final String gameId;

  @override
  ConsumerState<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends ConsumerState<GameDetailScreen> {
  int _score = 0;
  bool _completed = false;
  bool _hasProgress = false;
  int _playKey = 0;

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameProvider(widget.gameId));
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LanguageService.language,
      builder: (context, language, _) {
        final strings = AppStrings(language);
        return AsyncValueView(
          value: game,
          emptyMessage: 'Game not found.',
          isEmpty: (item) => item == null,
          onRetry: () => ref.invalidate(gameProvider(widget.gameId)),
          data: (item) {
            final localizedGame = LocalizedContent.game(item!, language);
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (!didPop) _leaveGame(strings);
              },
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: ComicColors.red,
                  foregroundColor: ComicColors.cream,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => _leaveGame(strings),
                  ),
                  title: Text(
                    localizedGame.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: comicDisplay(
                      context,
                      fontSize: 28,
                      color: ComicColors.cream,
                    ),
                  ),
                ),
                body: ChildComicBackground(
                  child: SafeArea(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        ComicPanel(
                          color: ComicColors.yellow,
                          padding: const EdgeInsets.all(14),
                          borderWidth: 3,
                          child: Text(
                            '${strings.concept}: ${localizedGame.concept}\n${localizedGame.description}',
                            textAlign: TextAlign.center,
                            style: comicBody(context, fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _gameBody(localizedGame, strings),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _gameBody(LearningGame game, AppStrings strings) {
    return KeyedSubtree(
      key: ValueKey('${game.id}-$_playKey'),
      child: switch (game.id) {
        'train_robot' => _TrainRobotGame(
            strings: strings,
            onProgress: _markProgress,
            onDone: (score) => _complete(game, score, strings),
          ),
        'ai_detective' => _AiDetectiveGame(
            strings: strings,
            onProgress: _markProgress,
            onDone: (score) => _complete(game, score, strings),
          ),
        'sort_like_ai' => _SortLikeAiGame(
            strings: strings,
            onProgress: _markProgress,
            onDone: (score) => _complete(game, score, strings),
          ),
        'robot_treasure_hunt' => _RobotTreasureHuntGame(
            strings: strings,
            onProgress: _markProgress,
            onDone: (score) => _complete(game, score, strings),
          ),
        'spot_ai_mistake' => _SpotAiMistakeGame(
            strings: strings,
            onProgress: _markProgress,
            onDone: (score) => _complete(game, score, strings),
          ),
        _ => Text(game.description),
      },
    );
  }

  void _markProgress() {
    if (!_hasProgress && mounted) setState(() => _hasProgress = true);
  }

  Future<void> _leaveGame(AppStrings strings) async {
    if (_hasProgress && !_completed) {
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
    }
    context.go('/games');
  }

  Future<void> _complete(
    LearningGame game,
    int score,
    AppStrings strings,
  ) async {
    if (_completed) return;
    setState(() {
      _completed = true;
      _hasProgress = false;
      _score = score;
    });
    final completion = await ref
        .read(gameCompletionProvider.notifier)
        .completeGame(game: game, score: score);
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ComicColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: ComicColors.ink, width: 4),
        ),
        title: Text(
          _completionMessage(game.id, strings),
          style: comicDisplay(context, fontSize: 30, color: ComicColors.red),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              completion.rewarded
                  ? strings.gameWin(completion.xp, completion.coins)
                  : strings.gameReplayNoReward,
              style: comicBody(context, fontSize: 18),
            ),
            RewardedAdBonusButton(
              rewardKey: 'game_${game.id}_bonus_coins',
              label: 'Watch Short Video for +10 Coins',
              onRewardEarned: () => _awardBonusCoins(10),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/games');
            },
            child: Text(strings.backToGames),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _completed = false;
                _hasProgress = false;
                _score = 0;
                _playKey++;
              });
            },
            child: Text(strings.playAgain),
          ),
        ],
      ),
    );
    await AdService.instance.showInterstitialAd(placement: 'game_complete');
  }

  Future<void> _awardBonusCoins(int coins) async {
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

  String _completionMessage(String id, AppStrings strings) {
    return switch (id) {
      'train_robot' => strings.trainRobotDone,
      'ai_detective' => strings.detectiveDone,
      'sort_like_ai' => strings.sortDone,
      'robot_treasure_hunt' => strings.treasureDone,
      'spot_ai_mistake' => strings.mistakeDone,
      _ => 'Shabash! Score $_score',
    };
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.onTap,
    this.color = ComicColors.yellow,
  });

  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ComicButton(label: label, color: color, onPressed: onTap);
  }
}

class _TrainRobotGame extends StatefulWidget {
  const _TrainRobotGame({
    required this.strings,
    required this.onProgress,
    required this.onDone,
  });

  final AppStrings strings;
  final VoidCallback onProgress;
  final ValueChanged<int> onDone;

  @override
  State<_TrainRobotGame> createState() => _TrainRobotGameState();
}

class _TrainRobotGameState extends State<_TrainRobotGame> {
  final _items = const [
    ('🐱', 'Animal'),
    ('🐶', 'Animal'),
    ('🥭', 'Fruit'),
    ('🍎', 'Fruit'),
    ('🚗', 'Vehicle'),
    ('🚌', 'Vehicle'),
  ];
  var _index = 0;
  var _score = 0;
  String? _feedback;

  @override
  Widget build(BuildContext context) {
    final current = _items[_index];
    return _GamePanel(
      child: Column(
        children: [
          Text(current.$1, style: const TextStyle(fontSize: 76)),
          Text(
            'Teach ShivBot: what is this?',
            textAlign: TextAlign.center,
            style: comicBody(context, fontSize: 22),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _ChoiceButton(
                label: widget.strings.animal,
                onTap: () => _answer('Animal'),
              ),
              _ChoiceButton(
                label: widget.strings.fruit,
                onTap: () => _answer('Fruit'),
                color: ComicColors.green,
              ),
              _ChoiceButton(
                label: widget.strings.vehicle,
                onTap: () => _answer('Vehicle'),
                color: ComicColors.blue,
              ),
            ],
          ),
          if (_feedback != null) _FeedbackText(_feedback!),
        ],
      ),
    );
  }

  void _answer(String value) {
    widget.onProgress();
    final correct = value == _items[_index].$2;
    setState(() {
      if (correct) _score++;
      _feedback = correct ? 'BOOM! Correct! ⚡' : 'Try again next one, dost!';
    });
    Future<void>.delayed(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      if (_index == _items.length - 1) {
        widget.onDone(_score);
      } else {
        setState(() {
          _index++;
          _feedback = null;
        });
      }
    });
  }
}

class _AiDetectiveGame extends StatefulWidget {
  const _AiDetectiveGame({
    required this.strings,
    required this.onProgress,
    required this.onDone,
  });

  final AppStrings strings;
  final VoidCallback onProgress;
  final ValueChanged<int> onDone;

  @override
  State<_AiDetectiveGame> createState() => _AiDetectiveGameState();
}

class _AiDetectiveGameState extends State<_AiDetectiveGame> {
  final _rounds = const [
    ['🍎', '🍎', '🍎', '🍌', '🍎'],
    ['🚗', '🚗', '🚲', '🚗', '🚗'],
    ['🐶', '🐶', '🐱', '🐶', '🐶'],
    ['⭐', '⭐', '⚡', '⭐', '⭐'],
    ['🥭', '🍎', '🍎', '🍎', '🍎'],
  ];
  final _oddIndexes = const [3, 2, 2, 2, 0];
  var _round = 0;
  var _score = 0;

  @override
  Widget build(BuildContext context) {
    return _GamePanel(
      child: Column(
        children: [
          Text('Round ${_round + 1}/5',
              style: comicNumber(context, fontSize: 28)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              for (var i = 0; i < _rounds[_round].length; i++)
                GestureDetector(
                  onTap: () => _answer(i),
                  child: _EmojiTile(_rounds[_round][i]),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _answer(int index) {
    widget.onProgress();
    if (index == _oddIndexes[_round]) _score++;
    if (_round == _rounds.length - 1) {
      widget.onDone(_score);
    } else {
      setState(() => _round++);
    }
  }
}

class _SortLikeAiGame extends StatefulWidget {
  const _SortLikeAiGame({
    required this.strings,
    required this.onProgress,
    required this.onDone,
  });

  final AppStrings strings;
  final VoidCallback onProgress;
  final ValueChanged<int> onDone;

  @override
  State<_SortLikeAiGame> createState() => _SortLikeAiGameState();
}

class _SortLikeAiGameState extends State<_SortLikeAiGame> {
  final _items = const [
    ('🐶', 'Animal'),
    ('🐱', 'Animal'),
    ('🍕', 'Food'),
    ('🍎', 'Food'),
    ('🚗', 'Vehicle'),
    ('🚌', 'Vehicle'),
  ];
  final _answers = <int, String>{};

  @override
  Widget build(BuildContext context) {
    return _GamePanel(
      child: Column(
        children: [
          for (var i = 0; i < _items.length; i++) ...[
            Text(_items[i].$1, style: const TextStyle(fontSize: 42)),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _ChoiceButton(
                  label: widget.strings.animal,
                  onTap: () => _pick(i, 'Animal'),
                ),
                _ChoiceButton(
                  label: widget.strings.food,
                  color: ComicColors.green,
                  onTap: () => _pick(i, 'Food'),
                ),
                _ChoiceButton(
                  label: widget.strings.vehicle,
                  color: ComicColors.blue,
                  onTap: () => _pick(i, 'Vehicle'),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          if (_answers.length == _items.length)
            ComicButton(
              label: widget.strings.check,
              color: ComicColors.red,
              onPressed: _finish,
            ),
        ],
      ),
    );
  }

  void _pick(int index, String category) {
    widget.onProgress();
    setState(() => _answers[index] = category);
  }

  void _finish() {
    var score = 0;
    for (var i = 0; i < _items.length; i++) {
      if (_answers[i] == _items[i].$2) score++;
    }
    widget.onDone(score);
  }
}

class _RobotTreasureHuntGame extends StatefulWidget {
  const _RobotTreasureHuntGame({
    required this.strings,
    required this.onProgress,
    required this.onDone,
  });

  final AppStrings strings;
  final VoidCallback onProgress;
  final ValueChanged<int> onDone;

  @override
  State<_RobotTreasureHuntGame> createState() => _RobotTreasureHuntGameState();
}

class _RobotTreasureHuntGameState extends State<_RobotTreasureHuntGame> {
  var _robot = 0;
  static const _treasure = 15;
  var _moves = 0;

  @override
  Widget build(BuildContext context) {
    return _GamePanel(
      child: Column(
        children: [
          Text(
            widget.strings.algorithmTip,
            textAlign: TextAlign.center,
            style: comicBody(context, fontSize: 18),
          ),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemCount: 16,
              itemBuilder: (context, index) => Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ComicColors.cream,
                  border: Border.all(color: ComicColors.ink, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  index == _robot
                      ? '🤖'
                      : index == _treasure
                          ? '💎'
                          : '',
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _ChoiceButton(label: '⬆', onTap: () => _move(-4)),
              _ChoiceButton(label: '⬇', onTap: () => _move(4)),
              _ChoiceButton(label: '⬅', onTap: () => _move(-1)),
              _ChoiceButton(label: '➡', onTap: () => _move(1)),
            ],
          ),
        ],
      ),
    );
  }

  void _move(int delta) {
    final next = _robot + delta;
    if (next < 0 || next > 15) return;
    if (delta == -1 && _robot % 4 == 0) return;
    if (delta == 1 && _robot % 4 == 3) return;
    widget.onProgress();
    setState(() {
      _robot = next;
      _moves++;
    });
    if (_robot == _treasure) {
      widget.onDone(_moves <= 6 ? 4 : 3);
    }
  }
}

class _SpotAiMistakeGame extends StatefulWidget {
  const _SpotAiMistakeGame({
    required this.strings,
    required this.onProgress,
    required this.onDone,
  });

  final AppStrings strings;
  final VoidCallback onProgress;
  final ValueChanged<int> onDone;

  @override
  State<_SpotAiMistakeGame> createState() => _SpotAiMistakeGameState();
}

class _SpotAiMistakeGameState extends State<_SpotAiMistakeGame> {
  final _statements = const [
    ('Fish can fly in the sky.', false),
    ('A mango is a fruit.', true),
    ('Never share your phone number online.', true),
    ('AI is always correct.', false),
  ];
  var _index = 0;
  var _score = 0;

  @override
  Widget build(BuildContext context) {
    final current = _statements[_index];
    return _GamePanel(
      child: Column(
        children: [
          Text(
            '“${current.$1}”',
            textAlign: TextAlign.center,
            style: comicBody(context, fontSize: 24),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _ChoiceButton(
                label: widget.strings.correct,
                color: ComicColors.green,
                onTap: () => _answer(true),
              ),
              _ChoiceButton(
                label: widget.strings.wrong,
                color: ComicColors.red,
                onTap: () => _answer(false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _answer(bool value) {
    widget.onProgress();
    if (value == _statements[_index].$2) _score++;
    if (_index == _statements.length - 1) {
      widget.onDone(_score);
    } else {
      setState(() => _index++);
    }
  }
}

class _GamePanel extends StatelessWidget {
  const _GamePanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ComicPanel(
      color: Colors.white,
      padding: const EdgeInsets.all(18),
      borderWidth: 4,
      child: child,
    );
  }
}

class _EmojiTile extends StatelessWidget {
  const _EmojiTile(this.emoji);

  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ComicColors.yellow,
        border: Border.all(color: ComicColors.ink, width: 3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(emoji, style: const TextStyle(fontSize: 30)),
    );
  }
}

class _FeedbackText extends StatelessWidget {
  const _FeedbackText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: comicBody(context, fontSize: 18, color: ComicColors.red),
      ),
    );
  }
}
