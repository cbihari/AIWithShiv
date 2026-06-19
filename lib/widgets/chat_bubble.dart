import 'package:flutter/material.dart';

import '../shared/widgets/comic_widgets.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    required this.message,
    required this.isChild,
    super.key,
  });

  final String message;
  final bool isChild;

  @override
  Widget build(BuildContext context) {
    final color = isChild ? ComicColors.blue : ComicColors.yellow;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(24),
      topRight: const Radius.circular(24),
      bottomLeft: Radius.circular(isChild ? 6 : 24),
      bottomRight: Radius.circular(isChild ? 24 : 6),
    );

    return Align(
      alignment: isChild ? Alignment.centerLeft : Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width < 560
              ? MediaQuery.sizeOf(context).width * 0.84
              : 460,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 7),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: ComicColors.ink, width: 4),
            borderRadius: radius,
            boxShadow: const [
              BoxShadow(
                color: ComicColors.ink,
                offset: Offset(4, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Text(
            message,
            style: comicBody(context, fontSize: 16, color: ComicColors.ink),
          ),
        ),
      ),
    );
  }
}
