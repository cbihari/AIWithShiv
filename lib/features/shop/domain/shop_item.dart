enum ShopCategory { frames, themes, costumes, bubbles }

class ShopItem {
  const ShopItem({
    required this.id,
    required this.category,
    required this.name,
    required this.emoji,
    required this.price,
    required this.prefKey,
    required this.prefValue,
  });

  final String id;
  final ShopCategory category;
  final String name;
  final String emoji;
  final int price;
  final String prefKey;
  final String prefValue;
}

const shopItems = [
  ShopItem(id: 'star-frame', category: ShopCategory.frames, name: 'Star Frame', emoji: '🌟', price: 50, prefKey: 'avatar_frame', prefValue: 'star'),
  ShopItem(id: 'fire-frame', category: ShopCategory.frames, name: 'Fire Frame', emoji: '🔥', price: 75, prefKey: 'avatar_frame', prefValue: 'fire'),
  ShopItem(id: 'lightning-frame', category: ShopCategory.frames, name: 'Lightning Frame', emoji: '⚡', price: 100, prefKey: 'avatar_frame', prefValue: 'lightning'),
  ShopItem(id: 'rainbow-frame', category: ShopCategory.frames, name: 'Rainbow Frame', emoji: '🌈', price: 150, prefKey: 'avatar_frame', prefValue: 'rainbow'),
  ShopItem(id: 'night-theme', category: ShopCategory.themes, name: 'Night Mission', emoji: '🌙', price: 80, prefKey: 'active_theme', prefValue: 'night'),
  ShopItem(id: 'jungle-theme', category: ShopCategory.themes, name: 'Jungle Hero', emoji: '🌿', price: 80, prefKey: 'active_theme', prefValue: 'jungle'),
  ShopItem(id: 'festival-theme', category: ShopCategory.themes, name: 'Festival Mode', emoji: '🎪', price: 100, prefKey: 'active_theme', prefValue: 'festival'),
  ShopItem(id: 'blue-cape', category: ShopCategory.costumes, name: 'Blue Cape', emoji: '🔵', price: 60, prefKey: 'cape_color', prefValue: 'blue'),
  ShopItem(id: 'green-cape', category: ShopCategory.costumes, name: 'Green Cape', emoji: '🟢', price: 60, prefKey: 'cape_color', prefValue: 'green'),
  ShopItem(id: 'gold-cape', category: ShopCategory.costumes, name: 'Gold Cape', emoji: '🟡', price: 120, prefKey: 'cape_color', prefValue: 'gold'),
  ShopItem(id: 'rainbow-cape', category: ShopCategory.costumes, name: 'Rainbow Cape', emoji: '🌈', price: 200, prefKey: 'cape_color', prefValue: 'rainbow'),
  ShopItem(id: 'purple-bubbles', category: ShopCategory.bubbles, name: 'Purple Bubbles', emoji: '💜', price: 40, prefKey: 'bubble_color', prefValue: 'purple'),
  ShopItem(id: 'dark-bubbles', category: ShopCategory.bubbles, name: 'Dark Mode Bubbles', emoji: '🖤', price: 40, prefKey: 'bubble_color', prefValue: 'dark'),
  ShopItem(id: 'pink-bubbles', category: ShopCategory.bubbles, name: 'Pink Bubbles', emoji: '🩷', price: 40, prefKey: 'bubble_color', prefValue: 'pink'),
];
