import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/bible_verse.dart';
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
  final Map<int, GlobalKey> _verseKeys = {};

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
      _verseKeys.clear(); // Clear keys when chapter changes
      if (_scrollController.hasClients) {
        _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
      _previousBookIndex = provider.selectedBookIndex;
      _previousChapterIndex = provider.selectedChapterIndex;
    }
  }

  void _scrollToVerse(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _verseKeys[index];
      if (key != null && key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
        Provider.of<AppProvider>(context, listen: false).clearTargetVerse();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showChapterSelector(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'ChapterSelector',
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ChangeNotifierProvider.value(
                value: provider,
                child: const _ChapterSelectorView(),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOutBack),
            ),
            child: child,
          ),
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

    // Check for target verse to scroll
    if (provider.targetVerseIndex != null) {
      _scrollToVerse(provider.targetVerseIndex!);
    }

    return Scaffold(
      drawer: _NavigationDrawer(l10n: l10n),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
            elevation: 0,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(LucideIcons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.indigo, Colors.blueAccent],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.bookOpen, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.indigo, Colors.blueAccent],
                  ).createShader(Offset.zero & bounds.size),
                  child: Text(
                    l10n.appTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
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
                    children: [
                      if (provider.dailyVerse != null)
                        _DailyVerseCard(verse: provider.dailyVerse!, l10n: l10n),
                      const SizedBox(height: 20),
                      _ChapterSelectorButton(
                        bookName: provider.selectedBook!.id,
                        chapterIndex: provider.selectedChapterIndex,
                        onTap: () => _showChapterSelector(context),
                        l10n: l10n,
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(LucideIcons.listChecks, size: 16),
                          label: const Text('批量操作', style: TextStyle(fontSize: 12)),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.05),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final verseText = provider.selectedChapter![index];
                  final verseId = BibleVerse(
                    bookId: provider.selectedBook!.id,
                    bookIndex: provider.selectedBookIndex,
                    chapterIndex: provider.selectedChapterIndex,
                    verseIndex: index,
                    text: verseText,
                  ).id;
                  return _VerseWidget(
                    key: _verseKeys.putIfAbsent(index, () => GlobalKey()),
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(LucideIcons.chevronLeft, size: 18),
                      label: Text(l10n.previousChapter),
                      onPressed: () {
                        provider.previousChapter();
                        _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Text(l10n.nextChapter, style: const TextStyle(color: Colors.white)),
                      label: const Icon(LucideIcons.chevronRight, size: 18, color: Colors.white),
                      onPressed: () {
                        provider.nextChapter();
                        _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () => provider.toggleChapterPlay(),
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: provider.isAutoPlaying ? const [Color(0xFF8b5cf6), Color(0xFFd946ef)] : const [Color(0xFF6366f1), Color(0xFF4f46e5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                provider.isAutoPlaying ? LucideIcons.pause : LucideIcons.play,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                provider.isAutoPlaying ? l10n.pauseListening : '听全章',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
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
    super.key,
    required this.verseText,
    required this.verseNumber,
    required this.verseId,
    required this.l10n,
  });

  @override
  State<_VerseWidget> createState() => _VerseWidgetState();
}

class _VerseWidgetState extends State<_VerseWidget> {
  bool _showEditor = false;
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
    final currentNote = provider.getNote(widget.verseId);
    final hasNote = currentNote != null && currentNote.isNotEmpty;
    final highlightColorName = provider.getHighlight(widget.verseId);

    if (_showEditor) {
      _noteController.text = currentNote ?? '';
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _showEditor = !_showEditor),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      child: Text(
                        '${widget.verseNumber}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: (highlightColorName != null || hasNote) ? _getHighlightColor(highlightColorName ?? 'yellow') : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.6,
                              color: isBeingRead ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge?.color,
                              fontWeight: isBeingRead ? FontWeight.bold : FontWeight.w500,
                            ),
                            children: [
                              TextSpan(text: widget.verseText),
                              if (hasNote)
                                const WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 6.0),
                                    child: Icon(LucideIcons.fileText, size: 16, color: Color(0xFF10b981)),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const SizedBox(width: 24),
                    _VerseActionIcon(
                      icon: LucideIcons.volume2,
                      isActive: isBeingRead,
                      onTap: () => isBeingRead ? provider.stop() : provider.speak(widget.verseText, widget.verseId),
                    ),
                    const SizedBox(width: 20),
                    _VerseActionIcon(
                      icon: LucideIcons.bookmark,
                      isActive: isBookmarked,
                      activeColor: Colors.amber,
                      onTap: () => provider.toggleBookmark(widget.verseId),
                    ),
                    const SizedBox(width: 20),
                    _VerseActionIcon(
                      icon: LucideIcons.share2,
                      onTap: () => provider.shareVerse(provider.selectedBook!.id, provider.selectedChapterIndex, widget.verseNumber - 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _showEditor ? Container(
            margin: const EdgeInsets.only(top: 8, bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _HighlightDot(color: const Color(0xFFfef08a), isSelected: highlightColorName == 'yellow', onTap: () => provider.setHighlight(widget.verseId, highlightColorName == 'yellow' ? null : 'yellow')),
                        const SizedBox(width: 12),
                        _HighlightDot(color: const Color(0xFFbbf7d0), isSelected: highlightColorName == 'green', onTap: () => provider.setHighlight(widget.verseId, highlightColorName == 'green' ? null : 'green')),
                        const SizedBox(width: 12),
                        _HighlightDot(color: const Color(0xFFbfdbfe), isSelected: highlightColorName == 'blue', onTap: () => provider.setHighlight(widget.verseId, highlightColorName == 'blue' ? null : 'blue')),
                        const SizedBox(width: 12),
                        _HighlightDot(color: const Color(0xFFfecaca), isSelected: highlightColorName == 'red', onTap: () => provider.setHighlight(widget.verseId, highlightColorName == 'red' ? null : 'red')),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x, size: 18, color: Colors.grey),
                      onPressed: () => setState(() => _showEditor = false),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: TextField(
                    controller: _noteController,
                    maxLines: 5,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: '写下你的灵修感悟...',
                      contentPadding: EdgeInsets.all(16),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 15, height: 1.5),
                    onChanged: (text) => provider.saveNote(widget.verseId, text),
                  ),
                ),
              ],
            ),
          ) : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _HighlightDot extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
  const _HighlightDot({required this.color, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          color: color, shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.black.withOpacity(0.1), width: 1) : null,
        ),
        child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
      ),
    );
  }
}

class _VerseActionIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final Color? activeColor;
  final VoidCallback onTap;

  const _VerseActionIcon({
    required this.icon,
    this.isActive = false,
    this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        icon,
        size: 18,
        color: isActive ? (activeColor ?? Theme.of(context).primaryColor) : Colors.grey.withOpacity(0.6),
      ),
    );
  }
}

class _DailyVerseCard extends StatelessWidget {
  final BibleVerse verse;
  final AppLocalizations l10n;
  const _DailyVerseCard({required this.verse, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final bookName = provider.getLocalizedBookName(context, verse.bookId);
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366f1), Color(0xFFa855f7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.dailyWisdom, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(
            '“${verse.text}”',
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, height: 1.5),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              '— $bookName ${verse.chapterIndex + 1}:${verse.verseIndex + 1}',
              style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChapterSelectorButton extends StatelessWidget {
  final String bookName;
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
    final localizedBookName = provider.getLocalizedBookName(context, bookName);
    final chapterText = provider.currentLanguage.startsWith('zh') ? '第 ${chapterIndex + 1} 章' : 'Chapter ${chapterIndex + 1}';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF1e293b).withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            const Icon(LucideIcons.book, size: 20, color: Colors.indigo),
            const SizedBox(width: 12),
            Text(
              '$localizedBookName • $chapterText',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Spacer(),
            const Icon(LucideIcons.chevronDown, size: 20, color: Colors.grey),
          ],
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
  late int _tempBookIdx;
  late int _tempChapIdx;

  @override
  void initState() {
    super.initState();
    final p = Provider.of<AppProvider>(context, listen: false);
    _tempBookIdx = p.selectedBookIndex;
    _tempChapIdx = p.selectedChapterIndex;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final books = provider.bibleData;
    final chapters = books.isNotEmpty ? books[_tempBookIdx].chapters : [];

    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 420,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 40, offset: const Offset(0, 15)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final isSel = index == _tempBookIdx;
                  return InkWell(
                    onTap: () => setState(() { _tempBookIdx = index; _tempChapIdx = 0; }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isSel ? Colors.indigo : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        provider.getLocalizedBookName(context, books[index].id),
                        style: TextStyle(color: isSel ? Colors.white : Colors.black87, fontWeight: isSel ? FontWeight.bold : FontWeight.w500),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(
              flex: 4,
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 2.2,
                ),
                itemCount: chapters.length,
                itemBuilder: (context, index) {
                  final isSel = index == _tempChapIdx;
                  return InkWell(
                    onTap: () {
                      provider.navigateTo(_tempBookIdx, index);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSel ? Colors.indigo : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(color: isSel ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationDrawer extends StatefulWidget {
  final AppLocalizations l10n;
  const _NavigationDrawer({required this.l10n});

  @override
  State<_NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<_NavigationDrawer> with SingleTickerProviderStateMixin {
  late int _tempBookIdx;
  late int _tempChapIdx;
  final ScrollController _bookScrollController = ScrollController();
  final ScrollController _chapterScrollController = ScrollController();
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AppProvider>(context, listen: false);
    _tempBookIdx = provider.selectedBookIndex;
    _tempChapIdx = provider.selectedChapterIndex;

    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _slideAnimation = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    
    _animController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentSelection();
    });
  }

  void _scrollToCurrentSelection() {
    if (_bookScrollController.hasClients) {
      double bookOffset = max(0, (_tempBookIdx * 52.0) - 100);
      _bookScrollController.jumpTo(bookOffset);
    }
    if (_chapterScrollController.hasClients) {
      int row = _tempChapIdx ~/ 3;
      double chapOffset = max(0, (row * 60.0) - 100);
      _chapterScrollController.jumpTo(chapOffset);
    }
  }

  @override
  void dispose() {
    _bookScrollController.dispose();
    _chapterScrollController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final books = provider.bibleData;
    final chapters = books.isNotEmpty ? books[_tempBookIdx].chapters : [];

    return SlideTransition(
      position: _slideAnimation,
      child: Drawer(
        width: min(MediaQuery.of(context).size.width * 0.8, 420),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, left: 20, right: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '章节导航',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: const Color(0xFFF8F9FA),
                      child: ListView.builder(
                        controller: _bookScrollController,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final isSel = index == _tempBookIdx;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _tempBookIdx = index;
                                _tempChapIdx = 0;
                              });
                              if (_chapterScrollController.hasClients) {
                                _chapterScrollController.jumpTo(0);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                color: isSel ? Colors.indigo : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                provider.getLocalizedBookName(context, books[index].id),
                                style: TextStyle(
                                  color: isSel ? Colors.white : Colors.black87,
                                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: GridView.builder(
                      controller: _chapterScrollController,
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                      ),
                      itemCount: chapters.length,
                      itemBuilder: (context, index) {
                        final isCurrentChap = index == _tempChapIdx;
                        return InkWell(
                          onTap: () {
                            provider.navigateTo(_tempBookIdx, index);
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isCurrentChap ? Colors.indigo : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: isCurrentChap ? Colors.indigo : Colors.grey.shade300),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isCurrentChap ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
      ),
    );
  }
}
