import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'comic_widgets.dart';

class ComicShimmer extends StatelessWidget {
  const ComicShimmer({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFEEEEEE),
      highlightColor: const Color(0xFFFFFBF0),
      period: const Duration(milliseconds: 1500),
      direction: ShimmerDirection.ltr,
      child: child,
    );
  }
}

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    required this.height,
    this.width,
    this.radius = 14,
    super.key,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
      children: [
        const SizedBox(height: 250, child: Center(child: Text('🤖', style: TextStyle(fontSize: 90)))),
        ComicShimmer(
          child: Column(
            children: [
              const ShimmerBox(height: 72),
              const SizedBox(height: 22),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.04,
                children: const [
                  ShimmerBox(height: 140),
                  ShimmerBox(height: 140),
                  ShimmerBox(height: 140),
                  ShimmerBox(height: 140),
                ],
              ),
              const SizedBox(height: 22),
              const ShimmerBox(height: 76),
            ],
          ),
        ),
      ],
    );
  }
}

class LessonListShimmer extends StatelessWidget {
  const LessonListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ComicShimmer(
      child: Column(
        children: [
          for (var i = 0; i < 5; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: 220, height: 22),
                    SizedBox(height: 12),
                    ShimmerBox(height: 14),
                    SizedBox(height: 8),
                    ShimmerBox(width: 180, height: 14),
                    SizedBox(height: 16),
                    ShimmerBox(width: 130, height: 38, radius: 999),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class QuizShimmer extends StatelessWidget {
  const QuizShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ComicColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: ComicShimmer(
            child: Column(
              children: [
                const ShimmerBox(height: 130),
                const SizedBox(height: 28),
                for (var i = 0; i < 4; i++) ...[
                  const ShimmerBox(height: 68),
                  const SizedBox(height: 14),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BadgeGridShimmer extends StatelessWidget {
  const BadgeGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ComicShimmer(
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(child: ShimmerBox(height: 88)),
              SizedBox(width: 12),
              Expanded(child: ShimmerBox(height: 88)),
              SizedBox(width: 12),
              Expanded(child: ShimmerBox(height: 88)),
            ],
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              for (var i = 0; i < 6; i++)
                const CircleAvatar(radius: 42, backgroundColor: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ComicShimmer(
      child: Column(
        children: [
          const ShimmerBox(height: 260, radius: 24),
          const SizedBox(height: 18),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.35,
            children: const [
              ShimmerBox(height: 100),
              ShimmerBox(height: 100),
              ShimmerBox(height: 100),
              ShimmerBox(height: 100),
            ],
          ),
        ],
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    required this.emoji,
    required this.message,
    this.subtitle,
    this.buttonLabel,
    this.onPressed,
    super.key,
  });

  final String emoji;
  final String message;
  final String? subtitle;
  final String? buttonLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 78)),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: comicBody(context, fontSize: 22)),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(subtitle!, textAlign: TextAlign.center, style: comicBody(context, fontSize: 17)),
            ],
            if (buttonLabel != null && onPressed != null) ...[
              const SizedBox(height: 18),
              ComicButton(label: buttonLabel!, color: ComicColors.red, onPressed: onPressed),
            ],
          ],
        ),
      ),
    );
  }
}

class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    this.emoji = '🤖💤',
    this.message = 'Shiv HQ is busy! 🛸 Tap to try again!',
    this.buttonLabel = 'Refresh ↻',
    this.onRetry,
    super.key,
  });

  final String emoji;
  final String message;
  final String buttonLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      emoji: emoji,
      message: message,
      buttonLabel: buttonLabel,
      onPressed: onRetry,
    );
  }
}

class OfflinePill extends StatelessWidget {
  const OfflinePill({required this.visible, super.key});

  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: ComicColors.yellow,
        border: Border.all(color: ComicColors.ink, width: 2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text('📶 Offline Mode', style: comicBody(context, fontSize: 13)),
    );
  }
}

class ParticleWidget extends StatefulWidget {
  const ParticleWidget({super.key});

  @override
  State<ParticleWidget> createState() => _ParticleWidgetState();
}

class _ParticleWidgetState extends State<ParticleWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => CustomPaint(
          painter: _ParticlePainter(_controller.value),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  const _ParticlePainter(this.value);

  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final colors = [ComicColors.red, ComicColors.yellow, ComicColors.blue, ComicColors.green];
    const count = 15;
    for (var i = 0; i < count; i++) {
      final angle = i * math.pi * 2 / count;
      final distance = 30 + value * 140;
      final paint = Paint()
        ..color = colors[i % colors.length].withValues(alpha: 1 - value);
      canvas.drawCircle(center + Offset(math.cos(angle), math.sin(angle)) * distance, 5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => oldDelegate.value != value;
}
