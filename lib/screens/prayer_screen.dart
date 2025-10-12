import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/discipleship_provider.dart';

class PrayerScreen extends StatelessWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DiscipleshipProvider>();
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: provider.prayerTopics.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final topic = provider.prayerTopics[index];
        return Card(
          child: ListTile(
            title: Text(topic.title),
            subtitle: Text(topic.description),
            trailing: Checkbox(
              value: topic.completed,
              onChanged: (_) => provider.togglePrayerTopic(topic),
            ),
          ),
        );
      },
    );
  }
}
