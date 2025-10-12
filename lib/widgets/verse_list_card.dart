import 'package:flutter/material.dart';

import '../models/verse.dart';
import '../models/verse_list.dart';

class VerseListCard extends StatelessWidget {
  const VerseListCard({
    super.key,
    required this.verseList,
    required this.onPractice,
  });

  final VerseList verseList;
  final ValueChanged<Verse> onPractice;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    verseList.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: verseList.progress,
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceVariant,
                      ),
                      Center(
                        child: Text('${(verseList.progress * 100).round()}%'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              verseList.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: verseList.verses.map((verse) {
                return ActionChip(
                  label: Text(verse.reference),
                  avatar: Icon(
                    verse.completed ? Icons.check_circle : Icons.circle_outlined,
                    color: verse.completed
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                  ),
                  onPressed: () => onPractice(verse),
                );
              }).toList(),
            ),
            if (verseList.verses.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Add a verse to get started.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Theme.of(context).colorScheme.outline),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
