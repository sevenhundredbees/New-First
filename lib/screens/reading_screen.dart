import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/discipleship_provider.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DiscipleshipProvider>();
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: provider.readingPlans.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final plan = provider.readingPlans[index];
        return Card(
          child: ListTile(
            title: Text(plan.title),
            subtitle: Text(plan.passage),
            trailing: Checkbox(
              value: plan.completed,
              onChanged: (_) => provider.toggleReadingPlan(plan),
            ),
          ),
        );
      },
    );
  }
}
