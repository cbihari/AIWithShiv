import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/env.dart';
import '../core/services/analytics_service.dart';
import '../core/services/offline_service.dart';
import '../core/services/tts_service.dart';
import '../features/ai_chat/presentation/ai_chat_providers.dart';
import '../features/shop/presentation/shop_providers.dart';
import '../shared/models/age_group.dart';
import '../shared/widgets/app_state_widgets.dart';
import '../shared/widgets/child_comic_widgets.dart';
import '../shared/widgets/comic_widgets.dart';

class AiBuddyScreen extends ConsumerStatefulWidget {
  const AiBuddyScreen({super.key});

  @override
  ConsumerState<AiBuddyScreen> createState() => _AiBuddyScreenState();
}

enum _ShivMood { normal, thinking, happy, surprised }

class _AiBuddyScreenState extends ConsumerState<AiBuddyScreen>
    with TickerProviderStateMixin {
  static const _welcomeMessages = [
    'Namaste dost! Kya seekhna hai aaj? 🤖',
    'Hey hero! Ask me anything about AI! ⚡',
    'Chalo! I will explain everything in a fun way! 🌟',
    'Shabash for coming! What is your question today? 🦸',
  ];

  static const _quickQuestions = [
    'What is AI? 🤖',
    'Tell me a joke! 😄',
    'What is machine learning?',
    'How does Siri work?',
    'Tell me a fun fact! ⚡',
    'What can AI not do?',
  ];

  static const _savedTips = [
    'AI stands for Artificial Intelligence — it means machines that can learn and think! 🤖',
    'Machine learning is when AI learns from examples, just like you learn from practice! ⚡',
    'AI is used in games, apps, and even your phone camera! 📸',
    'AI can spot patterns like finding matching rangoli colors! 🌈',
    'Good AI questions are clear, like asking for one mango story at a time! 🥭',
  ];

  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = <_ChatMessage>[];
  late final AnimationController _entrance;
  late final AnimationController _float;
  late final AnimationController _typingDots;
  bool _isTyping = false;
  bool _inputReady = false;
  bool _safetyNoteVisible = false;
  bool _autoRead = false;
  _ShivMood _mood = _ShivMood.normal;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    )..forward();
    _float = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _typingDots = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    )..repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AnalyticsService.instance.shivBotOpened();
      _loadChatPrefs();
      TtsService.instance.initialize();
    });
    final welcome =
        _welcomeMessages[math.Random().nextInt(_welcomeMessages.length)];
    Timer(const Duration(milliseconds: 260), () {
      if (!mounted) return;
      setState(() => _messages.add(_ChatMessage.shiv(welcome)));
      _scrollToBottom();
    });
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _inputReady = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _entrance.dispose();
    _float.dispose();
    _typingDots.dispose();
    TtsService.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offline = ref.watch(isOfflineProvider);
    final bubbleColor = ref.watch(bubbleColorProvider).valueOrNull ?? '';
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) context.go('/dashboard');
      },
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutBack))
            .animate(_entrance),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ComicColors.red,
            foregroundColor: ComicColors.cream,
            leading: IconButton(
              icon: const Icon(Icons.close, color: ComicColors.cream),
              onPressed: () => context.go('/dashboard'),
            ),
            title: Text(
              '🤖 Ask Shiv!',
              style:
                  comicDisplay(context, fontSize: 34, color: ComicColors.cream),
            ),
            actions: [
              OfflinePill(visible: offline),
              IconButton(
                tooltip: _autoRead ? 'Auto read on' : 'Auto read off',
                onPressed: _toggleAutoRead,
                icon: Text(_autoRead ? '🔊' : '🔈'),
              ),
              TextButton(
                onPressed: _isTyping ? null : _confirmClear,
                child: Text(
                  'Clear Chat 🧹',
                  style: comicBody(context,
                      fontSize: 14, color: ComicColors.cream),
                ),
              ),
            ],
          ),
          body: ChildComicBackground(
            child: SafeArea(
              child: Column(
                children: [
                  if (_safetyNoteVisible)
                    _SafetyNote(onDismiss: _dismissSafetyNote),
                  _MascotStrip(
                    float: _float,
                    mood: _mood,
                    thinking: _isTyping,
                    offline: offline,
                  ),
                  if (offline)
                    _SavedTipsBanner(
                      tips: _savedTips,
                      onTap: _sendMessage,
                    ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(14),
                      itemCount: _messages.length + (_isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (_isTyping && index == _messages.length) {
                          return _ShivBubble(
                            text: '',
                            timestamp: 'typing...',
                            bubbleColor: _shivBubbleColor(bubbleColor),
                            onRead: null,
                            child: _TypingDots(controller: _typingDots),
                          );
                        }
                        final message = _messages[index];
                        return message.isUser
                            ? _UserBubble(message: message)
                            : _ShivBubble(
                                text: message.text,
                                timestamp: message.timeLabel,
                                bubbleColor: _shivBubbleColor(bubbleColor),
                                onRead: () =>
                                    TtsService.instance.speak(message.text),
                              );
                      },
                    ),
                  ),
                  _QuickChipRow(
                    questions: _quickQuestions,
                    enabled: _inputReady && !_isTyping,
                    onTap: _sendMessage,
                  ),
                  _InputRow(
                    controller: _controller,
                    enabled: _inputReady && !_isTyping,
                    onSend: () => _sendMessage(_controller.text),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendMessage(String raw) async {
    final text = raw.trim();
    if (text.isEmpty || _isTyping || !_inputReady) return;
    if (_messages.where((message) => message.isUser).length >= 20) {
      setState(() {
        _messages.add(
          _ChatMessage.shiv('Shiv needs a rest! Come back later dost! 😴'),
        );
      });
      _scrollToBottom();
      return;
    }
    final offline = ref.read(isOfflineProvider);
    if (_isBlocked(text)) {
      setState(() {
        _messages.add(_ChatMessage.user(text));
        _messages.add(
          _ChatMessage.shiv("Let's talk about AI and learning dost! 🌟"),
        );
        _controller.clear();
        _mood = _ShivMood.surprised;
      });
      _scrollToBottom();
      return;
    }

    setState(() {
      _messages.add(_ChatMessage.user(text));
      _controller.clear();
      _isTyping = true;
      _mood = _messages.where((m) => m.isUser).length == 1
          ? _ShivMood.surprised
          : _ShivMood.thinking;
    });
    _scrollToBottom();

    if (offline) {
      _addSavedTip();
      return;
    }

    try {
      final reply = await ref.read(aiChatRepositoryProvider).askShivBot(
            message: _lastContextPlus(text),
            ageGroup: AgeGroup.tinyExplorers,
            provider: Env.shivBotProvider,
          );
      if (!mounted) return;
      setState(() {
        _messages.add(_ChatMessage.shiv(reply));
        _isTyping = false;
        _mood = _ShivMood.happy;
      });
      if (_autoRead) await TtsService.instance.speak(reply);
    } catch (_) {
      if (!mounted) return;
      _addSavedTip(prefix: 'ShivBot is offline dost! 📶');
    }
    _scrollToBottom();
  }

  void _addSavedTip({String? prefix}) {
    final tip = _savedTips[math.Random().nextInt(_savedTips.length)];
    setState(() {
      _messages.add(
        _ChatMessage.shiv(
          prefix == null ? tip : '$prefix\n\nShiv\'s Saved Tips 💡\n$tip',
        ),
      );
      _isTyping = false;
      _mood = _ShivMood.normal;
    });
    if (_autoRead) TtsService.instance.speak(tip);
    _scrollToBottom();
  }

  Color _shivBubbleColor(String value) {
    return switch (value) {
      'purple' => ComicColors.purple,
      'dark' => ComicColors.navy,
      'pink' => const Color(0xFFFF8BCB),
      _ => ComicColors.yellow,
    };
  }

  String _lastContextPlus(String latest) {
    final recent = _messages
        .take(_messages.length)
        .toList()
        .reversed
        .take(6)
        .toList()
        .reversed;
    return [
      for (final message in recent)
        '${message.isUser ? "Child" : "ShivBot"}: ${message.text}',
      'Child: $latest',
    ].join('\n');
  }

  bool _isBlocked(String text) {
    final normalized = text.toLowerCase();
    final blocked = [
      'violence',
      'adult',
      'kill',
      'weapon',
      'bomb',
      'phone number'
    ];
    final phonePattern = RegExp(r'\b\d{10}\b');
    return blocked.any(normalized.contains) ||
        RegExp(r'\b(address|password|school name|where i live|my email)\b')
            .hasMatch(normalized) ||
        RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,}\b').hasMatch(normalized) ||
        phonePattern.hasMatch(normalized);
  }

  Future<void> _loadChatPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _safetyNoteVisible = !(prefs.getBool('safety_note_shown') ?? false);
      _autoRead = prefs.getBool('shivbot_auto_read') ?? false;
    });
  }

  Future<void> _dismissSafetyNote() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('safety_note_shown', true);
    if (mounted) setState(() => _safetyNoteVisible = false);
  }

  Future<void> _toggleAutoRead() async {
    final prefs = await SharedPreferences.getInstance();
    final next = !_autoRead;
    await prefs.setBool('shivbot_auto_read', next);
    if (mounted) setState(() => _autoRead = next);
  }

  Future<void> _confirmClear() async {
    final clear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat 🧹'),
        content: const Text('Start a fresh ShivBot chat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (clear == true && mounted) {
      setState(() {
        _messages.clear();
        _mood = _ShivMood.normal;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }
}

class _MascotStrip extends StatelessWidget {
  const _MascotStrip({
    required this.float,
    required this.mood,
    required this.thinking,
    required this.offline,
  });

  final AnimationController float;
  final _ShivMood mood;
  final bool thinking;
  final bool offline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: ComicColors.yellow,
        border: Border(bottom: BorderSide(color: ComicColors.ink, width: 4)),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: float,
            builder: (context, child) {
              final y = math.sin(float.value * math.pi) * -6;
              return Transform.translate(offset: Offset(0, y), child: child);
            },
            child: _MiniShivFace(mood: mood, thinking: thinking),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              offline
                  ? 'ShivBot is offline dost! Saved tips are ready 💡'
                  : thinking
                      ? 'Shiv is thinking...'
                      : 'Ask your AI question, dost!',
              style: comicBody(context, fontSize: 18, color: ComicColors.ink),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniShivFace extends StatelessWidget {
  const _MiniShivFace({required this.mood, required this.thinking});

  final _ShivMood mood;
  final bool thinking;

  @override
  Widget build(BuildContext context) {
    final eyes = mood == _ShivMood.happy ? '★★' : '●●';
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: ComicColors.cream,
        shape: BoxShape.circle,
        border: Border.all(color: ComicColors.ink, width: 4),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned(
              top: 4, child: Text('📡', style: TextStyle(fontSize: 18))),
          Text('🤖\n$eyes',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22)),
          if (mood == _ShivMood.surprised)
            const Positioned(
                right: 6,
                top: 4,
                child: Text('!', style: TextStyle(fontSize: 28))),
          if (thinking)
            const Positioned(
                right: 4,
                top: 2,
                child: Text('🌀', style: TextStyle(fontSize: 20))),
        ],
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: _BubbleShell(
        color: ComicColors.blue,
        textColor: ComicColors.cream,
        alignRight: true,
        text: message.text,
        timestamp: message.timeLabel,
      ),
    );
  }
}

class _ShivBubble extends StatelessWidget {
  const _ShivBubble({
    required this.timestamp,
    required this.bubbleColor,
    required this.onRead,
    this.text,
    this.child,
  });

  final String? text;
  final String timestamp;
  final Color bubbleColor;
  final VoidCallback? onRead;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ComicColors.red,
            shape: BoxShape.circle,
            border: Border.all(color: ComicColors.ink, width: 2),
          ),
          child: const Text('🤖'),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: _BubbleShell(
            color: bubbleColor,
            textColor: bubbleColor == ComicColors.navy
                ? ComicColors.cream
                : ComicColors.ink,
            alignRight: false,
            text: text,
            timestamp: timestamp,
            trailing: text == null || onRead == null
                ? null
                : IconButton(
                    onPressed: onRead,
                    icon: const Text('🔊', style: TextStyle(fontSize: 18)),
                  ),
            child: child,
          ),
        ),
      ],
    );
  }
}

class _SavedTipsBanner extends StatelessWidget {
  const _SavedTipsBanner({required this.tips, required this.onTap});

  final List<String> tips;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ComicColors.cream,
        border: Border.all(color: ComicColors.ink, width: 3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Shiv\'s Saved Tips 💡',
              style: comicBody(context, fontSize: 17)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < math.min(3, tips.length); i++)
                ActionChip(
                  label: Text('Tip ${i + 1}',
                      style: comicBody(context, fontSize: 13)),
                  onPressed: () => onTap(tips[i]),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BubbleShell extends StatelessWidget {
  const _BubbleShell({
    required this.color,
    required this.textColor,
    required this.alignRight,
    required this.timestamp,
    this.text,
    this.child,
    this.trailing,
  });

  final Color color;
  final Color textColor;
  final bool alignRight;
  final String timestamp;
  final String? text;
  final Widget? child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      constraints: const BoxConstraints(maxWidth: 520),
      child: Column(
        crossAxisAlignment:
            alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: ComicColors.ink, width: 3),
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: ComicColors.ink,
                  offset: Offset(3, 3),
                  blurRadius: 0,
                ),
              ],
            ),
            child: child ??
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        text ?? '',
                        style:
                            comicBody(context, fontSize: 16, color: textColor),
                      ),
                    ),
                    if (trailing != null) trailing!,
                  ],
                ),
          ),
          const SizedBox(height: 4),
          Text(timestamp,
              style: comicBody(context, fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _SafetyNote extends StatelessWidget {
  const _SafetyNote({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ComicColors.yellow,
        border: Border.all(color: ComicColors.ink, width: 3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text('🛡️', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Safety First! Never share your real name, address, or phone number online. Ask a grown-up first! 🤗',
              style: comicBody(context, fontSize: 15),
            ),
          ),
          IconButton(onPressed: onDismiss, icon: const Icon(Icons.close)),
        ],
      ),
    );
  }
}

class _TypingDots extends StatelessWidget {
  const _TypingDots({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 3; i++)
            Transform.translate(
              offset: Offset(
                0,
                math.sin(controller.value * math.pi * 2 + i * 0.8) * 5,
              ),
              child: Container(
                width: 9,
                height: 9,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: const BoxDecoration(
                  color: ComicColors.ink,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuickChipRow extends StatelessWidget {
  const _QuickChipRow({
    required this.questions,
    required this.enabled,
    required this.onTap,
  });

  final List<String> questions;
  final bool enabled;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => ActionChip(
          backgroundColor: ComicColors.yellow,
          side: const BorderSide(color: ComicColors.ink, width: 2),
          label:
              Text(questions[index], style: comicBody(context, fontSize: 14)),
          onPressed: enabled ? () => onTap(questions[index]) : null,
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: questions.length,
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  const _InputRow({
    required this.controller,
    required this.enabled,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: ComicColors.ink, width: 4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => enabled ? onSend() : null,
              style: comicBody(context, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Ask Shiv anything! 💬',
                filled: true,
                fillColor: enabled ? ComicColors.cream : Colors.grey.shade200,
                enabledBorder: _border(),
                focusedBorder: _border(width: 5),
                disabledBorder: _border(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 58,
            height: 58,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: enabled ? ComicColors.red : Colors.grey,
                side: const BorderSide(color: ComicColors.ink, width: 4),
              ),
              onPressed: enabled ? onSend : null,
              child: const Text('⚡', style: TextStyle(fontSize: 24)),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _border(
      {Color color = ComicColors.ink, double width = 4}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(22),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class _ChatMessage {
  _ChatMessage._({
    required this.text,
    required this.isUser,
    required this.createdAt,
  });

  factory _ChatMessage.user(String text) =>
      _ChatMessage._(text: text, isUser: true, createdAt: DateTime.now());

  factory _ChatMessage.shiv(String text) =>
      _ChatMessage._(text: text, isUser: false, createdAt: DateTime.now());

  final String text;
  final bool isUser;
  final DateTime createdAt;

  String get timeLabel {
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
