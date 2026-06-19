import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_state_widgets.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/child_comic_widgets.dart';
import '../../../shared/widgets/comic_widgets.dart';
import '../domain/shop_item.dart';
import 'shop_providers.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: ShopCategory.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shop = ref.watch(shopProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) context.go('/dashboard');
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ComicColors.yellow,
          foregroundColor: ComicColors.ink,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/dashboard'),
          ),
          title: Text(
            '🪙 Shiv\'s Shop',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: comicDisplay(context, fontSize: 34, color: ComicColors.red),
          ),
          bottom: TabBar(
            controller: _tabController,
            labelStyle: comicBody(context, fontSize: 15),
            tabs: const [
              Tab(text: 'Frames'),
              Tab(text: 'Themes'),
              Tab(text: 'Costumes'),
              Tab(text: 'Bubbles'),
            ],
          ),
        ),
        body: ChildComicBackground(
          child: SafeArea(
            child: AsyncValueView(
              value: shop,
              loading: const LessonListShimmer(),
              onRetry: () => ref.invalidate(shopProvider),
              data: (state) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: ComicPanel(
                      color: ComicColors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 12),
                      borderWidth: 3,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Your coins',
                              style: comicBody(context,
                                  fontSize: 18, color: ComicColors.cream),
                            ),
                          ),
                          Text(
                            '🪙 ${state.coins}',
                            style: comicNumber(context,
                                fontSize: 34, color: ComicColors.yellow),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.coins == 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: EmptyStateWidget(
                        emoji: '🪙',
                        message: 'You need coins to buy things dost!',
                        subtitle: 'Complete quizzes to earn coins! ⚡',
                        buttonLabel: 'Go Learn! 📚',
                        onPressed: () => context.go('/learning-path'),
                      ),
                    ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        for (final category in ShopCategory.values)
                          _ItemGrid(
                            category: category,
                            state: state,
                            onBuy: _confirmBuy,
                            onEquip: _equip,
                          ),
                      ],
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

  Future<void> _confirmBuy(ShopItem item, ShopState state) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Spend coins?', style: comicDisplay(context, fontSize: 30)),
        content: Text(
          'Spend ${item.price} coins on ${item.name}? You have ${state.coins} coins.',
          style: comicBody(context, fontSize: 18),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('NO')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('YES')),
        ],
      ),
    );
    if (confirmed != true) return;
    final bought = await ref.read(shopActionsProvider).buy(item);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          bought
              ? 'Equipped! Looking cool dost! 😎'
              : 'Need more coins dost! 🪙',
        ),
      ),
    );
  }

  Future<void> _equip(ShopItem item) async {
    await ref.read(shopActionsProvider).equip(item);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Equipped! Looking cool dost! 😎')),
    );
  }
}

class _ItemGrid extends StatelessWidget {
  const _ItemGrid({
    required this.category,
    required this.state,
    required this.onBuy,
    required this.onEquip,
  });

  final ShopCategory category;
  final ShopState state;
  final void Function(ShopItem item, ShopState state) onBuy;
  final void Function(ShopItem item) onEquip;

  @override
  Widget build(BuildContext context) {
    final items = shopItems.where((item) => item.category == category).toList();
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        final owned = state.owned.contains(item.id);
        final equipped = state.equipped[item.prefKey] == item.prefValue;
        final canBuy = state.coins >= item.price;
        return WhiteComicItemCard(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Text(item.emoji, style: const TextStyle(fontSize: 54)),
                ),
              ),
              Text(
                item.name,
                textAlign: TextAlign.center,
                style: comicBody(context, fontSize: 17),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: owned ? ComicColors.green : ComicColors.yellow,
                  border: Border.all(color: ComicColors.ink, width: 2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  owned ? 'OWNED ✅' : '🪙 ${item.price}',
                  style: comicBody(context, fontSize: 13),
                ),
              ),
              const SizedBox(height: 10),
              if (owned)
                ComicButton(
                  label: equipped ? 'EQUIPPED' : 'EQUIP',
                  color: equipped ? ComicColors.green : ComicColors.red,
                  onPressed: equipped ? null : () => onEquip(item),
                )
              else
                ComicButton(
                  label: canBuy
                      ? 'BUY 🪙 ${item.price}'
                      : 'Need ${item.price - state.coins} more 🪙',
                  color: canBuy ? ComicColors.red : Colors.grey.shade300,
                  onPressed: canBuy ? () => onBuy(item, state) : null,
                ),
            ],
          ),
        );
      },
    );
  }
}
