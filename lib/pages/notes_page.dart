import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/bible_verse.dart';
import '../models/note.dart';
import '../providers/app_provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String? _editingNoteId;
  List<Note> _filteredNotes = [];

  String _getLocalizedBookName(BuildContext context, String bookId) {
    final l10n = AppLocalizations.of(context)!;
    switch (bookId) {
      case 'gn':
        return l10n.bookGn;
      case 'ex':
        return l10n.bookEx;
      case 'lv':
        return l10n.bookLv;
      case 'nm':
        return l10n.bookNm;
      case 'dt':
        return l10n.bookDt;
      case 'js':
        return l10n.bookJs;
      case 'jud':
        return l10n.bookJud;
      case 'rt':
        return l10n.bookRt;
      case '1sm':
        return l10n.book1Sm;
      case '2sm':
        return l10n.book2Sm;
      case '1kgs':
        return l10n.book1kgs;
      case '2kgs':
        return l10n.book2kgs;
      case '1ch':
        return l10n.book1Ch;
      case '2ch':
        return l10n.book2Ch;
      case 'ezr':
        return l10n.bookEzr;
      case 'ne':
        return l10n.bookNe;
      case 'et':
        return l10n.bookEt;
      case 'job':
        return l10n.bookJob;
      case 'ps':
        return l10n.bookPs;
      case 'prv':
        return l10n.bookPrv;
      case 'ec':
        return l10n.bookEc;
      case 'so':
        return l10n.bookSo;
      case 'is':
        return l10n.bookIs;
      case 'jr':
        return l10n.bookJr;
      case 'lm':
        return l10n.bookLm;
      case 'ez':
        return l10n.bookEz;
      case 'dn':
        return l10n.bookDn;
      case 'ho':
        return l10n.bookHo;
      case 'jl':
        return l10n.bookJl;
      case 'am':
        return l10n.bookAm;
      case 'ob':
        return l10n.bookOb;
      case 'jn':
        return l10n.bookJn;
      case 'mi':
        return l10n.bookMi;
      case 'na':
        return l10n.bookNa;
      case 'hk':
        return l10n.bookHk;
      case 'zp':
        return l10n.bookZp;
      case 'hg':
        return l10n.bookHg;
      case 'zc':
        return l10n.bookZc;
      case 'ml':
        return l10n.bookMl;
      case 'mt':
        return l10n.bookMt;
      case 'mk':
        return l10n.bookMk;
      case 'lk':
        return l10n.bookLk;
      case 'jo':
        return l10n.bookJo;
      case 'act':
        return l10n.bookAct;
      case 'rm':
        return l10n.bookRm;
      case '1co':
        return l10n.book1Co;
      case '2co':
        return l10n.book2Co;
      case 'gl':
        return l10n.bookGl;
      case 'eph':
        return l10n.bookEph;
      case 'ph':
        return l10n.bookPh;
      case 'cl':
        return l10n.bookCl;
      case '1ts':
        return l10n.book1ts;
      case '2ts':
        return l10n.book2ts;
      case '1tm':
        return l10n.book1tm;
      case '2tm':
        return l10n.book2tm;
      case 'tt':
        return l10n.bookTt;
      case 'phm':
        return l10n.bookPhm;
      case 'hb':
        return l10n.bookHb;
      case 'jm':
        return l10n.bookJm;
      case '1pe':
        return l10n.book1Pe;
      case '2pe':
        return l10n.book2Pe;
      case '1jo':
        return l10n.book1Jn;
      case '2jo':
        return l10n.book2Jn;
      case '3jo':
        return l10n.book3Jn;
      case 'jd':
        return l10n.bookJd;
      case 're':
        return l10n.bookRe;
      default:
        return bookId;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Modified _filterNotes to not call setState directly
  List<Note> _filterNotesLogic(List<Note> notes) {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      // Sort by most recent notes first
      return List.from(notes)..sort((a, b) => b.id.compareTo(a.id));
    }

    return notes.where((note) {
      return note.text.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final l10n = AppLocalizations.of(context)!;

        if (provider.isLoading || provider.bibleData.isEmpty) {
          return Scaffold(
            appBar: _buildAppBar(context, l10n),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final List<Note> notes = provider.notes;

        // Initialize or update _filteredNotes based on current state
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_searchQuery.isEmpty &&
              _filteredNotes.length != notes.length) {
            setState(() {
              _filteredNotes = _filterNotesLogic(notes);
            });
          }
        });

        return Scaffold(
          appBar: _buildAppBar(context, l10n),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, notes.length, l10n),
              _buildSearchField(context, provider, l10n),
              Expanded(
                child: _filteredNotes.isEmpty && _searchQuery.isEmpty
                    ? _buildEmptyState(context, _searchQuery.isNotEmpty, l10n)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        itemCount: _filteredNotes.length,
                        itemBuilder: (context, index) {
                          final note = _filteredNotes[index];
                          // For now, we only display the start verse of a range.
                          // Fetch the actual verse text
                          String verseText = 'Loading verse...';
                          try {
                            final book = provider.bibleData.firstWhere(
                                (b) => b.id == note.bookId,
                                orElse: () => throw Exception('Book not found'));
                            verseText =
                                book.chapters[note.chapter][note.startVerse - 1];
                          } catch (e) {
                            verseText = 'Verse not found';
                          }

                          return _buildNoteCard(
                              context, provider, verseText, note, l10n);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AppLocalizations l10n) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Row(
        children: [
          const Icon(LucideIcons.bookOpen, color: Colors.indigo, size: 24),
          const SizedBox(width: 12),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.indigo, Colors.blueAccent],
            ).createShader(Offset.zero & bounds.size),
            child: Text(
              l10n.appTitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, int count, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF10b981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10b981).withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              LucideIcons.penTool,
              color: Color(0xFF10b981),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.notesTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1e293b),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.notesCount(count),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(
      BuildContext context, AppProvider provider, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
              _filteredNotes = _filterNotesLogic(provider.notes);
            });
          },
          decoration: InputDecoration(
            hintText: l10n.notesSearchPlaceholder,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon: const Icon(
              LucideIcons.search,
              size: 18,
              color: Colors.grey,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, bool isSearching, AppLocalizations l10n) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade100, width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.book, size: 64, color: Colors.grey.shade200),
            const SizedBox(height: 24),
            Text(
              isSearching ? l10n.globalSearchEmpty : l10n.notesEmpty,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCard(
    BuildContext context,
    AppProvider provider,
    String verseText,
    Note note,
    AppLocalizations l10n,
  ) {
    final bookName = _getLocalizedBookName(context, note.bookId);
    final isEditing = _editingNoteId == note.id;
    final noteController = TextEditingController(text: note.text);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10b981).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$bookName ${note.chapter + 1}:${note.startVerse}',
                    style: const TextStyle(
                      color: Color(0xFF10b981),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        isEditing ? LucideIcons.check : LucideIcons.pencil,
                        size: 18,
                        color: isEditing
                            ? const Color(0xFF10b981)
                            : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          if (isEditing) {
                            // Save changes when toggling off editing
                            provider.saveNote(note.range, noteController.text);
                            _editingNoteId = null;
                          } else {
                            _editingNoteId = note.id;
                          }
                        });
                      },
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        LucideIcons.trash2,
                        size: 18,
                        color: Colors.red.shade300,
                      ),
                      onPressed: () => _showDeleteDialog(context, provider, note.id, l10n),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => provider.goToReaderPage(
                    provider.bibleData.indexWhere((b) => b.id == note.bookId),
                    note.chapter,
                    note.startVerse - 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(16),
                      border: const Border(
                        left: BorderSide(color: Color(0xFF10b981), width: 4),
                      ),
                    ),
                    child: Text(
                      '“${verseText}”',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (isEditing)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFF10b981).withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: noteController
                        ..selection = TextSelection.fromPosition(
                          TextPosition(offset: noteController.text.length),
                        ),
                      maxLines: null,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: l10n.readerNotePlaceholder,
                        contentPadding: const EdgeInsets.all(12),
                        border: InputBorder.none,
                      ),
                      onChanged: (text) =>
                          provider.saveNote(note.range, text),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      note.text,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Color(0xFF334155),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    AppProvider provider,
    String noteId,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Text(
              l10n.notesConfirm, // Changed from commonConfirm
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            content: Text(
              l10n.notesDeleteConfirm(1), // Assuming 1 note is being deleted
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).dividerColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: Text(
                  l10n.commonCancel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.1),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: Text(
                  l10n.notesConfirm, // Changed from commonConfirm
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  provider.deleteNote(noteId);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}