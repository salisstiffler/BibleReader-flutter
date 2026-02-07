import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart'; // Import app localizations
import '../providers/app_provider.dart';
import '../models/verse_range.dart'; // Import VerseRange
import '../theme.dart'; // Import AppTheme

class FullscreenReaderPage extends StatefulWidget {
  const FullscreenReaderPage({super.key});

  @override
  State<FullscreenReaderPage> createState() => _FullscreenReaderPageState();
}

class _FullscreenReaderPageState extends State<FullscreenReaderPage>
    with TickerProviderStateMixin {
  int _currentPageIndex = 0;
  bool _showUI = false;
  List<List<String>> _pages = [];
  final Map<int, GlobalKey> _verseKeys = {};

  // Keys for interactive controls so we can detect taps on them and avoid
  // treating those taps as page-turn gestures.
  final GlobalKey _mainFabKey = GlobalKey();
  final GlobalKey _smallFab1Key = GlobalKey();
  final GlobalKey _smallFab2Key = GlobalKey();

  late AnimationController _hideUITimer;
  late AnimationController _pageTransitionController;

  // Define lineHeightPixels as a constant for now
  static const double lineHeightPixels = 20.0;

  // Interaction/UI state similar to the React implementation
  bool _showArcMenu = false;
  String _interactionMode = 'none'; // 'none' | 'bookmark' | 'note'

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
  void initState() {
    super.initState();
    _hideUITimer = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _pageTransitionController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _hideUITimer.dispose();
    _pageTransitionController.dispose();
    super.dispose();
  }

  void _startAutoHideTimer() {
    _hideUITimer.stop();
    if (!_hideUITimer.isAnimating) {
      _hideUITimer.reset();
      _hideUITimer.forward().then((_) {
        if (mounted && _showUI) {
          setState(() {
            _showUI = false;
          });
        }
      });
    }
  }

  bool _isWithinKey(GlobalKey key, Offset globalPos) {
    final ctx = key.currentContext;
    if (ctx == null) return false;
    final renderBox = ctx.findRenderObject() as RenderBox?;
    if (renderBox == null) return false;
    final topLeft = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    return Rect.fromLTWH(
      topLeft.dx,
      topLeft.dy,
      size.width,
      size.height,
    ).contains(globalPos);
  }

  List<List<String>> _paginateChapter(
    List<String> chapter,
    double fontSize,
    double lineHeight,
  ) {
    if (chapter.isEmpty) return [];

    final pages = <List<String>>[];
    final screenHeight = MediaQuery.of(context).size.height - 160;

    final maxLinesPerPage = (screenHeight / lineHeightPixels).floor();

    List<String> currentPage = [];
    int linesInCurrentPage = 0;

    for (final verse in chapter) {
      final verseLines = verse.split('\n').length;

      if (linesInCurrentPage + verseLines > maxLinesPerPage &&
          currentPage.isNotEmpty) {
        pages.add(currentPage);
        currentPage = [];
        linesInCurrentPage = 0;
      }

      currentPage.add(verse);
      linesInCurrentPage += verseLines + 1;
    }

    if (currentPage.isNotEmpty) {
      pages.add(currentPage);
    }

    return pages;
  }

  void _nextPage(AppProvider provider) {
    _pageTransitionController.reset();
    _pageTransitionController.forward();

    if (_currentPageIndex < _pages.length - 1) {
      setState(() {
        _currentPageIndex++;
      });
    } else {
      if (provider.selectedChapterIndex <
          provider.selectedBook!.chapters.length - 1) {
        provider.navigateTo(
          provider.selectedBookIndex,
          provider.selectedChapterIndex + 1,
        );
      } else if (provider.selectedBookIndex < provider.bibleData.length - 1) {
        provider.navigateTo(provider.selectedBookIndex + 1, 0);
      }
      setState(() {
        _currentPageIndex = 0;
      });
    }
    setState(() {
      _showUI = false;
    });
  }

  void _prevPage(AppProvider provider) {
    _pageTransitionController.reset();
    _pageTransitionController.forward();

    if (_currentPageIndex > 0) {
      setState(() {
        _currentPageIndex--;
      });
    } else {
      if (provider.selectedChapterIndex > 0) {
        provider.navigateTo(
          provider.selectedBookIndex,
          provider.selectedChapterIndex - 1,
        );
      } else if (provider.selectedBookIndex > 0) {
        final prevBook = provider.bibleData[provider.selectedBookIndex - 1];
        provider.navigateTo(
          provider.selectedBookIndex - 1,
          prevBook.chapters.length - 1,
        );
      }
      setState(() {
        _currentPageIndex = 0;
      });
    }
    setState(() {
      _showUI = false;
    });
  }

  void _toggleUI() {
    setState(() {
      _showUI = !_showUI;
    });
    if (_showUI) {
      _startAutoHideTimer();
    }
  }

  void _playCurrentPage(AppProvider provider) {
    final pageVerses = _pages.isNotEmpty ? _pages[_currentPageIndex] : null;
    if (pageVerses == null || pageVerses.isEmpty) return;

    final firstVerseText = pageVerses.first;
    // Assuming a single verse per list item for simplicity in TTS for now
    final globalVerseIndex = _pages
            .take(_currentPageIndex)
            .fold<int>(0, (s, p) => s + p.length) +
        1;
    final verseRange = VerseRange(
      bookId: provider.selectedBook!.id,
      chapter: provider.selectedChapterIndex,
      startVerse: globalVerseIndex,
      endVerse: globalVerseIndex,
    );
    provider.speak(firstVerseText, verseRange.id);
  }

  void _handleVerseClickInMode(
      AppProvider provider, int globalVerseIndex, BuildContext context) {
    final verseRange = VerseRange(
      bookId: provider.selectedBook!.id,
      chapter: provider.selectedChapterIndex,
      startVerse: globalVerseIndex,
      endVerse: globalVerseIndex,
    );

    if (_interactionMode == 'bookmark') {
      provider.toggleBookmark(verseRange);
      setState(() {
        _interactionMode = 'none';
      });
    } else if (_interactionMode == 'note') {
      final existing = provider.getNote(
          verseRange.bookId, verseRange.chapter, verseRange.startVerse);
      _showNoteDialog(context, provider, verseRange, existing?.text ?? '');
      setState(() {
        _interactionMode = 'none';
      });
    }
  }

  void _exitFullscreen() {
    Navigator.pop(context);
  }

  // 优化右下角按钮交互，避免误触翻 — use global coordinates and the control keys
  void _handlePageTap(Offset globalPos, AppProvider provider) {
    // If tap is inside any control, ignore it so the control receives the tap.
    if (_isWithinKey(_mainFabKey, globalPos) ||
        _isWithinKey(_smallFab1Key, globalPos) ||
        _isWithinKey(_smallFab2Key, globalPos)) {
      return;
    }

    final width = MediaQuery.of(context).size.width;
    final x = globalPos.dx;

    if (x < width / 3) {
      _prevPage(provider);
    } else if (x > (width * 2) / 3) {
      _nextPage(provider);
    } else {
      _toggleUI();
    }
  }

  void _showVerseMenu(
      AppProvider provider, int verseNumber, BuildContext context) {
    final verseRange = VerseRange(
      bookId: provider.selectedBook!.id,
      chapter: provider.selectedChapterIndex,
      startVerse: verseNumber,
      endVerse: verseNumber,
    );
    final isBookmarked = provider.isBookmarked(
        verseRange.bookId, verseRange.chapter, verseRange.startVerse);
    final existingNote = provider.getNote(
        verseRange.bookId, verseRange.chapter, verseRange.startVerse);
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                isBookmarked != null
                    ? LucideIcons.bookmarkCheck
                    : LucideIcons.bookmark,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                isBookmarked != null ? l10n.readerBookmark : l10n.readerBookmark,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                provider.toggleBookmark(verseRange);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(LucideIcons.penTool, color: Theme.of(context).primaryColor),
              title: Text(
                l10n.readerAddNote,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                _showNoteDialog(context, provider, verseRange, existingNote?.text ?? '');
              },
            ),
            ListTile(
              leading: Icon(LucideIcons.logOut, color: Theme.of(context).colorScheme.error),
              title: Text(
                l10n.readerExitFullscreen,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNoteDialog(
    BuildContext context,
    AppProvider provider,
    VerseRange verseRange,
    String initialText,
  ) {
    final controller = TextEditingController(text: initialText);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(l10n.readerAddNote, style: Theme.of(context).textTheme.titleLarge),
        content: TextField(
          controller: controller,
          maxLines: 5,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            hintText: l10n.readerNotePlaceholder,
            hintStyle: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () {
              provider.saveNote(verseRange, controller.text);
              Navigator.pop(context);
            },
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
  }

  // 添加字体设置和背景切换功能的UI组件
  void _showSettingsMenu(AppProvider provider, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.text_fields, color: Theme.of(context).primaryColor),
              title: Text(
                l10n.settingsFontSize,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                // 打开字体大小设置对话框
                Navigator.pop(context);
                _showFontSizeDialog(provider, l10n);
              },
            ),
            ListTile(
              leading: Icon(LucideIcons.image, color: Theme.of(context).primaryColor),
              title: Text(
                l10n.settingsVisualStyle,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                // 打开背景切换设置
                Navigator.pop(context);
                _showBackgroundDialog(provider, l10n);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFontSizeDialog(AppProvider provider, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(l10n.settingsFontSize, style: Theme.of(context).textTheme.titleLarge),
        content: Slider(
          value: provider.fontSize,
          min: 12,
          max: 30,
          divisions: 18,
          label: provider.fontSize.toStringAsFixed(0),
          onChanged: (value) {
            provider.fontSize = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonClose),
          ),
        ],
      ),
    );
  }

  void _showBackgroundDialog(AppProvider provider, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(l10n.settingsVisualStyle, style: Theme.of(context).textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.brightness_1, color: Theme.of(context).primaryColor),
              title: Text(l10n.settingsThemeDark, style: Theme.of(context).textTheme.bodyLarge),
              onTap: () {
                provider.theme = AppTheme.dark;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.brightness_5, color: Theme.of(context).primaryColor),
              title: Text(l10n.settingsThemeLight, style: Theme.of(context).textTheme.bodyLarge),
              onTap: () {
                provider.theme = AppTheme.light;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(LucideIcons.book, color: Theme.of(context).primaryColor),
              title: Text(l10n.settingsThemeSepia, style: Theme.of(context).textTheme.bodyLarge),
              onTap: () {
                provider.theme = AppTheme.sepia;
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonClose, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final l10n = AppLocalizations.of(context)!;
        if (provider.selectedBook == null || provider.selectedChapter == null) {
          return Scaffold(
            body: GestureDetector(
              onTap: _toggleUI,
              child: Container(
                color: Colors.black,
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          );
        }

        _pages = _paginateChapter(
          provider.selectedChapter!,
          provider.fontSize,
          provider.lineHeight,
        );

        if (_pages.isEmpty) {
          return Scaffold(
            body: GestureDetector(
              onTap: _toggleUI,
              child: Container(
                color: Colors.black,
                child: Center(
                  child: Text(
                    l10n.globalSearchEmpty, // Using a generic empty message
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        }

        final currentPage = _pages[_currentPageIndex];
        final bookName = _getLocalizedBookName(
          context,
          provider.selectedBook!.id,
        );

        // 调整全屏阅读页面的UI，使其与用户提供的图片保持一致
        return Scaffold(
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) {
              _handlePageTap(details.globalPosition, provider);
            },
            child: Container(
              color: Colors.white, // 背景颜色调整为白色
              child: Stack(
                children: [
                  // 内容区域
                  Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32.0,
                          vertical: 40.0,
                        ),
                        child: _buildPageWithTransition(provider, currentPage),
                      ),
                    ),
                  ),

                  // 顶部标题栏
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Text(
                      l10n.readerChapterSelect(
                          bookName,
                          (provider.selectedChapterIndex + 1).toString()),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // 顶部右侧 播放/停止 按钮
                  if (_showUI)
                    Positioned(
                      top: 20,
                      right: 44,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _showUI ? 1.0 : 0.0,
                        child: GestureDetector(
                          onTap: () {
                            if (provider.isSpeaking) {
                              provider.stop();
                            } else {
                              _playCurrentPage(provider);
                            }
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: provider.isSpeaking
                                  ? Colors.redAccent
                                  : Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Icon(
                              provider.isSpeaking
                                  ? Icons.stop
                                  : Icons.play_arrow,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // 右下角按钮组（与截图布局相近）
                  if (_showUI)
                    Positioned(
                      bottom: 24,
                      right: 24,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          // Arc items (appear when _showArcMenu is true)
                          if (_showArcMenu) ...[
                            // Left button (bookmark)
                            Positioned(
                              right: 84,
                              bottom: 16,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: _showArcMenu ? 1 : 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _interactionMode =
                                          _interactionMode == 'bookmark'
                                              ? 'none'
                                              : 'bookmark';
                                      _showArcMenu = false;
                                    });
                                  },
                                  child: Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(28),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.12),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.bookmark_border,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Top-left (note)
                            Positioned(
                              right: 64,
                              bottom: 88,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: _showArcMenu ? 1 : 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _interactionMode = 'note';
                                      _showArcMenu = false;
                                    });
                                  },
                                  child: Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade100,
                                      borderRadius: BorderRadius.circular(28),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.12),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.sticky_note_2,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Top (exit)
                            Positioned(
                              right: 16,
                              bottom: 120,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: _showArcMenu ? 1 : 0,
                                child: GestureDetector(
                                  onTap: () {
                                    // exit fullscreen
                                    _exitFullscreen();
                                  },
                                  child: Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade100,
                                      borderRadius: BorderRadius.circular(28),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.12),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.logout,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],

                          // small orange button (copy / quick action)
                          Positioned(
                            right: 92,
                            bottom: 16,
                            child: Container(
                              key: _smallFab2Key,
                              margin: const EdgeInsets.only(bottom: 0),
                              child: FloatingActionButton.small(
                                backgroundColor: Colors.orange.shade100,
                                onPressed: () {
                                  final pageText = _pages.isNotEmpty
                                      ? _pages[_currentPageIndex].join('\n\n')
                                      : '';
                                  Clipboard.setData(
                                    ClipboardData(text: pageText),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.readerShareSuccess),
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.content_copy,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ),

                          // small blue bookmark button
                          Positioned(
                            right: 56,
                            bottom: 16,
                            child: Container(
                              key: _smallFab1Key,
                              margin: const EdgeInsets.only(bottom: 0),
                              child: FloatingActionButton.small(
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    _interactionMode =
                                        _interactionMode == 'bookmark'
                                            ? 'none'
                                            : 'bookmark';
                                  });
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        _interactionMode == 'bookmark'
                                            ? l10n.readerRangeSelect // Using range select as a generic placeholder
                                            : l10n.commonCancel, // Generic cancel
                                      ),
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.bookmark_border,
                                  color: Colors.indigo,
                                ),
                              ),
                            ),
                          ),

                          // main purple FAB
                          Positioned(
                            right: 16,
                            bottom: 16,
                            child: Container(
                              key: _mainFabKey,
                              child: GestureDetector(
                                onLongPress: () => _showSettingsMenu(provider, context),
                                child: FloatingActionButton(
                                  backgroundColor: const Color(0xFF6C63FF),
                                  onPressed: () {
                                    if (_interactionMode != 'none') {
                                      // confirm interaction
                                      setState(() {
                                        _interactionMode = 'none';
                                      });
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(l10n.notesConfirm),
                                        ),
                                      );
                                    } else {
                                      setState(() {
                                        _showArcMenu = !_showArcMenu;
                                      });
                                    }
                                  },
                                  child: Icon(
                                    _interactionMode != 'none'
                                        ? Icons.check
                                        : (_showArcMenu
                                              ? Icons.close
                                              : Icons.edit),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageWithTransition(
    AppProvider provider,
    List<String> currentPage,
  ) {
    final effect = provider.pageTurnEffect;

    return ScaleTransition(
      scale: _pageTransitionController.drive(
        Tween<double>(begin: 0.95, end: 1.0),
      ),
      child: FadeTransition(
        opacity: _pageTransitionController.drive(
          Tween<double>(begin: effect == 'fade' ? 0.0 : 1.0, end: 1.0),
        ),
        child: _buildPageContent(provider, currentPage),
      ),
    );
  }

  Widget _buildPageContent(AppProvider provider, List<String> currentPage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(currentPage.length, (idx) {
        final globalVerseNumber =
            _pages
                .take(_currentPageIndex)
                .fold<int>(0, (sum, page) => sum + page.length) +
            idx + 1; // Verse numbers are 1-based

        final verseRange = VerseRange(
          bookId: provider.selectedBook!.id,
          chapter: provider.selectedChapterIndex,
          startVerse: globalVerseNumber,
          endVerse: globalVerseNumber,
        );
        
        final isBookmarked = provider.isBookmarked(
            provider.selectedBook!.id, provider.selectedChapterIndex, globalVerseNumber);
        final hasNote = provider.getNote(
                provider.selectedBook!.id, provider.selectedChapterIndex, globalVerseNumber) !=
            null;

        // Ensure key is unique for this verse
        _verseKeys.putIfAbsent(globalVerseNumber, () => GlobalKey());

        final isBeingRead = provider.isSpeaking && provider.currentSpeakingId == verseRange.id;

        if (isBeingRead) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final key = _verseKeys[globalVerseNumber];
            if (key != null && key.currentContext != null) {
              Scrollable.ensureVisible(
                key.currentContext!,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                alignment: 0.5, // Center the item
              );
            }
          });
        }


        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: GestureDetector(
            onLongPress: () => _showVerseMenu(provider, globalVerseNumber, context),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$globalVerseNumber',
                  style: TextStyle(
                    fontSize: provider.fontSize * 0.7,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_interactionMode != 'none') {
                            _handleVerseClickInMode(
                                provider, globalVerseNumber, context);
                          }
                        },
                        child: Text(
                          key: _verseKeys[globalVerseNumber], // Assign the key here
                          currentPage[idx],
                          style: TextStyle(
                            fontSize: provider.fontSize,
                            height: provider.lineHeight,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      if (isBookmarked != null || hasNote)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              if (isBookmarked != null)
                                Icon(
                                  LucideIcons.bookmarkCheck,
                                  size: 16,
                                  color: Colors.indigo,
                                ),
                              if (hasNote) ...[
                                if (isBookmarked != null) const SizedBox(width: 8),
                                Icon(
                                  LucideIcons.stickyNote,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}