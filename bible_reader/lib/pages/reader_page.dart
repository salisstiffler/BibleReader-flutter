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
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
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
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'ChapterSelector',
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 300),
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
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
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
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => provider.toggleChapterPlay(),
        label: Text(provider.isAutoPlaying ? l10n.pauseListening : '听全章'),
        icon: Icon(provider.isAutoPlaying ? LucideIcons.pause : LucideIcons.play),
        backgroundColor: const Color(0xFF7c3aed),
      ),
    );
  }
}

class _VerseWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isBeingRead = provider.isSpeaking && provider.currentSpeakingId == verseId;
    final isBookmarked = provider.isBookmarked(verseId);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                child: Text(
                  '$verseNumber',
                  style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  verseText,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.6,
                    color: isBeingRead ? Theme.of(context).primaryColor : null,
                    fontWeight: isBeingRead ? FontWeight.bold : FontWeight.w500,
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
                onTap: () => isBeingRead ? provider.stop() : provider.speak(verseText, verseId),
              ),
              const SizedBox(width: 20),
              _VerseActionIcon(
                icon: LucideIcons.bookmark,
                isActive: isBookmarked,
                activeColor: Colors.amber,
                onTap: () => provider.toggleBookmark(verseId),
              ),
              const SizedBox(width: 20),
              _VerseActionIcon(
                icon: LucideIcons.share2,
                onTap: () => provider.shareVerse(provider.selectedBook!.id, provider.selectedChapterIndex, verseNumber - 1),
              ),
            ],
          ),
        ],
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

class _NavigationDrawerState extends State<_NavigationDrawer> {
  late int _tempBookIdx;
  late int _tempChapIdx;
  final ScrollController _bookScrollController = ScrollController();
  final ScrollController _chapterScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AppProvider>(context, listen: false);
    _tempBookIdx = provider.selectedBookIndex;
    _tempChapIdx = provider.selectedChapterIndex;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentSelection();
    });
  }

  void _scrollToCurrentSelection() {
    if (_bookScrollController.hasClients) {
      double bookOffset = max(0, (_tempBookIdx * 52.0) - 100);
      _bookScrollController.animateTo(bookOffset, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
    if (_chapterScrollController.hasClients) {
      int row = _tempChapIdx ~/ 3;
      double chapOffset = max(0, (row * 60.0) - 100);
      _chapterScrollController.animateTo(chapOffset, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  void dispose() {
    _bookScrollController.dispose();
    _chapterScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final books = provider.bibleData;
    final chapters = books.isNotEmpty ? books[_tempBookIdx].chapters : [];

    return Drawer(
      width: 420,
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
                              _tempChapIdx = 0; // 切换书名默认选择第一个章节
                            });
                            if (_chapterScrollController.hasClients) {
                              _chapterScrollController.jumpTo(0);
                            }
                            provider.navigateTo(_tempBookIdx, 0);
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
    );
  }
}
