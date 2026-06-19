import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/presentation/auth_providers.dart';
import '../../progress/presentation/progress_providers.dart';
import '../domain/shop_item.dart';

class ShopState {
  const ShopState({
    required this.coins,
    required this.owned,
    required this.equipped,
  });

  final int coins;
  final Set<String> owned;
  final Map<String, String> equipped;
}

final shopProvider = FutureProvider<ShopState>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final userId = ref.watch(currentUserIdProvider) ?? 'guest';
  final progress =
      await ref.watch(progressRepositoryProvider).getProgress(userId);
  return ShopState(
    coins: progress.coins,
    owned: (prefs.getStringList('owned_shop_items') ?? const []).toSet(),
    equipped: {
      'avatar_frame': prefs.getString('avatar_frame') ?? '',
      'active_theme': prefs.getString('active_theme') ?? '',
      'cape_color': prefs.getString('cape_color') ?? '',
      'bubble_color': prefs.getString('bubble_color') ?? '',
    },
  );
});

final activeThemeProvider = FutureProvider<String>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('active_theme') ?? '';
});

final bubbleColorProvider = FutureProvider<String>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('bubble_color') ?? '';
});

final avatarFrameProvider = FutureProvider<String>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('avatar_frame') ?? '';
});

final capeColorProvider = FutureProvider<String>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('cape_color') ?? '';
});

final shopActionsProvider = Provider<ShopActions>((ref) => ShopActions(ref));

class ShopActions {
  const ShopActions(this._ref);

  final Ref _ref;

  Future<bool> buy(ShopItem item) async {
    final userId = _ref.read(currentUserIdProvider) ?? 'guest';
    final repo = _ref.read(progressRepositoryProvider);
    final progress = await repo.getProgress(userId);
    if (progress.coins < item.price) return false;
    await repo.saveProgress(progress.copyWith(coins: progress.coins - item.price));
    final prefs = await SharedPreferences.getInstance();
    final owned = (prefs.getStringList('owned_shop_items') ?? const []).toSet()
      ..add(item.id);
    await prefs.setStringList('owned_shop_items', owned.toList());
    await equip(item);
    _invalidate();
    return true;
  }

  Future<void> equip(ShopItem item) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(item.prefKey, item.prefValue);
    _invalidate();
  }

  void _invalidate() {
    _ref
      ..invalidate(shopProvider)
      ..invalidate(activeThemeProvider)
      ..invalidate(bubbleColorProvider)
      ..invalidate(avatarFrameProvider)
      ..invalidate(capeColorProvider);
  }
}
