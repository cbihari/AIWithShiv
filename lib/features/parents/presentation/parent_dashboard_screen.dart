import 'package:flutter/material.dart';

import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/feature_card.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Parent Dashboard',
      child: Column(
        children: [
          FeatureCard(
            title: 'Progress Tracking',
            subtitle: 'Lessons completed: 18 of 40',
            icon: Icons.insights,
          ),
          FeatureCard(
            title: 'Learning Reports',
            subtitle: 'Weekly strengths and next steps',
            icon: Icons.summarize,
          ),
          FeatureCard(
            title: 'Screen Time Control',
            subtitle: 'Today: 24 of 45 minutes used',
            icon: Icons.timer,
          ),
          FeatureCard(
            title: 'Weekly Email Reports',
            subtitle: 'Enabled for parent inbox',
            icon: Icons.email,
          ),
        ],
      ),
    );
  }
}
