import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/sound_service.dart';
import '../../../shared/widgets/child_comic_widgets.dart';
import '../../../shared/widgets/comic_widgets.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;
  bool _buttonPressed = false;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChildComicBackground(
        child: SafeArea(
          child: Stack(
            children: [
              const Positioned.fill(child: FloatingStars()),
              LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 48,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: SvgPicture.asset(
                            'assets/branding/logo_light.svg',
                            width: 230,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 14),
                        AnimatedBuilder(
                          animation: _floatController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                0,
                                math.sin(_floatController.value * math.pi) *
                                    -14,
                              ),
                              child: child,
                            );
                          },
                          child: const Center(child: ShivAvatar(size: 176)),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Namaste! I am Shiv! 🤖⚡',
                          textAlign: TextAlign.center,
                          style: comicDisplay(
                            context,
                            fontSize: 46,
                            color: ComicColors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Let's learn about AI together dost!",
                          textAlign: TextAlign.center,
                          style: comicBody(
                            context,
                            fontSize: 22,
                            color: ComicColors.ink,
                          ),
                        ),
                        const SizedBox(height: 24),
                        AnimatedScale(
                          scale: _buttonPressed ? 0.92 : 1,
                          duration: const Duration(milliseconds: 110),
                          child: ComicButton(
                            label: "Let's Go! 🚀",
                            color: ComicColors.red,
                            expand: true,
                            onPressed: _goNext,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _goNext() async {
    setState(() => _buttonPressed = true);
    await SoundService.instance.tap();
    await Future<void>.delayed(const Duration(milliseconds: 130));
    if (!mounted) return;
    setState(() => _buttonPressed = false);
    context.go('/age');
  }
}
