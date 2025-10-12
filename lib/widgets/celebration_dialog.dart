import 'package:flutter/material.dart';

import '../models/verse.dart';

class CelebrationDialog extends StatefulWidget {
  const CelebrationDialog({super.key, required this.verse});

  final Verse verse;

  @override
  State<CelebrationDialog> createState() => _CelebrationDialogState();
}

class _CelebrationDialogState extends State<CelebrationDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: AlertDialog(
        title: const Text('Great job!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.celebration,
              color: Theme.of(context).colorScheme.primary,
              size: 72,
            ),
            const SizedBox(height: 16),
            Text(
              'You have memorized ${widget.verse.reference}! Keep hiding God\'s word in your heart.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Celebrate'),
          ),
        ],
      ),
    );
  }
}
