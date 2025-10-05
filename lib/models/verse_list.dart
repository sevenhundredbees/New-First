import 'verse.dart';

enum VerseListType {
  curated,
  custom,
}

class VerseList {
  VerseList({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    List<Verse>? verses,
  }) : verses = verses ?? <Verse>[];

  final String id;
  final String title;
  final String description;
  final VerseListType type;
  final List<Verse> verses;

  double get progress {
    if (verses.isEmpty) {
      return 0;
    }
    final completed = verses.where((verse) => verse.completed).length;
    return completed / verses.length;
  }

  Verse? nextIncompleteVerse() {
    return verses.firstWhere(
      (verse) => !verse.completed,
      orElse: () => verses.isEmpty ? null : verses.first,
    );
  }
}
