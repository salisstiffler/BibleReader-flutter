import 'package:equatable/equatable.dart';
import 'verse_range.dart';

class Note extends Equatable {
  final String id;
  final String bookId;
  final int chapter;
  final int startVerse;
  final int endVerse;
  final String text;

  const Note({
    required this.id,
    required this.bookId,
    required this.chapter,
    required this.startVerse,
    required this.endVerse,
    required this.text,
  });

  @override
  List<Object?> get props => [id, bookId, chapter, startVerse, endVerse, text];

  factory Note.fromRange(VerseRange range, String text) {
    return Note(
      id: range.id,
      bookId: range.bookId,
      chapter: range.chapter,
      startVerse: range.startVerse,
      endVerse: range.endVerse,
      text: text,
    );
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      bookId: json['bookId'],
      chapter: json['chapter'],
      startVerse: json['startVerse'],
      endVerse: json['endVerse'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'chapter': chapter,
      'startVerse': startVerse,
      'endVerse': endVerse,
      'text': text,
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