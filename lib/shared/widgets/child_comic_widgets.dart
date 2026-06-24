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

class SuperheroComicBackground extends StatelessWidget {
  const SuperheroComicBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AccessibilitySettings>(
      valueListenable: AccessibilityService.settings,
      builder: (context, settings, _) => ColoredBox(
        color: settings.easyReading ? Colors.white : ComicColors.cream,
        child: Stack(
          children: [
            if (!settings.easyReading) ...[
              Positioned.fill(child: CustomPaint(painter: _CreamDotsPainter())),
              Positioned.fill(child: CustomPaint(painter: _HeroBurstPainter())),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

class IndianAdventureComicBackground extends StatelessWidget {
  const IndianAdventureComicBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AccessibilitySettings>(
      valueListenable: AccessibilityService.settings,
      builder: (context, settings, _) => ColoredBox(
        color: settings.easyReading ? Colors.white : ComicColors.cream,
        child: Stack(
          children: [
            if (!settings.easyReading) ...[
              Positioned.fill(child: CustomPaint(painter: _CreamDotsPainter())),
              Positioned.fill(
                child: CustomPaint(painter: _IndianAdventurePainter()),
              ),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

class SlapstickComicBackground extends StatelessWidget {
  const SlapstickComicBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AccessibilitySettings>(
      valueListenable: AccessibilityService.settings,
      builder: (context, settings, _) => ColoredBox(
        color: settings.easyReading ? Colors.white : ComicColors.cream,
        child: Stack(
          children: [
            if (!settings.easyReading) ...[
              Positioned.fill(child: CustomPaint(painter: _CreamDotsPainter())),
              Positioned.fill(child: CustomPaint(painter: _SlapstickPainter())),
            ],
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

class _HeroBurstPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width * 0.5, size.height * 0.16);
    final radius = size.shortestSide * 0.62;
    for (var i = 0; i < 18; i++) {
      final start = (math.pi * 2 / 18) * i;
      final end = start + math.pi / 18;
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(center.dx + math.cos(start) * radius,
            center.dy + math.sin(start) * radius)
        ..lineTo(center.dx + math.cos(end) * radius,
            center.dy + math.sin(end) * radius)
        ..close();
      paint.color = (i.isEven ? ComicColors.yellow : ComicColors.blue)
          .withValues(alpha: i.isEven ? 0.18 : 0.1);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _IndianAdventurePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final fill = Paint()..style = PaintingStyle.fill;

    paint.color = ComicColors.yellow.withValues(alpha: 0.28);
    for (var x = -40.0; x < size.width; x += 96) {
      canvas.drawArc(
          Rect.fromLTWH(x, 26, 72, 72), 0.2, math.pi * 1.35, false, paint);
    }

    fill.color = ComicColors.blue.withValues(alpha: 0.1);
    for (var x = 24.0; x < size.width; x += 118) {
      final y = size.height - 96 - (x % 3) * 12;
      canvas.drawCircle(Offset(x, y), 28, fill);
      paint.color = ComicColors.red.withValues(alpha: 0.18);
      canvas.drawCircle(Offset(x, y), 28, paint);
    }

    paint.color = ComicColors.green.withValues(alpha: 0.22);
    for (var x = 58.0; x < size.width; x += 132) {
      final y = size.height * 0.54;
      canvas.drawLine(Offset(x, y), Offset(x + 34, y - 22), paint);
      canvas.drawLine(Offset(x + 34, y - 22), Offset(x + 68, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SlapstickPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final marks = [
      (ComicColors.red, Offset(size.width * 0.1, size.height * 0.2), 52.0),
      (ComicColors.blue, Offset(size.width * 0.84, size.height * 0.24), 46.0),
      (ComicColors.yellow, Offset(size.width * 0.18, size.height * 0.78), 42.0),
      (ComicColors.green, Offset(size.width * 0.82, size.height * 0.72), 56.0),
    ];
    for (final mark in marks) {
      paint.color = mark.$1.withValues(alpha: 0.26);
      final c = mark.$2;
      for (var i = 0; i < 4; i++) {
        final angle = -0.7 + i * 0.45;
        canvas.drawLine(
          c,
          c + Offset(math.cos(angle) * mark.$3, math.sin(angle) * mark.$3),
          paint,
        );
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
