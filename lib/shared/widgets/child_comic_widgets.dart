import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/accessibility_service.dart';
import '../../core/services/sound_service.dart';
import 'comic_widgets.dart';

class ChildComicBackground extends StatelessWidget {
  const ChildComicBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AccessibilitySettings>(
      valueListenable: AccessibilityService.settings,
      builder: (context, settings, _) => ColoredBox(
        color: settings.easyReading ? Colors.white : const Color(0xFFFFF8E7),
        child: Stack(
          children: [
            if (!settings.easyReading)
              Positioned.fill(child: CustomPaint(painter: _CreamDotsPainter())),
            child,
          ],
        ),
      ),
    );
  }
}

class ChildCardScreen extends StatelessWidget {
  const ChildCardScreen({
    required this.title,
    required this.child,
    this.backRoute,
    super.key,
  });

  final String title;
  final Widget child;
  final String? backRoute;

  @override
  Widget build(BuildContext context) {
    final screen = Scaffold(
      appBar: AppBar(
        backgroundColor: ComicColors.red,
        foregroundColor: ComicColors.cream,
        leading: backRoute == null
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    context.go(backRoute!);
                  }
                },
              ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: comicDisplay(
            context,
            fontSize: 32,
            color: ComicColors.cream,
          ),
        ),
      ),
      body: ChildComicBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [child],
          ),
        ),
      ),
    );
    if (backRoute == null) return screen;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) context.go(backRoute!);
      },
      child: screen,
    );
  }
}

class PressableComicCard extends StatefulWidget {
  const PressableComicCard({
    required this.child,
    required this.onTap,
    required this.color,
    this.radius = 16,
    super.key,
  });

  final Widget child;
  final VoidCallback onTap;
  final Color color;
  final double radius;

  @override
  State<PressableComicCard> createState() => _PressableComicCardState();
}

class _PressableComicCardState extends State<PressableComicCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: () async {
        await SoundService.instance.tap();
        widget.onTap();
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 90),
        scale: _pressed ? 0.94 : 1,
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            border: Border.all(color: ComicColors.ink, width: 4),
            borderRadius: BorderRadius.circular(widget.radius),
            boxShadow: const [
              BoxShadow(
                color: ComicColors.ink,
                offset: Offset(3, 3),
                blurRadius: 0,
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class WhiteComicItemCard extends StatelessWidget {
  const WhiteComicItemCard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: ComicColors.ink, width: 2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: ComicColors.ink,
            offset: Offset(3, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}

class FloatingStars extends StatefulWidget {
  const FloatingStars({super.key});

  @override
  State<FloatingStars> createState() => _FloatingStarsState();
}

class _FloatingStarsState extends State<FloatingStars>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _StarPainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _CreamDotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final red = Paint()..color = ComicColors.red.withValues(alpha: 0.08);
    for (var y = 0.0; y < size.height; y += 18) {
      for (var x = 0.0; x < size.width; x += 18) {
        canvas.drawCircle(Offset(x, y), 2.1, red);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StarPainter extends CustomPainter {
  const _StarPainter(this.value);

  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final points = [
      Offset(size.width * 0.12, size.height * 0.18),
      Offset(size.width * 0.82, size.height * 0.16),
      Offset(size.width * 0.18, size.height * 0.76),
      Offset(size.width * 0.76, size.height * 0.72),
      Offset(size.width * 0.52, size.height * 0.28),
    ];
    for (var i = 0; i < points.length; i++) {
      final offset = math.sin(value * math.pi + i) * 8;
      paint.color = [
        ComicColors.yellow,
        ComicColors.blue,
        ComicColors.green,
        ComicColors.red,
        ComicColors.purple,
      ][i]
          .withValues(alpha: 0.45);
      canvas.drawCircle(
          points[i] + Offset(0, offset), i.isEven ? 11 : 8, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarPainter oldDelegate) =>
      oldDelegate.value != value;
}
