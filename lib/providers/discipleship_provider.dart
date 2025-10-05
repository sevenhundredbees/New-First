import 'package:flutter/foundation.dart';

class EvangelismChallenge {
  EvangelismChallenge({
    required this.title,
    required this.description,
    this.completed = false,
  });

  final String title;
  final String description;
  bool completed;
}

class PrayerTopic {
  PrayerTopic({
    required this.title,
    required this.description,
    this.completed = false,
  });

  final String title;
  final String description;
  bool completed;
}

class BibleReadingPlan {
  BibleReadingPlan({
    required this.title,
    required this.passage,
    this.completed = false,
  });

  final String title;
  final String passage;
  bool completed;
}

class JournalEntry {
  JournalEntry({
    required this.title,
    required this.content,
    required this.date,
  });

  final String title;
  final String content;
  final DateTime date;
}

class DiscipleshipProvider extends ChangeNotifier {
  DiscipleshipProvider();

  final List<EvangelismChallenge> challenges = [
    EvangelismChallenge(
      title: 'Share Your Testimony',
      description: 'Tell a friend how you came to know Jesus.',
    ),
    EvangelismChallenge(
      title: 'Pray for Opportunities',
      description: 'Spend five minutes praying for boldness and open doors.',
    ),
  ];

  final List<PrayerTopic> prayerTopics = [
    PrayerTopic(
      title: 'Family',
      description: 'Lift up each member of your family by name today.',
    ),
    PrayerTopic(
      title: 'Church',
      description: 'Pray for your church leaders and volunteers.',
    ),
  ];

  final List<BibleReadingPlan> readingPlans = [
    BibleReadingPlan(
      title: 'Gospel of John',
      passage: 'Read John 1-2 today.',
    ),
    BibleReadingPlan(
      title: 'Psalms of Praise',
      passage: 'Read Psalm 95 and 100.',
    ),
  ];

  final List<JournalEntry> journalEntries = [];

  void toggleChallenge(EvangelismChallenge challenge) {
    challenge.completed = !challenge.completed;
    notifyListeners();
  }

  void togglePrayerTopic(PrayerTopic topic) {
    topic.completed = !topic.completed;
    notifyListeners();
  }

  void toggleReadingPlan(BibleReadingPlan plan) {
    plan.completed = !plan.completed;
    notifyListeners();
  }

  void addJournalEntry(String title, String content) {
    journalEntries.add(
      JournalEntry(title: title, content: content, date: DateTime.now()),
    );
    notifyListeners();
  }
}
