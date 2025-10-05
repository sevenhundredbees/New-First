import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/discipleship_provider.dart';

class EvangelismScreen extends StatelessWidget {
  const EvangelismScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DiscipleshipProvider>();
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: provider.challenges.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final challenge = provider.challenges[index];
        return Card(
          child: ListTile(
            title: Text(challenge.title),
            subtitle: Text(challenge.description),
            trailing: Checkbox(
              value: challenge.completed,
              onChanged: (_) => provider.toggleChallenge(challenge),
            ),
          ),
        );
      },
    );
  }
}
