import 'package:intl/intl.dart';

class Verse {
  Verse({
    required this.id,
    required this.reference,
    required this.text,
    this.translation = 'ESV',
    int? daysToMemorize,
    DateTime? startDate,
    DateTime? nextReview,
    this.completed = false,
    this.hiddenWordCount = 0,
  })  : daysToMemorize = daysToMemorize ?? 3,
        startDate = startDate ?? DateTime.now(),
        nextReview = nextReview ?? DateTime.now().add(const Duration(days: 1));

  final String id;
  final String reference;
  final String text;
  final String translation;
  final int daysToMemorize;
  final DateTime startDate;
  DateTime nextReview;
  bool completed;
  int hiddenWordCount;

  List<String> get words => text.split(RegExp(r'\s+'));

  double get progress {
    if (completed) {
      return 1.0;
    }
    final total = daysToMemorize;
    final elapsed = DateTime.now().difference(startDate).inDays.clamp(0, total);
    return elapsed / total;
  }

  void markReviewed() {
    nextReview = DateTime.now().add(const Duration(days: 1));
  }

  void markMemorized() {
    completed = true;
    hiddenWordCount = words.length;
    nextReview = DateTime.now().add(const Duration(days: 7));
  }

  void scheduleRefresh({int days = 7}) {
    nextReview = DateTime.now().add(Duration(days: days));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'reference': reference,
        'text': text,
        'translation': translation,
        'daysToMemorize': daysToMemorize,
        'startDate': startDate.toIso8601String(),
        'nextReview': nextReview.toIso8601String(),
        'completed': completed,
        'hiddenWordCount': hiddenWordCount,
      };

  factory Verse.fromJson(Map<String, dynamic> json) => Verse(
        id: json['id'] as String,
        reference: json['reference'] as String,
        text: json['text'] as String,
        translation: json['translation'] as String? ?? 'ESV',
        daysToMemorize: json['daysToMemorize'] as int? ?? 3,
        startDate: DateTime.tryParse(json['startDate'] as String? ?? '') ??
            DateTime.now(),
        nextReview: DateTime.tryParse(json['nextReview'] as String? ?? '') ??
            DateTime.now().add(const Duration(days: 1)),
        completed: json['completed'] as bool? ?? false,
        hiddenWordCount: json['hiddenWordCount'] as int? ?? 0,
      );

  String formattedNextReview() {
    final formatter = DateFormat.yMMMd();
    return formatter.format(nextReview);
  }
}
