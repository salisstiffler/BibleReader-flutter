import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/bible_verse.dart'; // Import BibleVerse
import '../providers/app_provider.dart';

class ReaderPage extends StatefulWidget {
  const ReaderPage({super.key});

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  final ScrollController _scrollController = ScrollController();
  late int _previousBookIndex;
  late int _previousChapterIndex;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AppProvider>(context, listen: false);
    _previousBookIndex = provider.selectedBookIndex;
    _previousChapterIndex = provider.selectedChapterIndex;
  }

  @override
  void didUpdateWidget(covariant ReaderPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final provider = Provider.of<AppProvider>(context, listen: false);
    if (_previousBookIndex != provider.selectedBookIndex ||
        _previousChapterIndex != provider.selectedChapterIndex) {
      print('ReaderPage: didUpdateWidget - Book or Chapter changed. Old: $_previousBookIndex:$_previousChapterIndex, New: ${provider.selectedBookIndex}:${provider.selectedChapterIndex}');
      if (_scrollController.hasClients) {
        print('ReaderPage: ScrollController has clients. Attempting to jumpTo(0).');
        _scrollController.jumpTo(0);
      } else {
        print('ReaderPage: ScrollController has no clients yet.');
      }
      _previousBookIndex = provider.selectedBookIndex;
      _previousChapterIndex = provider.selectedChapterIndex;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showChapterSelector(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ChangeNotifierProvider.value(
          value: provider,
          child: _ChapterSelectorView(l10n: AppLocalizations.of(context)!),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      drawer: _NavigationDrawer(l10n: l10n),
      body: CustomScrollView(
        controller: _scrollController, // Attach controller here
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.85),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(LucideIcons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.indigo, Colors.blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.bookOpen, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.appTitle, // Localized app title
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (provider.dailyVerse != null)
                        _DailyVerseCard(verse: provider.dailyVerse!, l10n: l10n),
                      const SizedBox(height: 24),
                      _ChapterSelectorButton(
                        bookName: provider.selectedBook!.id, // Pass book ID for localization
                        chapterIndex: provider.selectedChapterIndex,
                        onTap: () => _showChapterSelector(context),
                        l10n: l10n,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final verseText = provider.selectedChapter![index];
                  final verseId = BibleVerse(
                    bookId: provider.selectedBook!.id, // Use book ID
                    bookIndex: provider.selectedBookIndex,
                    chapterIndex: provider.selectedChapterIndex,
                    verseIndex: index,
                    text: verseText,
                  ).id;
                  return _VerseWidget(
                    verseText: verseText,
                    verseNumber: index + 1,
                    verseId: verseId,
                    l10n: l10n,
                  );
                },
                childCount: provider.selectedChapter?.length ?? 0,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(LucideIcons.chevronLeft),
                      label: Text(l10n.previousChapter),
                      onPressed: provider.previousChapter,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Text(l10n.nextChapter),
                      label: const Icon(LucideIcons.chevronRight),
                      onPressed: provider.nextChapter,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => provider.toggleChapterPlay(),
        label: Text(provider.isAutoPlaying ? l10n.pauseListening : l10n.listenChapter),
        icon: Icon(provider.isAutoPlaying ? LucideIcons.pause : LucideIcons.play),
        backgroundColor: provider.isAutoPlaying ? Colors.redAccent : Theme.of(context).primaryColor,
      ),
    );
  }
}

class _VerseWidget extends StatefulWidget {
  final String verseText;
  final int verseNumber;
  final String verseId;
  final AppLocalizations l10n;

  const _VerseWidget({
    required this.verseText,
    required this.verseNumber,
    required this.verseId,
    required this.l10n,
  });

  @override
  State<_VerseWidget> createState() => _VerseWidgetState();
}

class _VerseWidgetState extends State<_VerseWidget> {
  bool _showNoteEditor = false;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Color _getHighlightColor(String? colorName) {
    switch (colorName) {
      case 'yellow':
        return Colors.yellow.shade100;
      case 'green':
        return Colors.green.shade100;
      case 'blue':
        return Colors.blue.shade100;
      case 'red':
        return Colors.red.shade100;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isBeingRead = provider.isSpeaking && provider.currentSpeakingId == widget.verseId;
    final isBookmarked = provider.isBookmarked(widget.verseId);
    final hasNote = provider.getNote(widget.verseId) != null && provider.getNote(widget.verseId)!.isNotEmpty;
    final highlightColorName = provider.getHighlight(widget.verseId);
    final highlightColor = _getHighlightColor(highlightColorName);

    if (_showNoteEditor) {
      _noteController.text = provider.getNote(widget.verseId) ?? '';
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _showNoteEditor = !_showNoteEditor;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: highlightColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.verseNumber}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isBeingRead ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodySmall?.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.verseText,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.6,
                      color: isBeingRead ? Theme.of(context).primaryColor : null,
                      fontWeight: isBeingRead ? FontWeight.w600 : null,
                    ),
                  ),
                ),
                if (hasNote)
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 4.0),
                    child: Icon(LucideIcons.stickyNote, size: 16, color: Colors.green),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 26), // Align with text
                IconButton(
                  icon: Icon(isBeingRead ? LucideIcons.pause : LucideIcons.play),
                  color: isBeingRead ? Theme.of(context).primaryColor : Colors.grey,
                  onPressed: () {
                    if (isBeingRead) {
                      provider.stop();
                    } else {
                      provider.speak(widget.verseText, widget.verseId);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(isBookmarked ? LucideIcons.bookmarkCheck : LucideIcons.bookmark),
                  color: isBookmarked ? Colors.amber : Colors.grey,
                  onPressed: () {
                    provider.toggleBookmark(widget.verseId);
                  },
                ),
                IconButton(
                  icon: const Icon(LucideIcons.share2),
                  color: Colors.grey,
                  onPressed: () {
                    // Pass book ID for localization
                    provider.shareVerse(
                      provider.selectedBook!.id, // Use book ID
                      provider.selectedChapterIndex,
                      widget.verseNumber - 1, // verseNumber is 1-based
                    );
                  },
                ),
              ],
            ),
            if (_showNoteEditor) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 26.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _noteController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: widget.l10n.writeYourSpiritualReflection,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                      ),
                      onChanged: (text) {
                        provider.saveNote(widget.verseId, text);
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _HighlightColorButton(
                            colorName: 'yellow',
                            onPressed: () => provider.setHighlight(widget.verseId, highlightColorName == 'yellow' ? null : 'yellow'),
                            isSelected: highlightColorName == 'yellow'),
                        _HighlightColorButton(
                            colorName: 'green',
                            onPressed: () => provider.setHighlight(widget.verseId, highlightColorName == 'green' ? null : 'green'),
                            isSelected: highlightColorName == 'green'),
                        _HighlightColorButton(
                            colorName: 'blue',
                            onPressed: () => provider.setHighlight(widget.verseId, highlightColorName == 'blue' ? null : 'blue'),
                            isSelected: highlightColorName == 'blue'),
                        _HighlightColorButton(
                            colorName: 'red',
                            onPressed: () => provider.setHighlight(widget.verseId, highlightColorName == 'red' ? null : 'red'),
                            isSelected: highlightColorName == 'red'),
                      ],
                    ),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class _HighlightColorButton extends StatelessWidget {
  final String colorName;
  final VoidCallback onPressed;
  final bool isSelected;

  const _HighlightColorButton({
    required this.colorName,
    required this.onPressed,
    required this.isSelected,
  });

  Color _getColor(String name) {
    switch (name) {
      case 'yellow':
        return Colors.yellow.shade400;
      case 'green':
        return Colors.green.shade400;
      case 'blue':
        return Colors.blue.shade400;
      case 'red':
        return Colors.red.shade400;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: _getColor(colorName),
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Theme.of(context).textTheme.bodyLarge!.color!, width: 2) : null,
        ),
        child: isSelected ? const Icon(Icons.check, size: 20, color: Colors.white) : null,
      ),
    );
  }
}


class _NavigationDrawer extends StatefulWidget {
  final AppLocalizations l10n;
  const _NavigationDrawer({required this.l10n});

  @override
  __NavigationDrawerState createState() => __NavigationDrawerState();
}

class __NavigationDrawerState extends State<_NavigationDrawer> {
  late int _tempSelectedBookIndex;

  @override
  void initState() {
    super.initState();
    _tempSelectedBookIndex = Provider.of<AppProvider>(context, listen: false).selectedBookIndex;
    print('_NavigationDrawer: initState - _tempSelectedBookIndex: $_tempSelectedBookIndex');
  }

  @override
  void didUpdateWidget(covariant _NavigationDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final provider = Provider.of<AppProvider>(context, listen: false);
    if (_tempSelectedBookIndex != provider.selectedBookIndex) {
      print('_NavigationDrawer: didUpdateWidget - updating _tempSelectedBookIndex from $_tempSelectedBookIndex to ${provider.selectedBookIndex}');
      setState(() {
        _tempSelectedBookIndex = provider.selectedBookIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('_NavigationDrawer: build called');
    final provider = Provider.of<AppProvider>(context);
    final books = provider.bibleData;
    _tempSelectedBookIndex = min(_tempSelectedBookIndex, books.length - 1);
    // Ensure _tempSelectedBookIndex doesn't go below 0 if books become empty
    if (books.isEmpty) _tempSelectedBookIndex = 0;
    final selectedBookChapters = books.isNotEmpty ? books[_tempSelectedBookIndex].chapters : [];

    return Drawer(
      child: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.l10n.selectChapter, // Localized
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 150,
                  child: ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final localizedBookName = provider.getLocalizedBookName(context, books[index].id);
                      print('_NavigationDrawer: Book name for index $index: $localizedBookName');
                      return ListTile(
                        title: Text(localizedBookName, style: const TextStyle(fontSize: 14)),
                        selected: index == _tempSelectedBookIndex,
                        selectedTileColor: Colors.indigo.withOpacity(0.1),
                        onTap: () {
                          setState(() {
                            _tempSelectedBookIndex = index;
                          });
                        },
                      );
                    },
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: selectedBookChapters.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          provider.navigateTo(_tempSelectedBookIndex, index);
                          Navigator.of(context).pop(); // Close the drawer
                        },
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _DailyVerseCard extends StatelessWidget {
  final BibleVerse verse;
  final AppLocalizations l10n; // Pass AppLocalizations
  const _DailyVerseCard({required this.verse, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final localizedBookName = provider.getLocalizedBookName(context, verse.bookId);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: Colors.indigo.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dailyWisdom, // Localized
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade700,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '“${verse.text}”',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '— $localizedBookName ${verse.chapterIndex + 1}:${verse.verseIndex + 1}', // Use localized name
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade400,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChapterSelectorButton extends StatelessWidget {
  final String bookName; // This is actually the book ID
  final int chapterIndex;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  const _ChapterSelectorButton({
    required this.bookName,
    required this.chapterIndex,
    required this.onTap,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final localizedBookName = provider.getLocalizedBookName(context, bookName); // Get localized name
    return Card(
      elevation: 2,
      shadowColor: Colors.indigo.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(LucideIcons.bookOpen, color: Colors.indigo.shade400),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  '$localizedBookName • ${l10n.selectChapter} ${chapterIndex + 1}', // Use localized name
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Icon(LucideIcons.chevronDown, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChapterSelectorView extends StatefulWidget {
  final AppLocalizations l10n;
  const _ChapterSelectorView({required this.l10n});

  @override
  __ChapterSelectorViewState createState() => __ChapterSelectorViewState();
}

class __ChapterSelectorViewState extends State<_ChapterSelectorView> {
  late int _tempSelectedBookIndex;

  @override
  void initState() {
    super.initState();
    _tempSelectedBookIndex = Provider.of<AppProvider>(context, listen: false).selectedBookIndex;
    print('_ChapterSelectorView: initState - _tempSelectedBookIndex: $_tempSelectedBookIndex');
  }

  @override
  void didUpdateWidget(covariant _ChapterSelectorView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final provider = Provider.of<AppProvider>(context, listen: false);
    if (_tempSelectedBookIndex != provider.selectedBookIndex) {
      print('_ChapterSelectorView: didUpdateWidget - updating _tempSelectedBookIndex from $_tempSelectedBookIndex to ${provider.selectedBookIndex}');
      setState(() {
        _tempSelectedBookIndex = provider.selectedBookIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('_ChapterSelectorView: build called');
    final provider = Provider.of<AppProvider>(context); // Listen by default
    final books = provider.bibleData;
    _tempSelectedBookIndex = min(_tempSelectedBookIndex, books.length - 1);
    if (books.isEmpty) _tempSelectedBookIndex = 0;
    final selectedBookChapters = books.isNotEmpty ? books[_tempSelectedBookIndex].chapters : [];

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.l10n.selectChapter, // Localized
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final localizedBookName = provider.getLocalizedBookName(context, books[index].id);
                          print('_ChapterSelectorView: Book name for index $index: $localizedBookName');
                          return ListTile(
                            title: Text(localizedBookName),
                            selected: index == _tempSelectedBookIndex,
                            onTap: () {
                              setState(() {
                                _tempSelectedBookIndex = index;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      child: GridView.builder(
                        controller: scrollController,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: selectedBookChapters.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              provider.navigateTo(_tempSelectedBookIndex, index);
                              Navigator.of(context).pop();
                            },
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}