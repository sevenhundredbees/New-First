import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/memorization_provider.dart';

class CreateCustomVerseScreen extends StatefulWidget {
  const CreateCustomVerseScreen({super.key});

  @override
  State<CreateCustomVerseScreen> createState() => _CreateCustomVerseScreenState();
}

class _CreateCustomVerseScreenState extends State<CreateCustomVerseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _referenceController = TextEditingController();
  final _textController = TextEditingController();
  double _days = 3;

  @override
  void dispose() {
    _referenceController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Custom Verse')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _referenceController,
                decoration: const InputDecoration(
                  labelText: 'Reference',
                  hintText: 'e.g. John 3:16',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the reference';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _textController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Verse Text',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the verse text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text('Days to memorize: ${_days.round()}'),
              Slider(
                value: _days,
                min: 1,
                max: 7,
                divisions: 6,
                label: _days.round().toString(),
                onChanged: (value) => setState(() => _days = value),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await context.read<MemorizationProvider>().addCustomVerse(
                          reference: _referenceController.text.trim(),
                          text: _textController.text.trim(),
                          daysToMemorize: _days.round(),
                        );
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: const Text('Save Verse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
