import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ComicColors {
  const ComicColors._();

  static const red = Color(0xFFD32F2F);
  static const yellow = Color(0xFFFFC52D);
  static const blue = Color(0xFF0077FF);
  static const green = Color(0xFF4CAF50);
  static const navy = Color(0xFF1A1A2E);
  static const cream = Color(0xFFFFF8E7);
  static const ink = Color(0xFF1A1A1A);
  static const saffron = Color(0xFFFF8A00);
  static const purple = Color(0xFF8B4CF6);
}

TextStyle comicDisplay(
  BuildContext context, {
  double? fontSize,
  Color? color,
  double height = 0.95,
}) {
  return GoogleFonts.bangers(
    textStyle: Theme.of(context).textTheme.displayMedium,
    fontSize: fontSize,
    height: height,
    letterSpacing: 0,
    color: color,
  );
}

TextStyle comicBody(
  BuildContext context, {
  double? fontSize,
  FontWeight fontWeight = FontWeight.w900,
  Color? color,
}) {
  return GoogleFonts.nunito(
    textStyle: Theme.of(context).textTheme.bodyLarge,
    fontSize: fontSize,
    fontWeight: fontWeight,
    letterSpacing: 0,
    color: color,
  );
}

TextStyle comicNumber(
  BuildContext context, {
  double? fontSize,
  Color? color,
}) {
  return GoogleFonts.boogaloo(
    textStyle: Theme.of(context).textTheme.displaySmall,
    fontSize: fontSize,
    letterSpacing: 0,
    color: color,
  );
}

class ComicBackground extends StatelessWidget {
  const ComicBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ComicColors.navy,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _CosmicPainter()),
          ),
          Positioned.fill(
            child: CustomPaint(painter: _HalftonePainter(opacity: 0.12)),
          ),
          child,
        ],
      ),
    );
  }
}

class ComicPanel extends StatelessWidget {
  const ComicPanel({
    required this.child,
    this.color = ComicColors.cream,
    this.padding = const EdgeInsets.all(18),
    this.radius = 24,
    this.showDots = true,
    this.borderWidth = 5,
    super.key,
  });

  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bool showDots;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: ComicColors.ink, width: borderWidth),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(
            color: ComicColors.ink,
            offset: Offset(6, 6),
            blurRadius: 0,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (showDots)
            Positioned.fill(
              child: CustomPaint(painter: _HalftonePainter(opacity: 0.13)),
            ),
          Padding(padding: padding, child: child),
        ],
      ),
    );
  }
}

class ComicButton extends StatefulWidget {
  const ComicButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = ComicColors.yellow,
    this.expand = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color color;
  final bool expand;

  @override
  State<ComicButton> createState() => _ComicButtonState();
}

class _ComicButtonState extends State<ComicButton> {
  bool _hovering = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final foreground = widget.color == ComicColors.red ||
            widget.color == ComicColors.blue ||
            widget.color == ComicColors.purple
        ? ComicColors.cream
        : ComicColors.ink;
    final angle =
        _hovering ? math.sin(DateTime.now().millisecond / 60) * 0.02 : 0.0;
    final button = AnimatedScale(
      duration: const Duration(milliseconds: 120),
      scale: _hovering && enabled ? 1.03 : 1,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 90),
        offset: _pressed ? const Offset(0.035, 0.035) : Offset.zero,
        child: Transform.rotate(
          angle: angle,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: enabled ? widget.color : Colors.grey.shade300,
              border: Border.all(color: ComicColors.ink, width: 4),
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                if (!_pressed)
                  const BoxShadow(
                    color: ComicColors.ink,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: widget.onPressed,
                onTapDown:
                    enabled ? (_) => setState(() => _pressed = true) : null,
                onTapCancel: () => setState(() => _pressed = false),
                onTapUp: (_) => setState(() => _pressed = false),
                onHover: (value) => setState(() => _hovering = value),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisSize:
                        widget.expand ? MainAxisSize.max : MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: ComicColors.ink),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Text(
                          widget.label,
                          textAlign: TextAlign.center,
                          style: comicBody(
                            context,
                            fontSize: 16,
                            color: enabled ? foreground : ComicColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return widget.expand
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}

class ComicTopBar extends StatelessWidget {
  const ComicTopBar({
    required this.xp,
    required this.maxXp,
    required this.onProfile,
    required this.festivalMode,
    required this.onFestivalToggle,
    super.key,
  });

  final int xp;
  final int maxXp;
  final VoidCallback onProfile;
  final bool festivalMode;
  final VoidCallback onFestivalToggle;

  @override
  Widget build(BuildContext context) {
    return ComicPanel(
      padding: const EdgeInsets.all(12),
      showDots: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 860;
          final logo = _Logo(compact: compact);
          final xpBar = XpBar(xp: xp, maxXp: maxXp);
          final festival = ComicButton(
            label: festivalMode ? 'Diwali glow on' : 'Festival mode',
            onPressed: onFestivalToggle,
            icon: Icons.local_fire_department,
            color: ComicColors.yellow,
            expand: compact,
          );
          final avatar = IconButton(
            tooltip: 'Profile',
            onPressed: onProfile,
            icon: const ShivAvatar(size: 58, compact: true),
          );
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(children: [Expanded(child: logo), avatar]),
                const SizedBox(height: 10),
                xpBar,
                const SizedBox(height: 10),
                festival,
              ],
            );
          }
          return Row(
            children: [
              logo,
              const SizedBox(width: 16),
              Expanded(child: xpBar),
              const SizedBox(width: 14),
              festival,
              const SizedBox(width: 8),
              avatar,
            ],
          );
        },
      ),
    );
  }
}

class XpBar extends StatelessWidget {
  const XpBar({required this.xp, required this.maxXp, super.key});

  final int xp;
  final int maxXp;

  @override
  Widget build(BuildContext context) {
    final progress = maxXp == 0 ? 0.0 : (xp / maxXp).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text('Hero XP', style: comicNumber(context, fontSize: 24)),
            const Spacer(),
            Text('$xp / $maxXp', style: comicNumber(context, fontSize: 24)),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          height: 25,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: ComicColors.ink, width: 4),
            borderRadius: BorderRadius.circular(999),
          ),
          clipBehavior: Clip.antiAlias,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: progress,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ComicColors.red,
                      ComicColors.saffron,
                      ComicColors.yellow
                    ],
                  ),
                ),
                child: SizedBox.expand(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ShivAvatar extends StatefulWidget {
  const ShivAvatar({this.size = 260, this.compact = false, super.key});

  final double size;
  final bool compact;

  @override
  State<ShivAvatar> createState() => _ShivAvatarState();
}

class _ShivAvatarState extends State<ShivAvatar> {
  Timer? _blinkTimer;
  bool _blink = false;

  @override
  void initState() {
    super.initState();
    _blinkTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      setState(() => _blink = true);
      Timer(const Duration(milliseconds: 120), () {
        if (mounted) setState(() => _blink = false);
      });
    });
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(widget.size),
      painter: _ShivPainter(
        blink: _blink,
        compact: widget.compact,
      ),
    );
  }
}

class SpeechBubble extends StatelessWidget {
  const SpeechBubble({required this.text, this.maxWidth = 320, super.key});

  final String text;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Transform.rotate(
        angle: -0.035,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ComicColors.cream,
            border: Border.all(color: ComicColors.ink, width: 5),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(26),
              topRight: Radius.circular(26),
              bottomRight: Radius.circular(26),
              bottomLeft: Radius.circular(7),
            ),
            boxShadow: const [
              BoxShadow(
                color: ComicColors.ink,
                offset: Offset(4, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Text(text, style: comicBody(context, fontSize: 18)),
        ),
      ),
    );
  }
}

class ActionBurst extends StatelessWidget {
  const ActionBurst({
    required this.text,
    this.color = ComicColors.yellow,
    this.textColor = ComicColors.red,
    this.small = false,
    super.key,
  });

  final String text;
  final Color color;
  final Color textColor;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.09,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: small ? 12 : 18,
          vertical: small ? 7 : 10,
        ),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: ComicColors.ink, width: 5),
          borderRadius: BorderRadius.circular(999),
          boxShadow: const [
            BoxShadow(
              color: ComicColors.ink,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Text(
          text,
          style: comicDisplay(
            context,
            fontSize: small ? 28 : 48,
            color: textColor,
          ).copyWith(
            shadows: const [
              Shadow(color: Colors.white, offset: Offset(2, 2)),
            ],
          ),
        ),
      ),
    );
  }
}

class SubjectMissionCard extends StatelessWidget {
  const SubjectMissionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.dark = false,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return ComicPanel(
      color: color,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: ComicColors.cream,
              border: Border.all(color: ComicColors.ink, width: 5),
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                  color: ComicColors.ink,
                  offset: Offset(4, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Icon(icon, size: 42, color: ComicColors.ink),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: comicDisplay(
              context,
              fontSize: 36,
              color: dark ? Colors.white : ComicColors.ink,
            ).copyWith(
              shadows: [
                Shadow(
                  color: dark ? ComicColors.ink : Colors.white,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              subtitle,
              style: comicBody(
                context,
                fontSize: 16,
                color: dark ? Colors.white : ComicColors.ink,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ComicButton(
            label: 'Start mission',
            onPressed: onTap,
            color: ComicColors.yellow,
            expand: true,
          ),
        ],
      ),
    );
  }
}

class DiyaRow extends StatelessWidget {
  const DiyaRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _Diya(),
        _Diya(),
        _Diya(),
        _Diya(),
        _Diya(),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/branding/logo_light.svg',
          width: compact ? 170 : 250,
          height: compact ? 44 : 64,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}

class _Diya extends StatelessWidget {
  const _Diya();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 15,
          height: 22,
          decoration: BoxDecoration(
            color: ComicColors.yellow,
            border: Border.all(color: ComicColors.ink, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Container(
          width: 42,
          height: 24,
          decoration: BoxDecoration(
            color: ComicColors.saffron,
            border: Border.all(color: ComicColors.ink, width: 3),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
              topLeft: Radius.circular(7),
              topRight: Radius.circular(7),
            ),
          ),
        ),
      ],
    );
  }
}

class _HalftonePainter extends CustomPainter {
  _HalftonePainter({required this.opacity});

  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = ComicColors.ink.withValues(alpha: opacity);
    for (double y = 7; y < size.height; y += 14) {
      for (double x = 7; x < size.width; x += 14) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HalftonePainter oldDelegate) {
    return oldDelegate.opacity != opacity;
  }
}

class _CosmicPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.shader = const LinearGradient(
      colors: [Color(0xFF251F56), ComicColors.navy, Color(0xFF420F32)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, paint);

    paint.shader = null;
    paint.color = ComicColors.yellow.withValues(alpha: 0.22);
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.12),
        size.width * 0.22, paint);
    paint.color = ComicColors.blue.withValues(alpha: 0.22);
    canvas.drawCircle(Offset(size.width * 0.92, size.height * 0.28),
        size.width * 0.18, paint);
    paint.color = ComicColors.green.withValues(alpha: 0.15);
    canvas.drawCircle(Offset(size.width * 0.78, size.height * 0.86),
        size.width * 0.24, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ShivPainter extends CustomPainter {
  _ShivPainter({required this.blink, required this.compact});

  final bool blink;
  final bool compact;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final stroke = Paint()
      ..color = ComicColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = compact ? 4 : 6
      ..strokeCap = StrokeCap.round;
    final fill = Paint()..style = PaintingStyle.fill;

    fill.color = ComicColors.saffron;
    final cape = Path()
      ..moveTo(s * 0.24, s * 0.39)
      ..quadraticBezierTo(s * 0.05, s * 0.55, s * 0.19, s * 0.82)
      ..quadraticBezierTo(s * 0.48, s * 0.74, s * 0.54, s * 0.45)
      ..close();
    canvas.drawPath(cape, fill);
    canvas.drawPath(cape, stroke);
    final starPainter = TextPainter(
      text: TextSpan(
        text: '*',
        style: TextStyle(
          color: ComicColors.yellow,
          fontSize: s * 0.13,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    starPainter.paint(canvas, Offset(s * 0.25, s * 0.58));

    final armLeft = RRect.fromRectAndRadius(
      Rect.fromLTWH(s * 0.13, s * 0.45, s * 0.19, s * 0.36),
      Radius.circular(s * 0.1),
    );
    final armRight = RRect.fromRectAndRadius(
      Rect.fromLTWH(s * 0.68, s * 0.43, s * 0.2, s * 0.34),
      Radius.circular(s * 0.1),
    );
    fill.color = const Color(0xFFC7F7FF);
    canvas.save();
    canvas.translate(s * 0.2, s * 0.6);
    canvas.rotate(0.5);
    canvas.translate(-s * 0.2, -s * 0.6);
    canvas.drawRRect(armLeft, fill);
    canvas.drawRRect(armLeft, stroke);
    canvas.restore();
    canvas.save();
    canvas.translate(s * 0.78, s * 0.57);
    canvas.rotate(-0.6);
    canvas.translate(-s * 0.78, -s * 0.57);
    canvas.drawRRect(armRight, fill);
    canvas.drawRRect(armRight, stroke);
    canvas.restore();

    fill.shader = const LinearGradient(
      colors: [Colors.white, Color(0xFFC7F7FF), ComicColors.blue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(s * 0.27, s * 0.38, s * 0.46, s * 0.42));
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(s * 0.27, s * 0.38, s * 0.46, s * 0.43),
      Radius.circular(s * 0.1),
    );
    canvas.drawRRect(body, fill);
    canvas.drawRRect(body, stroke);
    fill.shader = null;

    fill.color = ComicColors.green;
    final chest = RRect.fromRectAndRadius(
      Rect.fromLTWH(s * 0.39, s * 0.47, s * 0.22, s * 0.16),
      Radius.circular(s * 0.04),
    );
    canvas.drawRRect(chest, fill);
    canvas.drawRRect(chest, stroke);
    final aiPainter = TextPainter(
      text: TextSpan(
        text: 'AI',
        style: GoogleFonts.bangers(
          color: ComicColors.navy,
          fontSize: s * 0.1,
          letterSpacing: 0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    aiPainter.paint(canvas, Offset(s * 0.44, s * 0.485));

    for (final left in [true, false]) {
      final x = left ? s * 0.34 : s * 0.52;
      final leg = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, s * 0.77, s * 0.16, s * 0.18),
        Radius.circular(s * 0.08),
      );
      fill.color = const Color(0xFF9EEFFF);
      canvas.drawRRect(leg, fill);
      canvas.drawRRect(leg, stroke);
    }

    fill.shader = const LinearGradient(
      colors: [Colors.white, Color(0xFF78E5FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(s * 0.26, s * 0.08, s * 0.48, s * 0.34));
    final head = RRect.fromRectAndRadius(
      Rect.fromLTWH(s * 0.26, s * 0.08, s * 0.48, s * 0.34),
      Radius.circular(s * 0.16),
    );
    canvas.drawRRect(head, fill);
    canvas.drawRRect(head, stroke);
    fill.shader = null;

    canvas.drawLine(
        Offset(s * 0.5, s * 0.08), Offset(s * 0.5, s * 0.0), stroke);
    fill.color = ComicColors.yellow;
    canvas.drawCircle(Offset(s * 0.5, s * 0.0), s * 0.045, fill);
    canvas.drawCircle(Offset(s * 0.5, s * 0.0), s * 0.045, stroke);

    fill.color = ComicColors.red;
    final tilak = RRect.fromRectAndRadius(
      Rect.fromLTWH(s * 0.475, s * 0.16, s * 0.05, s * 0.1),
      Radius.circular(s * 0.025),
    );
    canvas.drawRRect(tilak, fill);
    canvas.drawRRect(tilak, stroke);

    for (final x in [s * 0.38, s * 0.62]) {
      fill.color = Colors.white;
      final eyeRect = Rect.fromCenter(
        center: Offset(x, s * 0.29),
        width: s * 0.13,
        height: blink ? s * 0.012 : s * 0.085,
      );
      final eye = RRect.fromRectAndRadius(eyeRect, Radius.circular(s * 0.05));
      canvas.drawRRect(eye, fill);
      canvas.drawRRect(eye, stroke);
      if (!blink) {
        fill.color = ComicColors.navy;
        canvas.drawCircle(Offset(x, s * 0.29), s * 0.022, fill);
      }
    }

    final smile = Path()
      ..moveTo(s * 0.43, s * 0.35)
      ..quadraticBezierTo(s * 0.5, s * 0.4, s * 0.57, s * 0.35);
    canvas.drawPath(smile, stroke);
  }

  @override
  bool shouldRepaint(covariant _ShivPainter oldDelegate) {
    return oldDelegate.blink != blink || oldDelegate.compact != compact;
  }
}
