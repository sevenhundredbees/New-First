import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/verse.dart';
import '../../models/verse_list.dart';
import '../../providers/memorization_provider.dart';
import '../../widgets/verse_list_card.dart';
import '../../widgets/celebration_dialog.dart';
import 'create_custom_verse_screen.dart';
import 'verse_detail_screen.dart';

class MemorizationScreen extends StatelessWidget {
  const MemorizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MemorizationProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          body: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            itemCount: provider.lists.length,
            itemBuilder: (context, index) {
              final list = provider.lists[index];
              return VerseListCard(
                verseList: list,
                onPractice: (Verse verse) {
                  provider.startPractice(verse);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => VerseDetailScreen(verse: verse, verseList: list),
                    ),
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const CreateCustomVerseScreen(),
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Verse'),
          ),
        );
      },
    );
  }
}

Future<void> showMemorizedCelebration(BuildContext context, Verse verse) async {
  await showDialog<void>(
    context: context,
    builder: (_) => CelebrationDialog(verse: verse),
  );
}
