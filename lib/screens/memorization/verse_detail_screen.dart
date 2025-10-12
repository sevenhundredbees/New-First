import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/verse.dart';
import '../../models/verse_list.dart';
import '../../providers/memorization_provider.dart';
import '../../widgets/hideable_text.dart';
import '../memorization/memorization_screen.dart';

class VerseDetailScreen extends StatefulWidget {
  const VerseDetailScreen({super.key, required this.verse, required this.verseList});

  final Verse verse;
  final VerseList verseList;

  @override
  State<VerseDetailScreen> createState() => _VerseDetailScreenState();
}

class _VerseDetailScreenState extends State<VerseDetailScreen> {
  double? _days;

  @override
  void initState() {
    super.initState();
    _days = widget.verse.daysToMemorize.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MemorizationProvider>();
    final verse = widget.verse;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(verse.reference),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0A6E6D), Color(0xFF118B8A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      widget.verseList.title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList.list(
              children: [
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Speak the verse out loud:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        HideableText(verse: verse),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 12,
                          children: [
                            FilledButton.icon(
                              onPressed: () => provider.advanceHiddenWords(verse),
                              icon: const Icon(Icons.visibility_off),
                              label: const Text('Hide more'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => provider.revealWords(verse),
                              icon: const Icon(Icons.visibility),
                              label: const Text('Reveal'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Practice pace',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        Text('Days to memorize: ${_days?.round()}'),
                        Slider(
                          value: _days ?? 3,
                          min: 1,
                          max: 7,
                          divisions: 6,
                          label: _days?.round().toString(),
                          onChanged: (value) => setState(() => _days = value),
                          onChangeEnd: (value) => provider.updateDaysToMemorize(
                            verse,
                            value.round(),
                          ),
                        ),
                        Text(
                          'Next review: ${verse.formattedNextReview()}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ready for review tomorrow?',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'We will remind you to quote this verse again tomorrow. '
                          'If it has been a while, choose a refresh interval below.',
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () async {
                            await provider.markMemorized(verse);
                            if (mounted) {
                              await showMemorizedCelebration(context, verse);
                            }
                          },
                          child: const Text('I have memorized this verse'),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Set a refresh reminder (days):',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (final days in [3, 7, 14, 30])
                              ChoiceChip(
                                label: Text('$days'),
                                selected: verse.nextReview
                                        .difference(DateTime.now())
                                        .inDays ==
                                    days,
                                onSelected: (_) => provider.scheduleRefresh(
                                  verse,
                                  days: days,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
