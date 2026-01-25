import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/bible_verse.dart'; // Import BibleVerse
import '../providers/app_provider.dart';


class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final l10n = AppLocalizations.of(context)!; // Get AppLocalizations instance

        // Ensure bibleData is loaded before trying to resolve bookmark IDs
        if (provider.isLoading || provider.bibleData.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.bookmarksTab)), // Localized
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final List<String> bookmarkedVerseIds = provider.bookmarks.toList();

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.bookmarksTab), // Localized
          ),
          body: bookmarkedVerseIds.isEmpty
              ? Center(
                  child: Text(l10n.noBookmarksYet), // Localized
                )
              : ListView.builder(
                  itemCount: bookmarkedVerseIds.length,
                  itemBuilder: (context, index) {
                    final verseId = bookmarkedVerseIds[index];
                    BibleVerse? verse;
                    try {
                      verse = BibleVerse.fromId(verseId, provider.bibleData);
                    } catch (e) {
                      print('Error parsing bookmarked verse ID: $e'); // Keep print for debugging
                      // If verse ID is invalid, display a placeholder or skip
                      return const SizedBox.shrink();
                    }

                    final localizedBookName = provider.getLocalizedBookName(context, verse.bookId);
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(
                          '$localizedBookName ${verse.chapterIndex + 1}:${verse.verseIndex + 1}',
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