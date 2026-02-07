import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/bookmark.dart';
import '../providers/app_provider.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Bookmark> _filteredBookmarks = [];

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

  void _filterBookmarks(List<Bookmark> bookmarks) {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredBookmarks = bookmarks;
      });
      return;
    }

    setState(() {
      _filteredBookmarks = bookmarks.where((bookmark) {
        final bookName = _getLocalizedBookName(context, bookmark.bookId);
        final chapter = bookmark.chapter + 1;
        final startVerse = bookmark.startVerse;
        final endVerse = bookmark.endVerse;

        String location;
        if (startVerse == endVerse) {
          location = '$bookName $chapter:$startVerse';
        } else {
          location = '$bookName $chapter:$startVerse-$endVerse';
        }

        // We don't have the full verse text here, so we can only search by location.
        // If we need to search by text, we'd need to load the verse text.
        return location.toLowerCase().contains(query);
      }).toList();
    });
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

        final List<Bookmark> bookmarks = provider.bookmarks;
        if (_filteredBookmarks.isEmpty && _searchController.text.isEmpty) {
          _filteredBookmarks = bookmarks;
        }

        return Scaffold(
          appBar: _buildAppBar(context, l10n),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, bookmarks.length, l10n),
              _buildSearchBar(context, provider, l10n),
              Expanded(
                child: _filteredBookmarks.isEmpty
                    ? _buildEmptyState(
                        context,
                        _searchController.text.isNotEmpty,
                        l10n,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        itemCount: _filteredBookmarks.length,
                        itemBuilder: (context, index) {
                          final bookmark = _filteredBookmarks[index];
                          return _buildBookmarkCard(
                            context,
                            provider,
                            bookmark,
                            l10n,
                          );
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
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              LucideIcons.bookMarked,
              color: Colors.indigo,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.bookmarksTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1e293b),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.bookmarksCount(count),
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

  Widget _buildSearchBar(
      BuildContext context, AppProvider provider, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          _filterBookmarks(provider.bookmarks);
        },
        decoration: InputDecoration(
          hintText: l10n.bookmarksSearchPlaceholder,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: const Icon(LucideIcons.search, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(LucideIcons.x, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    _filterBookmarks(provider.bookmarks);
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.indigo, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
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
              isSearching ? l10n.globalSearchEmpty : l10n.bookmarksEmpty,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarkCard(
    BuildContext context,
    AppProvider provider,
    Bookmark bookmark,
    AppLocalizations l10n,
  ) {
    final bookName = _getLocalizedBookName(context, bookmark.bookId);
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => provider.goToReaderPage(
              provider.bibleData.indexWhere((b) => b.id == bookmark.bookId),
              bookmark.chapter,
              bookmark.startVerse - 1,
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
                          color: Colors.indigo.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$bookName ${bookmark.chapter + 1}:${bookmark.startVerse}',
                          style: const TextStyle(
                            color: Colors.indigo,
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
                              LucideIcons.trash2,
                              size: 18,
                              color: Colors.red.shade300,
                            ),
                            onPressed: () => provider.toggleBookmark(
                              bookmark.range,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            LucideIcons.chevronRight,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // We need to fetch the verse text dynamically
                  FutureBuilder<String>(
                    future: _fetchVerseText(
                        provider, bookmark.bookId, bookmark.chapter, bookmark.startVerse),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LinearProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text(
                          snapshot.data ?? 'Verse not found',
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Color(0xFF334155),
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> _fetchVerseText(
      AppProvider provider, String bookId, int chapter, int verse) async {
    final book = provider.bibleData.firstWhere((b) => b.id == bookId);
    return book.chapters[chapter][verse - 1];
  }
}