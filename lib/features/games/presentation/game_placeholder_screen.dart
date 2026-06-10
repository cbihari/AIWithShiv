import 'package:flutter/material.dart';

import '../../../shared/widgets/app_scaffold.dart';

class GamePlaceholderScreen extends StatelessWidget {
  const GamePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'AI Games',
      child: Text(
        'Mini games will teach sorting, pattern finding, robot commands, and prompt design.',
      ),
    );
  }
}
