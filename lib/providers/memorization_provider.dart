import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/verse.dart';
import '../models/verse_list.dart';
import '../services/notification_service.dart';

class MemorizationProvider extends ChangeNotifier {
  MemorizationProvider(this._notificationService) {
    _loadInitialData();
  }

  final NotificationService _notificationService;
  final _uuid = const Uuid();
  final List<VerseList> _lists = [];

  List<VerseList> get lists => List.unmodifiable(_lists);

  Verse? _activeVerse;
  Verse? get activeVerse => _activeVerse;

  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('memorization_data');
    if (stored != null) {
      final List<dynamic> decoded = jsonDecode(stored) as List<dynamic>;
      _lists
        ..clear()
        ..addAll(decoded.map((dynamic item) {
          final map = item as Map<String, dynamic>;
          return VerseList(
            id: map['id'] as String,
            title: map['title'] as String,
            description: map['description'] as String,
            type: VerseListType.values[map['type'] as int? ?? 0],
            verses: (map['verses'] as List<dynamic>? ?? <dynamic>[])
                .map((dynamic verse) =>
                    Verse.fromJson(verse as Map<String, dynamic>))
                .toList(),
          );
        }));
    } else {
      _lists.addAll(_defaultLists());
    }
    await _scheduleDailyReminder();
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _lists
        .map((list) => {
              'id': list.id,
              'title': list.title,
              'description': list.description,
              'type': list.type.index,
              'verses': list.verses.map((verse) => verse.toJson()).toList(),
            })
        .toList();
    await prefs.setString('memorization_data', jsonEncode(data));
  }

  Future<void> _scheduleDailyReminder() async {
    final verse = _activeVerse ?? nextVerseToPractice();
    if (verse != null) {
      await _notificationService.scheduleDailyPractice(verse);
    }
  }

  List<VerseList> _defaultLists() {
    return [
      VerseList(
        id: 'faith',
        title: 'Faith Builders',
        description: 'Foundational verses about trusting God.',
        type: VerseListType.curated,
        verses: [
          Verse(
            id: _uuid.v4(),
            reference: 'Proverbs 3:5-6',
            text:
                'Trust in the LORD with all your heart, and do not lean on your own understanding. In all your ways acknowledge him, and he will make straight your paths.',
          ),
          Verse(
            id: _uuid.v4(),
            reference: 'Philippians 4:6-7',
            text:
                'Do not be anxious about anything, but in everything by prayer and supplication with thanksgiving let your requests be made known to God. And the peace of God, which surpasses all understanding, will guard your hearts and your minds in Christ Jesus.',
          ),
        ],
      ),
      VerseList(
        id: 'identity',
        title: 'Identity in Christ',
        description: 'Reminders of who we are in Christ Jesus.',
        type: VerseListType.curated,
        verses: [
          Verse(
            id: _uuid.v4(),
            reference: '2 Corinthians 5:17',
            text:
                'Therefore, if anyone is in Christ, he is a new creation. The old has passed away; behold, the new has come.',
          ),
          Verse(
            id: _uuid.v4(),
            reference: 'Galatians 2:20',
            text:
                'I have been crucified with Christ. It is no longer I who live, but Christ who lives in me. And the life I now live in the flesh I live by faith in the Son of God, who loved me and gave himself for me.',
          ),
        ],
      ),
    ];
  }

  Verse? nextVerseToPractice() {
    for (final list in _lists) {
      final verse = list.nextIncompleteVerse();
      if (verse != null && !verse.completed) {
        return verse;
      }
    }
    return null;
  }

  void startPractice(Verse verse) {
    _activeVerse = verse;
    _scheduleDailyReminder();
    notifyListeners();
  }

  Future<void> updateDaysToMemorize(Verse verse, int days) async {
    verse.hiddenWordCount = 0;
    verse.completed = false;
    verse.nextReview = DateTime.now().add(const Duration(days: 1));
    await _notificationService.scheduleDailyPractice(verse);
    await _persist();
    notifyListeners();
  }

  Future<void> advanceHiddenWords(Verse verse) async {
    if (verse.hiddenWordCount < verse.words.length) {
      verse.hiddenWordCount += (verse.words.length / 4).ceil();
      if (verse.hiddenWordCount > verse.words.length) {
        verse.hiddenWordCount = verse.words.length;
      }
      await _persist();
      notifyListeners();
    }
  }

  Future<void> revealWords(Verse verse) async {
    if (verse.hiddenWordCount > 0) {
      verse.hiddenWordCount = (verse.hiddenWordCount - (verse.words.length / 4).ceil())
          .clamp(0, verse.words.length);
      await _persist();
      notifyListeners();
    }
  }

  Future<void> markMemorized(Verse verse) async {
    verse.markMemorized();
    await _notificationService.showCelebration(verse);
    await _persist();
    notifyListeners();
  }

  Future<void> scheduleRefresh(Verse verse, {int days = 7}) async {
    verse.scheduleRefresh(days: days);
    await _persist();
    notifyListeners();
  }

  Future<void> addCustomVerse({
    required String reference,
    required String text,
    int daysToMemorize = 3,
  }) async {
    VerseList? customList =
        _lists.firstWhere((list) => list.type == VerseListType.custom, orElse: () {
      final list = VerseList(
        id: 'custom',
        title: 'My Verses',
        description: 'Verses you have added.',
        type: VerseListType.custom,
      );
      _lists.add(list);
      return list;
    });

    final verse = Verse(
      id: _uuid.v4(),
      reference: reference,
      text: text,
      daysToMemorize: daysToMemorize,
    );
    customList.verses.add(verse);
    await _persist();
    notifyListeners();
  }
}
