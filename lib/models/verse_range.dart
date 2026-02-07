import 'package:equatable/equatable.dart';

class VerseRange extends Equatable {
  final String bookId;
  final int chapter;
  final int startVerse;
  final int endVerse;

  const VerseRange({
    required this.bookId,
    required this.chapter,
    required this.startVerse,
    required this.endVerse,
  });

  @override
  List<Object?> get props => [bookId, chapter, startVerse, endVerse];

  factory VerseRange.fromJson(Map<String, dynamic> json) {
    return VerseRange(
      bookId: json['bookId'],
      chapter: json['chapter'],
      startVerse: json['startVerse'],
      endVerse: json['endVerse'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'chapter': chapter,
      'startVerse': startVerse,
      'endVerse': endVerse,
    };
  }

  String get id {
    if (startVerse == endVerse) {
      return '$bookId $chapter:$startVerse';
    }
    return '$bookId $chapter:$startVerse-$endVerse';
  }

  bool get isSingleVerse => startVerse == endVerse;
}