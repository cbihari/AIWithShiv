import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/sound_service.dart';
import '../../../shared/widgets/child_comic_widgets.dart';
import '../../../shared/widgets/comic_widgets.dart';

class AgeSelectionScreen extends StatefulWidget {
  const AgeSelectionScreen({super.key});

  @override
  State<AgeSelectionScreen> createState() => _AgeSelectionScreenState();
}

class _AgeSelectionScreenState extends State<AgeSelectionScreen> {
  int? _selected;

  static const _cards = [
    _AgeCardData('🐣', 'Little Hero', 'ages 5-7', 'little_hero'),
    _AgeCardData('⚡', 'Super Learner', 'ages 8-10', 'super_learner'),
    _AgeCardData('🚀', 'Big Explorer', 'ages 11+', 'big_explorer'),
  ];

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
                  onPressed: () => context.go('/welcome'),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'How old are you Hero? 🦸',
                textAlign: TextAlign.center,
                style: comicDisplay(
                  context,
                  fontSize: 48,
                  color: ComicColors.red,
                ),
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth > 760;
                  if (wide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var i = 0; i < _cards.length; i++)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: i < _cards.length - 1 ? 14 : 0,
                              ),
                              child: _AgeChoiceCard(
                                data: _cards[i],
                                selected: _selected == i,
                                onTap: () async {
                                  await SoundService.instance.tap();
                                  setState(() => _selected = i);
                                },
                              ),
                            ),
                          ),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      for (var i = 0; i < _cards.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _AgeChoiceCard(
                            data: _cards[i],
                            selected: _selected == i,
                            onTap: () async {
                              await SoundService.instance.tap();
                              setState(() => _selected = i);
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 18),
              if (_selected != null)
                ComicButton(
                  label: "That's Me! ✅",
                  color: ComicColors.red,
                  expand: true,
                  onPressed: _saveAndContinue,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveAndContinue() async {
    final selected = _selected;
    if (selected == null) return;
    await SoundService.instance.tap();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('age_group', _cards[selected].key);
    if (mounted) context.go('/hero-setup');
  }
}

class _AgeChoiceCard extends StatelessWidget {
  const _AgeChoiceCard({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final _AgeCardData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = data.key == 'little_hero'
        ? ComicColors.green
        : data.key == 'super_learner'
            ? ComicColors.yellow
            : ComicColors.blue;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: selected ? 1.04 : 1,
        duration: const Duration(milliseconds: 150),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: selected ? ComicColors.yellow : ComicColors.ink,
              width: selected ? 7 : 4,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: selected ? ComicColors.red : ComicColors.ink,
                offset: const Offset(4, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              Text(data.emoji, style: const TextStyle(fontSize: 58)),
              const SizedBox(height: 10),
              Text(
                data.label,
                textAlign: TextAlign.center,
                style: comicDisplay(
                  context,
                  fontSize: 34,
                  color: data.key == 'big_explorer'
                      ? ComicColors.cream
                      : ComicColors.ink,
                ),
              ),
              Text(
                data.ages,
                textAlign: TextAlign.center,
                style: comicBody(
                  context,
                  fontSize: 20,
                  color: data.key == 'big_explorer'
                      ? ComicColors.cream
                      : ComicColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AgeCardData {
  const _AgeCardData(this.emoji, this.label, this.ages, this.key);

  final String emoji;
  final String label;
  final String ages;
  final String key;
}
