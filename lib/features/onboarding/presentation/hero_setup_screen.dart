import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/sound_service.dart';
import '../../../shared/widgets/child_comic_widgets.dart';
import '../../../shared/widgets/comic_widgets.dart';

class HeroSetupScreen extends StatefulWidget {
  const HeroSetupScreen({super.key});

  @override
  State<HeroSetupScreen> createState() => _HeroSetupScreenState();
}

class _HeroSetupScreenState extends State<HeroSetupScreen> {
  static const avatars = ['🤖', '🦸', '🧑‍🚀', '🧙', '🦊', '🐯'];

  final _nameController = TextEditingController();
  int? _selectedAvatar;

  bool get _ready =>
      _nameController.text.trim().isNotEmpty && _selectedAvatar != null;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChildComicBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: ComicButton(
                  label: 'Back',
                  icon: Icons.arrow_back,
                  color: ComicColors.green,
                  onPressed: () => context.go('/age'),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "What's your hero name? ✏️",
                textAlign: TextAlign.center,
                style: comicDisplay(
                  context,
                  fontSize: 46,
                  color: ComicColors.red,
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _nameController,
                textInputAction: TextInputAction.done,
                style: comicBody(context, fontSize: 22, color: ComicColors.ink),
                decoration: InputDecoration(
                  hintText: 'Type your name here!',
                  hintStyle: comicBody(
                    context,
                    fontSize: 20,
                    color: ComicColors.ink.withValues(alpha: 0.55),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  enabledBorder: _border(),
                  focusedBorder: _border(width: 5),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Pick your look! 👇',
                textAlign: TextAlign.center,
                style: comicDisplay(
                  context,
                  fontSize: 38,
                  color: ComicColors.blue,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 114,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: avatars.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final selected = _selectedAvatar == index;
                    return GestureDetector(
                      onTap: () async {
                        await SoundService.instance.tap();
                        setState(() => _selectedAvatar = index);
                      },
                      child: AnimatedScale(
                        scale: selected ? 1.08 : 1,
                        duration: const Duration(milliseconds: 140),
                        child: Container(
                          width: 94,
                          height: 94,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: [
                              ComicColors.blue,
                              ComicColors.red,
                              ComicColors.purple,
                              ComicColors.green,
                              ComicColors.yellow,
                              ComicColors.saffron,
                            ][index],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selected
                                  ? ComicColors.yellow
                                  : ComicColors.ink,
                              width: selected ? 7 : 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: selected
                                    ? ComicColors.red
                                    : ComicColors.ink,
                                offset: const Offset(4, 4),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: Text(
                            avatars[index],
                            style: const TextStyle(fontSize: 46),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 26),
              ComicButton(
                label: "I'm Ready! ⚡",
                color: ComicColors.red,
                expand: true,
                onPressed: _ready ? _saveAndOpenDashboard : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveAndOpenDashboard() async {
    final selected = _selectedAvatar;
    if (!_ready || selected == null) return;
    await SoundService.instance.tap();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('hero_name', _nameController.text.trim());
    await prefs.setInt('avatar_index', selected);
    if (mounted) context.go('/dashboard');
  }

  OutlineInputBorder _border({double width = 4}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: BorderSide(color: ComicColors.ink, width: width),
    );
  }
}
