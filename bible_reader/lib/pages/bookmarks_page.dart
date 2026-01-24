import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        // Ensure bibleData is loaded before trying to resolve bookmark IDs
        if (provider.isLoading || provider.bibleData.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Bookmarks')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final List<String> bookmarkedVerseIds = provider.bookmarks.toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Bookmarks'),
          ),
          body: bookmarkedVerseIds.isEmpty
              ? const Center(
                  child: Text('No bookmarks yet. Bookmark verses from the Reader page.'),
                )
              : ListView.builder(
                  itemCount: bookmarkedVerseIds.length,
                  itemBuilder: (context, index) {
                    final verseId = bookmarkedVerseIds[index];
                    BibleVerse? verse;
                    try {
                      verse = BibleVerse.fromId(verseId, provider.bibleData);
                    } catch (e) {
                      print('Error parsing bookmarked verse ID: $e');
                      // If verse ID is invalid, display a placeholder or skip
                      return const SizedBox.shrink();
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(
                          '${verse.bookName} ${verse.chapterIndex + 1}:${verse.verseIndex + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          verse.text,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          // Corrected: Use verse.bookIndex now that it's available
                          provider.goToReaderPage(verse!.bookIndex, verse.chapterIndex);
                        },
                        trailing: IconButton(
                          icon: const Icon(LucideIcons.x), // Corrected icon
                          onPressed: () {
                            provider.toggleBookmark(verseId); // Remove bookmark
                          },
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
