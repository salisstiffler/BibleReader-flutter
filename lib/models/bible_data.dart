// lib/models/bible_data.dart

class BibleBook {
  final String id;
  final String name;
  final List<List<String>> chapters; // List of chapters, each chapter is a list of verses

  BibleBook({
    required this.id,
    required this.name,
    required this.chapters,
  });

  factory BibleBook.fromJson(Map<String, dynamic> json) {
    return BibleBook(
      id: json['id'] as String,
      name: json['name'] as String,
      chapters: (json['chapters'] as List<dynamic>)
          .map((chapter) => (chapter as List<dynamic>)
              .map((verse) => verse as String)
              .toList())
          .toList(),
    );
  }
}
