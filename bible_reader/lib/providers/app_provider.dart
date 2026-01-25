import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../models/bible_data.dart';
import '../models/bible_verse.dart'; // Import BibleVerse
import '../services/bible_service.dart';

// Helper for Theme Colors
enum AppTheme {
  light,
  dark,
  sepia;

  String get id => name;
  ThemeData get themeData {
    switch (this) {
      case AppTheme.light:
        return ThemeData(
          brightness: Brightness.light,
          primaryColor: const Color(0xFF6366f1),
          // indigo
          scaffoldBackgroundColor: const Color(0xFFffffff),
          cardColor: const Color(0xFFf9fafb),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFF1f2937)),
            bodyMedium: TextStyle(color: Color(0xFF1f2937)),
            bodySmall: TextStyle(color: Color(0xFF6b7280)), // secondary-text
            titleLarge: TextStyle(color: Color(0xFF1f2937)),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFffffff),
            foregroundColor: Color(0xFF1f2937),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366f1),
              foregroundColor: Colors.white,
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF6366f1),
              side: const BorderSide(color: Color(0xFFe5e7eb)),
            ),
          ),
          dividerColor: const Color(0xFFe5e7eb),
        );
      case AppTheme.dark:
        return ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF818cf8),
          // indigo-300
          scaffoldBackgroundColor: const Color(0xFF111827),
          cardColor: const Color(0xFF1f2937),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFFf9fafb)),
            bodyMedium: TextStyle(color: Color(0xFFf9fafb)),
            bodySmall: TextStyle(color: Color(0xFF9ca3af)), // secondary-text
            titleLarge: TextStyle(color: Color(0xFFf9fafb)),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF111827),
            foregroundColor: Color(0xFFf9fafb),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF818cf8),
              foregroundColor: Colors.white,
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF818cf8),
              side: const BorderSide(color: Color(0xFF374151)),
            ),
          ),
          dividerColor: const Color(0xFF374151),
        );
      case AppTheme.sepia:
        return ThemeData(
          brightness: Brightness.light, // Sepia usually feels light
          primaryColor: const Color(0xFF795548),
          // brown
          scaffoldBackgroundColor: const Color(0xFFf4ecd8),
          cardColor: const Color(0xFFeaddca),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFF5d4037)),
            bodyMedium: TextStyle(color: Color(0xFF5d4037)),
            bodySmall: TextStyle(color: Color(0xFF8d6e63)), // secondary-text
            titleLarge: TextStyle(color: Color(0xFF5d4037)),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFf4ecd8),
            foregroundColor: Color(0xFF5d4037),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF795548),
              foregroundColor: Colors.white,
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF795548),
              side: const BorderSide(color: Color(0xFFd7ccc8)),
            ),
          ),
          dividerColor: const Color(0xFFd7ccc8),
        );
    }
  }
}

class AppProvider with ChangeNotifier {
  final BibleService _bibleService = BibleService();
  final FlutterTts _flutterTts = FlutterTts();
  late SharedPreferences _prefs;

  // Data state
  bool _isLoading = true;
  String _currentLanguageCode = 'zh'; // Store language code for persistence
  Locale? _appLocale;
  List<BibleBook> _bibleData = [];
  int _selectedBookIndex = 0;
  int _selectedChapterIndex = 0;
  BibleVerse? _dailyVerse;

  // Navigation state
  int? _targetVerseIndex;

  // TTS State
  bool _isSpeaking = false;
  bool _isAutoPlaying = false;
  String? _currentSpeakingId; // Format: "BookId-Chapter:Verse"

  // Bookmarks State
  final Set<String> _bookmarks = {}; // Stores verse IDs

  // Notes State
  final Map<String, String> _notes = {}; // Stores verse IDs to note text

  // Highlights State
  final Map<String, String> _highlights = {}; // Stores verse IDs to color string

  // Settings State
  AppTheme _theme = AppTheme.light;
  double _fontSize = 18.0;
  bool _pauseOnManualSwitch = true;
  bool _continuousReading = false;
  double _playbackRate = 1.0;

  // UI State (for AppShell navigation)
  int _currentTabIndex = 0;

  // Public getters
  bool get isLoading => _isLoading;
  String get currentLanguage => _currentLanguageCode;
  Locale? get appLocale => _appLocale;
  List<BibleBook> get bibleData => _bibleData;
  int get selectedBookIndex => _selectedBookIndex;
  int get selectedChapterIndex => _selectedChapterIndex;
  BibleVerse? get dailyVerse => _dailyVerse;
  int? get targetVerseIndex => _targetVerseIndex;
  bool get isSpeaking => _isSpeaking;
  bool get isAutoPlaying => _isAutoPlaying;
  String? get currentSpeakingId => _currentSpeakingId;
  Set<String> get bookmarks => Set.unmodifiable(_bookmarks);
  Map<String, String> get allNotes => Map.unmodifiable(_notes);
  Map<String, String> get allHighlights => Map.unmodifiable(_highlights);
  AppTheme get theme => _theme;
  double get fontSize => _fontSize;
  bool get pauseOnManualSwitch => _pauseOnManualSwitch;
  bool get continuousReading => _continuousReading;
  double get playbackRate => _playbackRate;
  int get currentTabIndex => _currentTabIndex;

  bool isBookmarked(String verseId) => _bookmarks.contains(verseId);
  String? getNote(String verseId) => _notes[verseId];
  String? getHighlight(String verseId) => _highlights[verseId];

  BibleBook? get selectedBook => _bibleData.isNotEmpty ? _bibleData[_selectedBookIndex] : null;
  List<String>? get selectedChapter => selectedBook != null && _selectedChapterIndex < selectedBook!.chapters.length ? selectedBook!.chapters[_selectedChapterIndex] : null;

  AppProvider() {
    _initPrefs();
    _initTts();
    // loadBible will be called after _initPrefs, which loads the language.
    // Deep link handling might happen after initial load.
  }

  Future<void> initializeApp(Uri? initialUri) async {
    await _initPrefs(); // Load preferences including language
    _initTts();
    await loadBible(_currentLanguageCode); // Load bible data and set locale

    if (initialUri != null) {
      _handleDeepLink(initialUri);
    }

    _generateDailyVerse(); // Generate daily verse after data is loaded and potential deep link navigated
    notifyListeners(); // Notify after all initial setup is done
  }

  // --- Deep Linking ---
  void _handleDeepLink(Uri uri) {
    print('Handling deep link: $uri');
    // For local testing, uri.host will be localhost, so we remove the host check.
    // In production, you might want to enforce a specific host.
    if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'read') {
      final params = uri.queryParameters;
      final bookId = params['book']; // Changed from bookName to bookId
      final chapter = int.tryParse(params['chapter'] ?? '');
      final verse = int.tryParse(params['verse'] ?? '');

      print('Parsed deep link - Book: $bookId, Chapter: $chapter, Verse: $verse');

      if (bookId != null && chapter != null && verse != null) {
        final bookIndex = _bibleData.indexWhere((book) => book.id == bookId); // Search by book.id
        print('Book index for $bookId: $bookIndex');
        if (bookIndex != -1) {
          // Adjust to 0-based index
          navigateTo(bookIndex, chapter - 1);
          _targetVerseIndex = verse - 1;
          // TODO: Add logic to highlight/scroll to specific verse if needed in ReaderPage
          currentTabIndex = 0; // Switch to reader tab
          print('Navigated to $bookId chapter ${chapter}');
        } else {
          print('Book not found for deep link: $bookId');
        }
      } else {
        print('Invalid deep link parameters.');
      }
    }
  }

  // --- Persistence ---
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadBookmarks();
    _loadNotes();
    _loadHighlights();
    _loadSettings();
  }

  // Bookmarks
  void _loadBookmarks() {
    final List<String>? storedBookmarks = _prefs.getStringList('bookmarks');
    if (storedBookmarks != null) {
      _bookmarks.addAll(storedBookmarks);
      // notifyListeners(); // No need to notify here, initial load
    }
  }

  Future<void> _saveBookmarks() async {
    await _prefs.setStringList('bookmarks', _bookmarks.toList());
  }

  // Notes
  void _loadNotes() {
    final String? storedNotesJson = _prefs.getString('notes');
    if (storedNotesJson != null) {
      _notes.addAll(Map<String, String>.from(json.decode(storedNotesJson)));
      // notifyListeners();
    }
  }

  Future<void> _saveNotes() async {
    await _prefs.setString('notes', json.encode(_notes));
  }

  // Highlights
  void _loadHighlights() {
    final String? storedHighlightsJson = _prefs.getString('highlights');
    if (storedHighlightsJson != null) {
      _highlights.addAll(Map<String, String>.from(json.decode(storedHighlightsJson)));
      // notifyListeners();
    }
  }

  Future<void> _saveHighlights() async {
    await _prefs.setString('highlights', json.encode(_highlights));
  }

  // Settings
  void _loadSettings() {
    _pauseOnManualSwitch = _prefs.getBool('pauseOnManualSwitch') ?? true;
    _continuousReading = _prefs.getBool('continuousReading') ?? false;
    _playbackRate = _prefs.getDouble('playbackRate') ?? 1.0;
    _currentLanguageCode = _prefs.getString('currentLanguageCode') ?? 'zh'; // Load last used language, default to 'zh'
    _appLocale = _getLocaleFromCode(_currentLanguageCode); // Initialize appLocale from stored code
    final themeId = _prefs.getString('theme') ?? AppTheme.light.id;
    _theme = AppTheme.values.firstWhere((e) => e.id == themeId, orElse: () => AppTheme.light);
    _fontSize = _prefs.getDouble('fontSize') ?? 18.0;
    // notifyListeners(); // Initial load, will notify later after bible data
  }

  Future<void> _saveSettings() async {
    await _prefs.setBool('pauseOnManualSwitch', _pauseOnManualSwitch);
    await _prefs.setBool('continuousReading', _continuousReading);
    await _prefs.setDouble('playbackRate', _playbackRate);
    await _prefs.setString('currentLanguageCode', _currentLanguageCode); // Save current language code
    await _prefs.setString('theme', _theme.id);
    await _prefs.setDouble('fontSize', _fontSize);
  }

  // --- TTS Methods ---
  void _initTts() {
    _flutterTts.setStartHandler(() {
      _isSpeaking = true;
      notifyListeners();
    });

    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
      if (_isAutoPlaying && _continuousReading) { // Only play next if continuous reading is enabled
        _playNextVerse();
      } else {
        _currentSpeakingId = null; // Only clear if not auto-playing to the next
      }
      notifyListeners();
    });

    _flutterTts.setErrorHandler((msg) {
      print("TTS Error: $msg");
      _isSpeaking = false;
      _isAutoPlaying = false;
      _currentSpeakingId = null;
      notifyListeners();
    });

    _flutterTts.setSpeechRate(_playbackRate); // Set initial playback rate
  }

  Future<void> speak(String text, String verseId) async {
    await _flutterTts.stop(); // Stop any current speech
    _currentSpeakingId = verseId;
    await _flutterTts.speak(text);
    notifyListeners();
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    _isSpeaking = false;
    _isAutoPlaying = false;
    _currentSpeakingId = null;
    notifyListeners();
  }

  void toggleChapterPlay() {
    if (_isAutoPlaying) {
      stop();
    } else {
      _isAutoPlaying = true;
      _playChapterFromStart();
    }
    notifyListeners();
  }

  void _playChapterFromStart() {
    final verses = selectedChapter;
    if (verses != null && verses.isNotEmpty) {
      final verseId = BibleVerse(bookId: selectedBook!.id, bookIndex: selectedBookIndex, chapterIndex: selectedChapterIndex, verseIndex: 0, text: verses[0]).id;
      speak(verses[0], verseId);
    } else {
      _isAutoPlaying = false; // Cannot autoplay empty chapter
    }
  }


  void _playNextVerse() {
    if (!_isAutoPlaying || selectedChapter == null || selectedBook == null) {
      stop(); // Stop if auto-play is off or no chapter selected
      return;
    }

    // Need to parse current speaking ID correctly to get verse index
    final currentVerseParts = _currentSpeakingId?.split(':');
    final currentVerseNumber = currentVerseParts != null && currentVerseParts.length == 2
        ? int.tryParse(currentVerseParts[1]) ?? 0
        : 0;
    
    // Check if there are more verses in the current chapter
    if (currentVerseNumber < selectedChapter!.length) {
      final nextVerseText = selectedChapter![currentVerseNumber];
      final nextVerseId = BibleVerse(bookId: selectedBook!.id, bookIndex: selectedBookIndex, chapterIndex: selectedChapterIndex, verseIndex: currentVerseNumber, text: nextVerseText).id;
      speak(nextVerseText, nextVerseId);
    } else {
      // Reached end of current chapter, try to move to next
      final currentBookNum = _selectedBookIndex;
      final currentChapNum = _selectedChapterIndex;

      if (currentChapNum < selectedBook!.chapters.length - 1) {
        _selectedChapterIndex++;
        // notifyListeners(); // Don't notify yet, speak will notify
        final nextChapFirstVerseText = selectedBook!.chapters[_selectedChapterIndex][0];
        final nextChapFirstVerseId = BibleVerse(bookId: selectedBook!.id, bookIndex: selectedBookIndex, chapterIndex: _selectedChapterIndex, verseIndex: 0, text: nextChapFirstVerseText).id;
        speak(nextChapFirstVerseText, nextChapFirstVerseId);
      } else if (currentBookNum < _bibleData.length - 1) {
        _selectedBookIndex++;
        _selectedChapterIndex = 0;
        // notifyListeners(); // Don't notify yet, speak will notify
        final nextBook = _bibleData[_selectedBookIndex];
        final nextBookFirstVerseText = nextBook.chapters[0][0];
        final nextBookFirstVerseId = BibleVerse(bookId: nextBook.id, bookIndex: _selectedBookIndex, chapterIndex: 0, verseIndex: 0, text: nextBookFirstVerseText).id;
        speak(nextBookFirstVerseText, nextBookFirstVerseId);
      } else {
        // End of the Bible
        stop();
      }
    }
  }

  // --- Data Methods ---
  void _generateDailyVerse() {
    if (_bibleData.isNotEmpty) {
      final bookIndex = Random().nextInt(_bibleData.length);
      final book = _bibleData[bookIndex];
      if (book.chapters.isNotEmpty) {
        final chapterIndex = Random().nextInt(book.chapters.length);
        final chapter = book.chapters[chapterIndex];
        if (chapter.isNotEmpty) {
          final verseIndex = Random().nextInt(chapter.length);
          _dailyVerse = BibleVerse(
            bookId: book.id,
            bookIndex: bookIndex,
            chapterIndex: chapterIndex,
            verseIndex: verseIndex,
            text: chapter[verseIndex],
          );
        }
      }
    }
  }

  Locale _getLocaleFromCode(String code) {
    if (code == 'zh-hant') {
      return const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');
    } else if (code == 'zh') {
      return const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');
    } else {
      return Locale(code);
    }
  }

  Future<void> loadBible(String languageCode) async {
    _isLoading = true;
    print('AppProvider: Loading Bible for language code: $languageCode');
    notifyListeners();

    await stop(); // Stop any playback

    try {
      final data = await _bibleService.loadBible(languageCode); // Pass languageCode
      _bibleData = data;
      _currentLanguageCode = languageCode; // Update language code after successful load
      _appLocale = _getLocaleFromCode(languageCode); // Update appLocale properly
      _selectedBookIndex = 0;
      _selectedChapterIndex = 0;
      _generateDailyVerse();
      print('AppProvider: Bible data loaded successfully for $languageCode. First book: ${_bibleData.first.name}');
    } catch (e) {
      print('AppProvider: Error loading Bible data: $e');
      _bibleData = [];
    } finally {
      _isLoading = false;
      _saveSettings(); // Save language preference
      notifyListeners(); // Notify again after data is fully loaded
      print('AppProvider: notifyListeners called after loadBible completion.');
    }
  }

  void changeLanguage(String newLanguageCode) {
    if (newLanguageCode != _currentLanguageCode) {
      loadBible(newLanguageCode); // Pass internal code
    }
  }

  void selectBook(int bookIndex) {
    if (bookIndex != _selectedBookIndex) {
      if (_pauseOnManualSwitch) stop();
      _selectedBookIndex = bookIndex;
      _selectedChapterIndex = 0;
      notifyListeners();
    }
  }

  void selectChapter(int chapterIndex) {
    if (chapterIndex != _selectedChapterIndex) {
      if (_pauseOnManualSwitch) stop();
      _selectedChapterIndex = chapterIndex;
      notifyListeners();
    }
  }

  void navigateTo(int bookIndex, int chapterIndex) {
    if (_pauseOnManualSwitch) stop();
    _selectedBookIndex = bookIndex;
    _selectedChapterIndex = chapterIndex;
    notifyListeners();
  }

  void nextChapter() {
    if (_pauseOnManualSwitch) stop();
    if (selectedBook != null && _selectedChapterIndex < selectedBook!.chapters.length - 1) {
      _selectedChapterIndex++;
    } else if (_selectedBookIndex < _bibleData.length - 1) {
      _selectedBookIndex++;
      _selectedChapterIndex = 0;
    }
    notifyListeners();
  }

  void previousChapter() {
    if (_pauseOnManualSwitch) stop();
    if (_selectedChapterIndex > 0) {
      _selectedChapterIndex--;
    } else if (_selectedBookIndex > 0) {
      _selectedBookIndex--;
      _selectedChapterIndex = selectedBook!.chapters.length - 1;
    }
    notifyListeners();
  }

  // --- Bookmark Methods ---
  void toggleBookmark(String verseId) {
    if (_bookmarks.contains(verseId)) {
      _bookmarks.remove(verseId);
    } else {
      _bookmarks.add(verseId);
    }
    _saveBookmarks();
    notifyListeners();
  }

  // --- Notes Methods ---
  void saveNote(String verseId, String noteText) {
    if (noteText.trim().isEmpty) {
      _notes.remove(verseId); // Remove if note is empty
    } else {
      _notes[verseId] = noteText;
    }
    _saveNotes();
    notifyListeners();
  }

  void deleteNote(String verseId) {
    _notes.remove(verseId);
    _saveNotes();
    notifyListeners();
  }

  // --- Highlights Methods ---
  void setHighlight(String verseId, String? color) {
    if (color == null || color.trim().isEmpty) {
      _highlights.remove(verseId);
    } else {
      _highlights[verseId] = color;
    }
    _saveHighlights();
    notifyListeners();
  }

  // --- Settings Methods ---
  set pauseOnManualSwitch(bool value) {
    if (_pauseOnManualSwitch != value) {
      _pauseOnManualSwitch = value;
      _saveSettings();
      notifyListeners();
    }
  }

  set continuousReading(bool value) {
    if (_continuousReading != value) {
      _continuousReading = value;
      _saveSettings();
      notifyListeners();
    }
  }

  set playbackRate(double value) {
    if (_playbackRate != value) {
      _playbackRate = value;
      _flutterTts.setSpeechRate(value);
      _saveSettings();
      notifyListeners();
    }
  }

  set theme(AppTheme newTheme) {
    if (_theme != newTheme) {
      _theme = newTheme;
      _saveSettings();
      notifyListeners();
    }
  }

  set fontSize(double value) {
    if (_fontSize != value) {
      _fontSize = value;
      _saveSettings();
      notifyListeners();
    }
  }

  // --- UI Navigation State ---
  set currentTabIndex(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  void goToReaderPage(int bookIndex, int chapterIndex, [int? verseIndex]) {
    navigateTo(bookIndex, chapterIndex); // Navigate to the verse
    _targetVerseIndex = verseIndex;
    currentTabIndex = 0; // Switch to the Reader tab
    notifyListeners();
  }

  void clearTargetVerse() {
    _targetVerseIndex = null;
  }

  // Helper to get localized book name
  String getLocalizedBookName(BuildContext context, String bookId) {
    final l10n = AppLocalizations.of(context)!;
    switch (bookId) {
      case 'gn': return l10n.bookGn;
      case 'ex': return l10n.bookEx;
      case 'lv': return l10n.bookLv;
      case 'nm': return l10n.bookNm;
      case 'dt': return l10n.bookDt;
      case 'js': return l10n.bookJs;
      case 'jud': return l10n.bookJud;
      case 'rt': return l10n.bookRt;
      case '1sm': return l10n.book1Sm;
      case '2sm': return l10n.book2Sm;
      case '1kgs': return l10n.book1kgs;
      case '2kgs': return l10n.book2kgs;
      case '1ch': return l10n.book1Ch;
      case '2ch': return l10n.book2Ch;
      case 'ezr': return l10n.bookEzr;
      case 'ne': return l10n.bookNe;
      case 'et': return l10n.bookEt;
      case 'job': return l10n.bookJob;
      case 'ps': return l10n.bookPs;
      case 'prv': return l10n.bookPrv;
      case 'ec': return l10n.bookEc;
      case 'so': return l10n.bookSo;
      case 'is': return l10n.bookIs;
      case 'jr': return l10n.bookJr;
      case 'lm': return l10n.bookLm;
      case 'ez': return l10n.bookEz;
      case 'dn': return l10n.bookDn;
      case 'ho': return l10n.bookHo;
      case 'jl': return l10n.bookJl;
      case 'am': return l10n.bookAm;
      case 'ob': return l10n.bookOb;
      case 'jn': return l10n.bookJn;
      case 'mi': return l10n.bookMi;
      case 'na': return l10n.bookNa;
      case 'hk': return l10n.bookHk;
      case 'zp': return l10n.bookZp;
      case 'hg': return l10n.bookHg;
      case 'zc': return l10n.bookZc;
      case 'ml': return l10n.bookMl;
      case 'mt': return l10n.bookMt;
      case 'mk': return l10n.bookMk;
      case 'lk': return l10n.bookLk;
      case 'jo': return l10n.bookJo;
      case 'act': return l10n.bookAct;
      case 'rm': return l10n.bookRm;
      case '1co': return l10n.book1Co;
      case '2co': return l10n.book2Co;
      case 'gl': return l10n.bookGl;
      case 'eph': return l10n.bookEph;
      case 'ph': return l10n.bookPh;
      case 'cl': return l10n.bookCl;
      case '1ts': return l10n.book1ts;
      case '2ts': return l10n.book2ts;
      case '1tm': return l10n.book1tm;
      case '2tm': return l10n.book2tm;
      case 'tt': return l10n.bookTt;
      case 'phm': return l10n.bookPhm;
      case 'hb': return l10n.bookHb;
      case 'jm': return l10n.bookJm;
      case '1pe': return l10n.book1Pe;
      case '2pe': return l10n.book2Pe;
      case '1jo': return l10n.book1Jn;
      case '2jo': return l10n.book2Jn;
      case '3jo': return l10n.book3Jn;
      case 'jd': return l10n.bookJd;
      case 're': return l10n.bookRe;
      default: return bookId;
    }
  }

  Future<void> shareVerse(String bookId, int chapterIndex, int verseIndex) async {
    final String verseUrl =
        'https://yourbibleapp.com/read?book=$bookId&chapter=${chapterIndex + 1}&verse=${verseIndex + 1}';
    await Share.share(verseUrl);
  }
}
