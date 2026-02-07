import 'package:equatable/equatable.dart';
import 'verse_range.dart';

class Bookmark extends Equatable {
  final String id;
  final String bookId;
  final int chapter;
  final int startVerse;
  final int endVerse;

  const Bookmark({
    required this.id,
    required this.bookId,
    required this.chapter,
    required this.startVerse,
    required this.endVerse,
  });

  @override
  List<Object?> get props => [id, bookId, chapter, startVerse, endVerse];

  factory Bookmark.fromRange(VerseRange range) {
    return Bookmark(
      id: range.id,
      bookId: range.bookId,
      chapter: range.chapter,
      startVerse: range.startVerse,
      endVerse: range.endVerse,
    );
  }

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'],
      bookId: json['bookId'],
      chapter: json['chapter'],
      startVerse: json['startVerse'],
      endVerse: json['endVerse'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'chapter': chapter,
      'startVerse': startVerse,
      'endVerse': endVerse,
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