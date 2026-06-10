import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/models/age_group.dart';
import '../../../shared/widgets/app_scaffold.dart';

class AgeSelectionScreen extends StatelessWidget {
  const AgeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Choose Learner Group',
      child: Column(
        children: [
          for (final group in AgeGroup.values)
            Card(
              child: ListTile(
                leading: const Icon(Icons.face),
                title: Text(group.label),
                subtitle: Text(
                  '${group.minAge}-${group.maxAge == 120 ? '+' : group.maxAge} years',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => group.minAge < 13
                    ? context.go('/consent')
                    : context.go('/signup'),
              ),
            ),
        ],
      ),
    );
  }
}
