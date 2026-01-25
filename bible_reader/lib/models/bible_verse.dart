// lib/models/bible_verse.dart
import 'package:flutter/material.dart';
import 'bible_data.dart'; // Import BibleBook model

class BibleVerse {
  final String bookId; // Changed from bookName to bookId
  final int bookIndex;
  final int chapterIndex;
  final int verseIndex;
  final String text;

  BibleVerse({
    required this.bookId, // Changed from bookName to bookId
    required this.bookIndex,
    required this.chapterIndex,
    required this.verseIndex,
    required this.text,
  });

  String get id => '$bookId-${chapterIndex + 1}:${verseIndex + 1}';

  factory BibleVerse.fromId(String id, List<BibleBook> bibleData) {
    final parts = id.split('-');
    final parsedBookId = parts[0]; // Use parsedBookId
    final chapterVerse = parts[1].split(':');
    final chapterNum = int.parse(chapterVerse[0]);
    final verseNum = int.parse(chapterVerse[1]);

    final bookIdx = bibleData.indexWhere((book) => book.id == parsedBookId); // Search by book.id
    if (bookIdx == -1) {
      throw Exception("Book not found for ID: $id");
    }
    final book = bibleData[bookIdx];
    
    if (chapterNum <= 0 || chapterNum > book.chapters.length || verseNum <= 0 || verseNum > book.chapters[chapterNum - 1].length) {
      throw Exception("Chapter or verse out of bounds for ID: $id");
    }

    return BibleVerse(
      bookId: parsedBookId, // Use parsedBookId
      bookIndex: bookIdx,
      chapterIndex: chapterNum - 1,
      verseIndex: verseNum - 1,
      text: book.chapters[chapterNum - 1][verseNum - 1],
    );
  }
}