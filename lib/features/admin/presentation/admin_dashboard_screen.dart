import 'package:flutter/material.dart';

import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/feature_card.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Admin Dashboard',
      child: Column(
        children: [
          FeatureCard(
            title: 'Add Course',
            subtitle: 'Create a new learning path',
            icon: Icons.add_box,
          ),
          FeatureCard(
            title: 'Add Lesson',
            subtitle: 'Story, video, activity, and XP',
            icon: Icons.post_add,
          ),
          FeatureCard(
            title: 'Add Quiz',
            subtitle: 'Questions, answers, hints',
            icon: Icons.quiz,
          ),
          FeatureCard(
            title: 'Upload Images',
            subtitle: 'Firebase Storage media',
            icon: Icons.image,
          ),
          FeatureCard(
            title: 'Upload Videos',
            subtitle: 'Lesson video uploads',
            icon: Icons.video_library,
          ),
          FeatureCard(
            title: 'View Users',
            subtitle: 'Learners, parents, cohorts',
            icon: Icons.people,
          ),
          FeatureCard(
            title: 'Analytics Dashboard',
            subtitle: 'Engagement, retention, revenue',
            icon: Icons.analytics,
          ),
        ],
      ),
    );
  }
}
