import 'package:equatable/equatable.dart';
import 'verse_range.dart';

class Highlight extends Equatable {
  final String id;
  final String bookId;
  final int chapter;
  final int startVerse;
  final int endVerse;
  final String color;

  const Highlight({
    required this.id,
    required this.bookId,
    required this.chapter,
    required this.startVerse,
    required this.endVerse,
    required this.color,
  });

  @override
  List<Object?> get props => [id, bookId, chapter, startVerse, endVerse, color];

  factory Highlight.fromRange(VerseRange range, String color) {
    return Highlight(
      id: range.id,
      bookId: range.bookId,
      chapter: range.chapter,
      startVerse: range.startVerse,
      endVerse: range.endVerse,
      color: color,
    );
  }

  factory Highlight.fromJson(Map<String, dynamic> json) {
    return Highlight(
      id: json['id'],
      bookId: json['bookId'],
      chapter: json['chapter'],
      startVerse: json['startVerse'],
      endVerse: json['endVerse'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'chapter': chapter,
      'startVerse': startVerse,
      'endVerse': endVerse,
      'color': color,
    };
  }

  VerseRange get range {
    return VerseRange(
      bookId: bookId,
      chapter: chapter,
      startVerse: startVerse,
      endVerse: endVerse,
    );
  }
}