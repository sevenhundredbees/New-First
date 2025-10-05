import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/discipleship_provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DiscipleshipProvider>();
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.journalEntries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final entry = provider.journalEntries[index];
              return Card(
                child: ListTile(
                  title: Text(entry.title),
                  subtitle: Text(
                    entry.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    '${entry.date.month}/${entry.date.day}/${entry.date.year}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Entry title'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please add a title' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _contentController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'What is God teaching you?',
                    alignLabelWithHint: true,
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Share a thought or prayer.'
                      : null,
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      provider.addJournalEntry(
                        _titleController.text.trim(),
                        _contentController.text.trim(),
                      );
                      _titleController.clear();
                      _contentController.clear();
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save entry'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
