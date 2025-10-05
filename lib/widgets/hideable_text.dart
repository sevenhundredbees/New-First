import 'package:flutter/material.dart';

import '../models/verse.dart';

class HideableText extends StatelessWidget {
  const HideableText({super.key, required this.verse});

  final Verse verse;

  @override
  Widget build(BuildContext context) {
    final words = verse.words;
    final hiddenCount = verse.hiddenWordCount.clamp(0, words.length);
    final visibleWords = [
      ...words.sublist(0, words.length - hiddenCount),
      ...List.filled(hiddenCount, '____'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          visibleWords.join(' '),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Text(
          verse.translation,
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: Theme.of(context).colorScheme.secondary),
        ),
      ],
    );
  }
}
