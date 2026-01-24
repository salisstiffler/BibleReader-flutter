import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        // Ensure bibleData is loaded before trying to resolve note IDs
        if (provider.isLoading || provider.bibleData.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Notes')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final List<String> notedVerseIds = provider.allNotes.keys.toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Notes'),
          ),
          body: notedVerseIds.isEmpty
              ? const Center(
                  child: Text('No notes yet. Add notes to verses from the Reader page.'),
                )
              : ListView.builder(
                  itemCount: notedVerseIds.length,
                  itemBuilder: (context, index) {
                    final verseId = notedVerseIds[index];
                    final noteText = provider.getNote(verseId);
                    BibleVerse? verse;
                    try {
                      verse = BibleVerse.fromId(verseId, provider.bibleData);
                    } catch (e) {
                      print('Error parsing noted verse ID: $e');
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
                          noteText!, // noteText is guaranteed to be non-null here
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          provider.goToReaderPage(verse!.bookIndex, verse.chapterIndex);
                        },
                        trailing: IconButton(
                          icon: const Icon(LucideIcons.trash2),
                          onPressed: () {
                            provider.deleteNote(verseId); // Delete note
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