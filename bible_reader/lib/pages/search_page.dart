import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/bible_data.dart'; // Import BibleBook
import '../models/bible_verse.dart';
import '../providers/app_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<BibleVerse> _searchResults = [];
  bool _isSearching = false;

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

  void _performSearch(String query, List<BibleBook> bibleData) {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Perform search asynchronously
    Future.delayed(const Duration(milliseconds: 100), () {
      final results = <BibleVerse>[];
      final queryLower = query.toLowerCase();

      for (int bookIndex = 0; bookIndex < bibleData.length; bookIndex++) {
        final book = bibleData[bookIndex];
        final chapters = book.chapters;

        for (
          int chapterIndex = 0;
          chapterIndex < chapters.length;
          chapterIndex++
        ) {
          final chapter = chapters[chapterIndex];

          for (int verseIndex = 0; verseIndex < chapter.length; verseIndex++) {
            final verseText = chapter[verseIndex];

            if (verseText.toLowerCase().contains(queryLower)) {
              results.add(
                BibleVerse(
                  bookIndex: bookIndex,
                  chapterIndex: chapterIndex,
                  verseIndex: verseIndex,
                  bookId: book.id,
                  text: verseText,
                ),
              );
            }
          }
        }
      }

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    });
  }

  TextSpan _highlightSearchTerm(String text, String query, BuildContext context) {
    if (query.isEmpty) return TextSpan(text: text);
    final queryLower = query.toLowerCase();
    final textLower = text.toLowerCase();

    final List<TextSpan> spans = [];
    int start = 0;
    int indexOfMatch;

    while ((indexOfMatch = textLower.indexOf(queryLower, start)) != -1) {
      if (indexOfMatch > start) {
        spans.add(TextSpan(text: text.substring(start, indexOfMatch)));
      }
      spans.add(
        TextSpan(
          text: text.substring(indexOfMatch, indexOfMatch + query.length),
          style: TextStyle(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      start = indexOfMatch + query.length;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return TextSpan(children: spans);
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

        return Scaffold(
          appBar: _buildAppBar(context, l10n),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, l10n),
              _buildSearchBar(context, provider, l10n),
              Expanded(child: _buildSearchResults(context, provider, l10n)),
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

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
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
              LucideIcons.search,
              color: Colors.indigo,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.globalSearchTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1e293b),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.globalSearchSubtitle,
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
          _performSearch(value, provider.bibleData);
        },
        decoration: InputDecoration(
          hintText: l10n.globalSearchPlaceholder,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: const Icon(LucideIcons.search, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(LucideIcons.x, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchResults = [];
                    });
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

  Widget _buildSearchResults(
      BuildContext context, AppProvider provider, AppLocalizations l10n) {
    if (_searchController.text.isEmpty) {
      return _buildEmptySearchState(context, l10n);
    }

    if (_isSearching) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(l10n.globalSearchSearching),
        ],
      ));
    }

    if (_searchResults.isEmpty) {
      return _buildNoResultsState(context, l10n);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
            l10n.globalSearchCount(_searchResults.length),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final verse = _searchResults[index];
              return _buildSearchResultCard(context, provider, verse);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptySearchState(BuildContext context, AppLocalizations l10n) {
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
            Icon(LucideIcons.search, size: 64, color: Colors.grey.shade200),
            const SizedBox(height: 24),
            Text(
              l10n.globalSearchPlaceholder,
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

  Widget _buildNoResultsState(BuildContext context, AppLocalizations l10n) {
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
            Icon(LucideIcons.search, size: 64, color: Colors.grey.shade200),
            const SizedBox(height: 24),
            Text(
              l10n.globalSearchEmpty,
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

  Widget _buildSearchResultCard(
    BuildContext context,
    AppProvider provider,
    BibleVerse verse,
  ) {
    final bookName = _getLocalizedBookName(context, verse.bookId);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              provider.goToReaderPage(
                verse.bookIndex,
                verse.chapterIndex,
                verse.verseIndex,
              );
              // Navigate back to reader
              Provider.of<AppProvider>(context, listen: false).currentTabIndex =
                  0;
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          l10n.globalSearchResultFormat(
                            bookName,
                            (verse.chapterIndex + 1).toString(),
                            (verse.verseIndex + 1).toString(),
                          ),
                          style: const TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Icon(
                        LucideIcons.chevronRight,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: _highlightSearchTerm(
                      verse.text,
                      _searchController.text,
                      context,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    strutStyle: const StrutStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}