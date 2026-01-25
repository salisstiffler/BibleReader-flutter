import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/bible_verse.dart';
import '../providers/app_provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String? _editingVerseId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final l10n = AppLocalizations.of(context)!;

        if (provider.isLoading || provider.bibleData.isEmpty) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // Filter notes based on search query
        final List<String> allNotedVerseIds = provider.allNotes.keys.toList();
        final List<String> filteredVerseIds = allNotedVerseIds.where((id) {
          final note = provider.getNote(id) ?? "";
          return note.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

        return Scaffold(
          appBar: _buildAppBar(context),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, allNotedVerseIds.length),
              _buildSearchField(),
              Expanded(
                child: filteredVerseIds.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        itemCount: filteredVerseIds.length,
                        itemBuilder: (context, index) {
                          final verseId = filteredVerseIds[index];
                          final noteText = provider.getNote(verseId) ?? "";
                          BibleVerse? verse;
                          try {
                            verse = BibleVerse.fromId(verseId, provider.bibleData);
                          } catch (e) {
                            return const SizedBox.shrink();
                          }

                          return _buildNoteCard(context, provider, verse, verseId, noteText);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
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
            child: const Text(
              '圣经阅读',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int count) {
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
            child: const Icon(LucideIcons.penTool, color: Color(0xFF10b981), size: 28),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '灵修笔记',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1e293b)),
              ),
              const SizedBox(height: 4),
              Text(
                '已记录 $count 段感悟',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
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
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: const InputDecoration(
            hintText: '搜索您的笔记或感悟...',
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon: Icon(LucideIcons.search, size: 18, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
            const Text(
              '笔尖未动，感悟从读经开始',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, AppProvider provider, BibleVerse verse, String verseId, String noteText) {
    final bookName = provider.getLocalizedBookName(context, verse.bookId);
    final isEditing = _editingVerseId == verseId;

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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10b981).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$bookName ${verse.chapterIndex + 1}:${verse.verseIndex + 1}',
                    style: const TextStyle(color: Color(0xFF10b981), fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: Icon(isEditing ? LucideIcons.check : LucideIcons.pencil, 
                        size: 18, color: isEditing ? const Color(0xFF10b981) : Colors.grey),
                      onPressed: () {
                        setState(() {
                          if (isEditing) {
                            _editingVerseId = null;
                          } else {
                            _editingVerseId = verseId;
                          }
                        });
                      },
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: Icon(LucideIcons.trash2, size: 18, color: Colors.red.shade300),
                      onPressed: () => _showDeleteDialog(context, provider, verseId),
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
                  onTap: () => provider.goToReaderPage(verse.bookIndex, verse.chapterIndex, verse.verseIndex),
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
                      '“${verse.text}”',
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
                      border: Border.all(color: const Color(0xFF10b981).withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: TextEditingController(text: noteText)
                        ..selection = TextSelection.fromPosition(TextPosition(offset: noteText.length)),
                      maxLines: null,
                      autofocus: true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        border: InputBorder.none,
                      ),
                      onChanged: (text) => provider.saveNote(verseId, text),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      noteText,
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

  void _showDeleteDialog(BuildContext context, AppProvider provider, String verseId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: const Text('提示', style: TextStyle(fontWeight: FontWeight.bold)),
            content: const Text('确定删除这条笔记吗？', style: TextStyle(color: Color(0xFF475569))),
            actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFF1F5F9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text('取消', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444).withOpacity(0.1),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text('确定', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
                onPressed: () {
                  provider.deleteNote(verseId);
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
