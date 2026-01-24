import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class ReaderPage extends StatelessWidget {
  const ReaderPage({super.key});

  void _showChapterSelector(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ChangeNotifierProvider.value(
          value: provider,
          child: const _ChapterSelectorView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      drawer: const _NavigationDrawer(),
      body: CustomScrollView(
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
                const Text(
                  'Holy Read',
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                        _DailyVerseCard(verse: provider.dailyVerse!),
                      const SizedBox(height: 24),
                      _ChapterSelectorButton(
                        bookName: provider.selectedBook!.name,
                        chapterIndex: provider.selectedChapterIndex,
                        onTap: () => _showChapterSelector(context),
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
                  // Use a more descriptive verse ID for bookmarks/notes
                  final verseId = BibleVerse(
                    bookName: provider.selectedBook!.name,
                    bookIndex: provider.selectedBookIndex, // Added bookIndex
                    chapterIndex: provider.selectedChapterIndex,
                    verseIndex: index,
                    text: verseText,
                  ).id;
                  return _VerseWidget(
                    verseText: verseText,
                    verseNumber: index + 1,
                    verseId: verseId,
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
                      label: const Text('Previous'),
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
                      icon: const Text('Next'),
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
        label: Text(provider.isAutoPlaying ? 'Pause' : 'Listen Chapter'),
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

  const _VerseWidget({
    required this.verseText,
    required this.verseNumber,
    required this.verseId,
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
      case 'yellow': return Colors.yellow.shade100;
      case 'green': return Colors.green.shade100;
      case 'blue': return Colors.blue.shade100;
      case 'red': return Colors.red.shade100;
      default: return Colors.transparent;
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
                // Add Share button later if needed
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
                        hintText: 'Write your spiritual reflection...',
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
      case 'yellow': return Colors.yellow.shade400;
      case 'green': return Colors.green.shade400;
      case 'blue': return Colors.blue.shade400;
      case 'red': return Colors.red.shade400;
      default: return Colors.grey;
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
  const _NavigationDrawer();

  @override
  __NavigationDrawerState createState() => __NavigationDrawerState();
}

class __NavigationDrawerState extends State<_NavigationDrawer> {
  late int _tempSelectedBookIndex;

  @override
  void initState() {
    super.initState();
    _tempSelectedBookIndex = Provider.of<AppProvider>(context, listen: false).selectedBookIndex;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final books = provider.bibleData;
    final selectedBookChapters = books[_tempSelectedBookIndex].chapters;

    return Drawer(
      child: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Select Chapter',
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
                      return ListTile(
                        title: Text(books[index].name, style: const TextStyle(fontSize: 14)),
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
  const _DailyVerseCard({required this.verse});

  @override
  Widget build(BuildContext context) {
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
              'Daily Wisdom',
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
                '— ${verse.bookName} ${verse.chapterIndex + 1}:${verse.verseIndex + 1}',
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
  final String bookName;
  final int chapterIndex;
  final VoidCallback onTap;

  const _ChapterSelectorButton({
    required this.bookName,
    required this.chapterIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                  '$bookName • Chapter ${chapterIndex + 1}',
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
  const _ChapterSelectorView();

  @override
  __ChapterSelectorViewState createState() => __ChapterSelectorViewState();
}

class __ChapterSelectorViewState extends State<_ChapterSelectorView> {
  late int _tempSelectedBookIndex;

  @override
  void initState() {
    super.initState();
    _tempSelectedBookIndex = Provider.of<AppProvider>(context, listen: false).selectedBookIndex;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final books = provider.bibleData;
    final selectedBookChapters = books[_tempSelectedBookIndex].chapters;

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
                  'Select Chapter',
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
                          return ListTile(
                            title: Text(books[index].name),
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
                          crossAxisCount: 4,
                          childAspectRatio: 1.2,
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