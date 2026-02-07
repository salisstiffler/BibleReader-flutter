import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import '../l10n/app_localizations.dart';
import '../models/bible_data.dart';
import '../models/bible_verse.dart';
import '../models/bookmark.dart';
import '../models/highlight.dart';
import '../models/note.dart';
import '../models/user.dart';
import '../models/verse_range.dart';
import '../services/bible_service.dart';
import '../theme.dart';

class AppProvider with ChangeNotifier {
  final BibleService _bibleService = BibleService();
  final FlutterTts _flutterTts = FlutterTts();
  late SharedPreferences _prefs;
  final Uuid _uuid = const Uuid();
  static const String API_URL = 'https://api.berlin2025.dpdns.org/api';

  // Data state
  bool _isLoading = true;
  String _currentLanguageCode = 'zh-Hans';
  Locale? _appLocale;
  List<BibleBook> _bibleData = [];
  BibleVerse? _dailyVerse;

  // Navigation state
  int _selectedBookIndex = 0;
  int _selectedChapterIndex = 0;
  int? _targetVerseIndex;
  Map<String, dynamic> _lastRead = {
    'bookIndex': 0,
    'chapterIndex': 0,
    'verseNum': 0
  };

  // TTS State
  bool _isSpeaking = false;
  bool _isAutoPlaying = false;
  String? _currentSpeakingId;

  // Bookmarks, Notes, Highlights State
  List<Bookmark> _bookmarks = [];
  List<Note> _notes = [];
  List<Highlight> _highlights = [];

  // Settings State
  AppTheme _theme = AppTheme.light;
  double _fontSize = 18.0;
  bool _pauseOnManualSwitch = true;
  bool _continuousReading = false;
  double _playbackRate = 1.0;
  double _lineHeight = 1.6;
  String _fontFamily = 'default'; // 'default', 'shoushu', 'songkai', 'bai ge', 'heiti'
  String _accentColor = '#6366f1'; // Default indigo color
  String _pageTurnEffect = 'curl'; // 'none', 'fade', 'slide', 'curl'
  int _loopCount = 1;
  bool _isFullscreenReader = false;
  bool _showDrawer = false;

  // Auth State
  User? _user;
  String? _token;

  // UI State
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
  List<Bookmark> get bookmarks => List.unmodifiable(_bookmarks);
  List<Note> get notes => List.unmodifiable(_notes);
  List<Highlight> get highlights => List.unmodifiable(_highlights);
  AppTheme get theme => _theme;
  double get fontSize => _fontSize;
  bool get pauseOnManualSwitch => _pauseOnManualSwitch;
  bool get continuousReading => _continuousReading;
  double get playbackRate => _playbackRate;
  double get lineHeight => _lineHeight;
  String get fontFamily => _fontFamily;
  String get accentColor => _accentColor;
  String get pageTurnEffect => _pageTurnEffect;
  int get loopCount => _loopCount;
  bool get isFullscreenReader => _isFullscreenReader;
  bool get showDrawer => _showDrawer;
  User? get user => _user;
  String? get token => _token;
  int get currentTabIndex => _currentTabIndex;

  BibleBook? get selectedBook =>
      _bibleData.isNotEmpty ? _bibleData[_selectedBookIndex] : null;
  List<String>? get selectedChapter =>
      selectedBook != null &&
              _selectedChapterIndex < selectedBook!.chapters.length
          ? selectedBook!.chapters[_selectedChapterIndex]
          : null;

  AppProvider() {
    // Initialization is now handled by `initializeApp`
  }

  Future<void> initializeApp(Uri? initialUri) async {
    await _initPrefs();
    _initTts();
    if (_token != null) {
      await mergeAndSyncData(_token!);
    } else {
      await loadBible(_currentLanguageCode);
    }
    if (initialUri != null) {
      _handleDeepLink(initialUri);
    }
    _generateDailyVerse();
    notifyListeners();
  }

  void _handleDeepLink(Uri uri) {
    if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'read') {
      final params = uri.queryParameters;
      final bookId = params['book'];
      final chapter = int.tryParse(params['chapter'] ?? '');
      final verse = int.tryParse(params['verse'] ?? '');

      if (bookId != null && chapter != null && verse != null) {
        final bookIndex = _bibleData.indexWhere((book) => book.id == bookId);
        if (bookIndex != -1) {
          navigateTo(bookIndex, chapter - 1);
          _targetVerseIndex = verse - 1;
          currentTabIndex = 0;
        }
      }
    }
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadSettings();
    _loadUserData();
    _token = _prefs.getString('token');
    final userJson = _prefs.getString('user');
    if (userJson != null) {
      _user = User.fromJson(json.decode(userJson));
    }
  }

  void _loadUserData() {
    _loadBookmarks();
    _loadNotes();
    _loadHighlights();
  }

  void _loadBookmarks() {
    final String? jsonString = _prefs.getString('bookmarks');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      _bookmarks = jsonList.map((json) => Bookmark.fromJson(json)).toList();
    }
  }

  Future<void> _saveBookmarks() async {
    final String jsonString = json.encode(
      _bookmarks.map((b) => b.toJson()).toList(),
    );
    await _prefs.setString('bookmarks', jsonString);
  }

  void _loadNotes() {
    final String? jsonString = _prefs.getString('notes');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      _notes = jsonList.map((json) => Note.fromJson(json)).toList();
    }
  }

  Future<void> _saveNotes() async {
    final String jsonString = json.encode(
      _notes.map((n) => n.toJson()).toList(),
    );
    await _prefs.setString('notes', jsonString);
  }

  void _loadHighlights() {
    final String? jsonString = _prefs.getString('highlights');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      _highlights = jsonList.map((json) => Highlight.fromJson(json)).toList();
    }
  }

  Future<void> _saveHighlights() async {
    final String jsonString = json.encode(
      _highlights.map((h) => h.toJson()).toList(),
    );
    await _prefs.setString('highlights', jsonString);
  }

  void _loadSettings() {
    _currentLanguageCode =
        _prefs.getString('language') ?? 'zh-Hans';
    _appLocale = _getLocaleFromCode(_currentLanguageCode);
    final themeId = _prefs.getString('theme') ?? AppTheme.light.id;
    _theme = AppTheme.values.firstWhere(
      (e) => e.id == themeId,
      orElse: () => AppTheme.light,
    );
    _fontSize = _prefs.getDouble('fontSize') ?? 18.0;
    _lineHeight = _prefs.getDouble('lineHeight') ?? 1.6;
    _fontFamily = _prefs.getString('fontFamily') ?? 'sans';
    _accentColor = _prefs.getString('accentColor') ?? '#6366f1';
    _pageTurnEffect = _prefs.getString('pageTurnEffect') ?? 'curl';
    _pauseOnManualSwitch = _prefs.getBool('pauseOnManualSwitch') ?? true;
    _continuousReading = _prefs.getBool('continuousReading') ?? false;
    _playbackRate = _prefs.getDouble('playbackRate') ?? 1.0;
    _loopCount = _prefs.getInt('loopCount') ?? 1;
    final lastReadJson = _prefs.getString('lastRead');
    if (lastReadJson != null) {
      _lastRead = json.decode(lastReadJson);
      _selectedBookIndex = _lastRead['bookIndex'];
      _selectedChapterIndex = _lastRead['chapterIndex'];
    }
  }

  Future<void> _saveSettings() async {
    await _prefs.setString('language', _currentLanguageCode);
    await _prefs.setString('theme', _theme.id);
    await _prefs.setDouble('fontSize', _fontSize);
    await _prefs.setDouble('lineHeight', _lineHeight);
    await _prefs.setString('fontFamily', _fontFamily);
    await _prefs.setString('accentColor', _accentColor);
    await _prefs.setString('pageTurnEffect', _pageTurnEffect);
    await _prefs.setBool('pauseOnManualSwitch', _pauseOnManualSwitch);
    await _prefs.setBool('continuousReading', _continuousReading);
    await _prefs.setDouble('playbackRate', _playbackRate);
    await _prefs.setInt('loopCount', _loopCount);
    await _prefs.setString('lastRead', json.encode(_lastRead));
  }

  void _initTts() {
    _flutterTts.setStartHandler(() {
      _isSpeaking = true;
      notifyListeners();
    });

    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
      if (_isAutoPlaying && _continuousReading) {
        _playNextVerse();
      } else {
        _currentSpeakingId = null;
      }
      notifyListeners();
    });

    _flutterTts.setErrorHandler((msg) {
      _isSpeaking = false;
      _isAutoPlaying = false;
      _currentSpeakingId = null;
      notifyListeners();
    });

    _flutterTts.setSpeechRate(_playbackRate);
    // TODO: Set language-specific voice
  }

  Future<void> speak(String text, String id, {bool isRestarting = false}) async {
    if (!isRestarting && _isSpeaking && _currentSpeakingId == id) {
      await stop();
      return;
    }
    _currentSpeakingId = id;
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
      final verseRange = VerseRange(
        bookId: selectedBook!.id,
        chapter: selectedChapterIndex,
        startVerse: 1, // Changed from 0 to 1 (1-based)
        endVerse: 1,   // Changed from 0 to 1 (1-based)
      );
      speak(verses[0], verseRange.id);
    } else {
      _isAutoPlaying = false; // Cannot autoplay empty chapter
    }
  }

  void _playNextVerse() {
    if (!_isAutoPlaying || selectedChapter == null || selectedBook == null) {
      stop(); // Stop if auto-play is off or no chapter selected
      return;
    }

    // currentVerseNumber is 1-based from VerseRange.id
    // To get 0-based index for array access, subtract 1.
    final currentVerse1Based = int.tryParse(_currentSpeakingId?.split(':').last.split('-').first ?? '0') ?? 0;
    final currentVerse0Based = currentVerse1Based - 1;

    // Check if there are more verses in the current chapter
    if (currentVerse0Based < selectedChapter!.length - 1) { // Check if not the last verse
      final nextVerse0Based = currentVerse0Based + 1;
      final nextVerseText = selectedChapter![nextVerse0Based];
      final nextVerseRange = VerseRange(
        bookId: selectedBook!.id,
        chapter: selectedChapterIndex,
        startVerse: nextVerse0Based + 1, // Convert back to 1-based for VerseRange
        endVerse: nextVerse0Based + 1,   // Convert back to 1-based for VerseRange
      );
      speak(nextVerseText, nextVerseRange.id);
    } else {
      // Reached end of current chapter, try to move to next
      final currentBookNum = _selectedBookIndex;
      final currentChapNum = _selectedChapterIndex;

      if (currentChapNum < selectedBook!.chapters.length - 1) {
        _selectedChapterIndex++;
        final nextChapFirstVerseText = selectedBook!.chapters[_selectedChapterIndex][0];
        final nextChapFirstVerseRange = VerseRange(
          bookId: selectedBook!.id,
          chapter: _selectedChapterIndex,
          startVerse: 1, // First verse of next chapter is always 1
          endVerse: 1,
        );
        speak(nextChapFirstVerseText, nextChapFirstVerseRange.id);
      } else if (currentBookNum < _bibleData.length - 1) {
        _selectedBookIndex++;
        _selectedChapterIndex = 0;
        final nextBook = _bibleData[_selectedBookIndex];
        final nextBookFirstVerseText = nextBook.chapters[0][0];
        final nextBookFirstVerseRange = VerseRange(
          bookId: nextBook.id,
          chapter: 0,
          startVerse: 1, // First verse of next book/chapter is always 1
          endVerse: 1,
        );
        speak(nextBookFirstVerseText, nextBookFirstVerseRange.id);
      } else {
        // End of the Bible
        stop();
      }
    }
  }

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

  Future<void> loadBible(String languageCode) async {
    _isLoading = true;
    notifyListeners();

    await stop();

    try {
      final data = await _bibleService.loadBible(languageCode);
      _bibleData = data;
      _currentLanguageCode = languageCode;
      _appLocale = _getLocaleFromCode(languageCode);
      _selectedBookIndex = _lastRead['bookIndex'] ?? 0;
      _selectedChapterIndex = _lastRead['chapterIndex'] ?? 0;
      _generateDailyVerse();
    } catch (e) {
      _bibleData = [];
    } finally {
      _isLoading = false;
      _saveSettings();
      notifyListeners();
    }
  }

  void navigateTo(int bookIndex, int chapterIndex, [int? verseNum]) {
    if (_pauseOnManualSwitch) stop();
    _selectedBookIndex = bookIndex;
    _selectedChapterIndex = chapterIndex;
    setLastRead(bookIndex, chapterIndex, verseNum);
    notifyListeners();
  }

  void nextChapter() {
    if (_pauseOnManualSwitch) stop();
    if (selectedBook != null &&
        _selectedChapterIndex < selectedBook!.chapters.length - 1) {
      _selectedChapterIndex++;
    } else if (_selectedBookIndex < _bibleData.length - 1) {
      _selectedBookIndex++;
      _selectedChapterIndex = 0;
    }
    setLastRead(_selectedBookIndex, _selectedChapterIndex);
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
    setLastRead(_selectedBookIndex, _selectedChapterIndex);
    notifyListeners();
  }

  void setLastRead(int bookIndex, int chapterIndex, [int? verseNum]) {
    _lastRead = {
      'bookIndex': bookIndex,
      'chapterIndex': chapterIndex,
      'verseNum': verseNum
    };
    _saveSettings();
  }

  // --- Range-based action methods ---
  void toggleBookmark(VerseRange range) {
    final index = _bookmarks.indexWhere((b) => b.id == range.id);
    if (index != -1) {
      _bookmarks.removeAt(index);
      if (_token != null) _apiRemoveBookmark(range.id);
    } else {
      final newBookmark = Bookmark.fromRange(range);
      _bookmarks.add(newBookmark);
      if (_token != null) _apiAddBookmark(newBookmark);
    }
    _saveBookmarks();
    notifyListeners();
  }

  Bookmark? isBookmarked(String bookId, int chapter, int verse) {
    try {
      return _bookmarks.firstWhere((b) =>
          b.bookId == bookId &&
          b.chapter == chapter &&
          verse >= b.startVerse &&
          verse <= b.endVerse);
    } catch (e) {
      return null;
    }
  }

  void setHighlight(VerseRange range, String? color) {
    final index = _highlights.indexWhere((h) => h.id == range.id);
    if (index != -1) {
      _highlights.removeAt(index);
    }
    if (color != null) {
      final newHighlight = Highlight.fromRange(range, color);
      _highlights.add(newHighlight);
      if (_token != null) _apiSetHighlight(newHighlight);
    } else {
      if (_token != null) _apiRemoveHighlight(range.id);
    }
    _saveHighlights();
    notifyListeners();
  }

  String? getHighlight(String bookId, int chapter, int verse) {
    try {
      return _highlights
          .firstWhere((h) =>
              h.bookId == bookId &&
              h.chapter == chapter &&
              verse >= h.startVerse &&
              verse <= h.endVerse)
          .color;
    } catch (e) {
      return null;
    }
  }

  void saveNote(VerseRange range, String text) {
    final index = _notes.indexWhere((n) => n.id == range.id);
    if (index != -1) {
      _notes.removeAt(index);
    }
    if (text.trim().isNotEmpty) {
      final newNote = Note.fromRange(range, text);
      _notes.add(newNote);
      if (_token != null) _apiSaveNote(newNote);
    } else {
      if (_token != null) _apiRemoveNote(range.id);
    }
    _saveNotes();
    notifyListeners();
  }

  Note? getNote(String bookId, int chapter, int verse) {
    try {
      return _notes.firstWhere((n) =>
          n.bookId == bookId &&
          n.chapter == chapter &&
          verse >= n.startVerse &&
          verse <= n.endVerse);
    } catch (e) {
      return null;
    }
  }

  void deleteNote(String noteId) {
    _notes.removeWhere((note) => note.id == noteId);
    _saveNotes();
    if (_token != null) _apiRemoveNote(noteId);
    notifyListeners();
  }

  // Settings setters
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

  set lineHeight(double value) {
    if (_lineHeight != value) {
      _lineHeight = value;
      _saveSettings();
      notifyListeners();
    }
  }

  set fontFamily(String value) {
    if (_fontFamily != value) {
      _fontFamily = value;
      _saveSettings();
      notifyListeners();
    }
  }

  set accentColor(String value) {
    if (_accentColor != value) {
      _accentColor = value;
      _saveSettings();
      notifyListeners();
    }
  }

  set pageTurnEffect(String value) {
    if (_pageTurnEffect != value) {
      _pageTurnEffect = value;
      _saveSettings();
      notifyListeners();
    }
  }

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

  set loopCount(int value) {
    if (_loopCount != value) {
      _loopCount = value;
      _saveSettings();
      notifyListeners();
    }
  }

  set isFullscreenReader(bool value) {
    if (_isFullscreenReader != value) {
      _isFullscreenReader = value;
      notifyListeners();
    }
  }

  set showDrawer(bool value) {
    if (_showDrawer != value) {
      _showDrawer = value;
      notifyListeners();
    }
  }

  // UI Navigation State
  set currentTabIndex(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  void goToReaderPage(int bookIndex, int chapterIndex, [int? verseIndex]) {
    navigateTo(bookIndex, chapterIndex, verseIndex);
    _targetVerseIndex = verseIndex;
    currentTabIndex = 0;
    notifyListeners();
  }

  void clearTargetVerse() {
    _targetVerseIndex = null;
  }

  void setTargetVerseIndex(int verseIndex) {
    _targetVerseIndex = verseIndex;
    notifyListeners();
  }

  Locale _getLocaleFromCode(String code) {
    if (code == 'zh-Hant') {
      return const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');
    } else if (code == 'zh-Hans') {
      return const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');
    } else {
      return Locale(code);
    }
  }

  // --- Auth and Sync ---
  Future<void> register(String username, String password) async {
    final res = await http.post(
      Uri.parse('$API_URL/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );
    final data = json.decode(res.body);
    if (data['error'] != null) throw Exception(data['error']);
    _token = data['token'];
    _user = User.fromJson(data['user']);
    await _prefs.setString('token', _token!);
    await _prefs.setString('user', json.encode(_user!.toJson()));
    await mergeAndSyncData(_token!);
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    final res = await http.post(
      Uri.parse('$API_URL/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );
    final data = json.decode(res.body);
    if (data['error'] != null) throw Exception(data['error']);
    _token = data['token'];
    _user = User.fromJson(data['user']);
    await _prefs.setString('token', _token!);
    await _prefs.setString('user', json.encode(_user!.toJson()));
    await mergeAndSyncData(_token!);
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    _bookmarks = [];
    _highlights = [];
    _notes = [];
    setLastRead(0, 0, 0);
    await _prefs.remove('token');
    await _prefs.remove('user');
    await _prefs.remove('bookmarks');
    await _prefs.remove('highlights');
    await _prefs.remove('notes');
    await _prefs.remove('lastRead');
    notifyListeners();
  }

  Future<void> mergeAndSyncData(String tk) async {
    try {
      final res = await http.get(
        Uri.parse('$API_URL/user/profile'),
        headers: {'Authorization': 'Bearer $tk'},
      );
      final data = json.decode(res.body);

      // Apply server settings
      if (data['settings'] != null) {
        final settings = data['settings'];
        theme = AppTheme.values.firstWhere((e) => e.id == settings['theme'],
            orElse: () => AppTheme.light);
        changeLanguage(settings['language']);
        fontSize = settings['font_size']?.toDouble();
      }

      // Apply server progress
      if (data['progress'] != null) {
        setLastRead(data['progress']['book_index'],
            data['progress']['chapter_index'], data['progress']['verse_num']);
      }

      // Merge bookmarks
      final serverBookmarks = (data['bookmarks'] as List?)
              ?.map((b) => Bookmark.fromJson(b))
              .toList() ??
          [];
      final serverBookmarkIds = serverBookmarks.map((b) => b.id).toSet();
      _bookmarks.forEach((localBookmark) {
        if (!serverBookmarkIds.contains(localBookmark.id)) {
          serverBookmarks.add(localBookmark);
        }
      });
      _bookmarks = serverBookmarks;

      // Merge highlights
      final serverHighlights = (data['highlights'] as List?)
              ?.map((h) => Highlight.fromJson(h))
              .toList() ??
          [];
      final serverHighlightIds = serverHighlights.map((h) => h.id).toSet();
      _highlights.forEach((localHighlight) {
        if (!serverHighlightIds.contains(localHighlight.id)) {
          serverHighlights.add(localHighlight);
        }
      });
      _highlights = serverHighlights;

      // Merge notes
      final serverNotes =
          (data['notes'] as List?)?.map((n) => Note.fromJson(n)).toList() ?? [];
      final serverNoteIds = serverNotes.map((n) => n.id).toSet();
      _notes.forEach((localNote) {
        if (!serverNoteIds.contains(localNote.id)) {
          serverNotes.add(localNote);
        }
      });
      _notes = serverNotes;

      await syncData();
    } catch (e) {
      if (e.toString().contains('Unauthorized')) {
        logout();
      }
    }
  }

  Future<void> syncData() async {
    if (_token == null) return;
    try {
      await http.post(
        Uri.parse('$API_URL/user/sync'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token'
        },
        body: json.encode({
          'settings': {
            'theme': _theme.id,
            'language': _currentLanguageCode,
            'fontSize': _fontSize,
            'lineHeight': _lineHeight,
            'fontFamily': _fontFamily,
            'accentColor': _accentColor,
            'pageTurnEffect': _pageTurnEffect,
            'continuousReading': _continuousReading,
            'playbackRate': _playbackRate,
            'pauseOnManualSwitch': _pauseOnManualSwitch,
            'loopCount': _loopCount
          },
          'progress': _lastRead,
          'bookmarks': _bookmarks.map((b) => b.toJson()).toList(),
          'highlights': _highlights.map((h) => h.toJson()).toList(),
          'notes': _notes.map((n) => n.toJson()).toList(),
        }),
      );
    } catch (e) {
      // handle error
    }
  }

  Future<void> _apiAddBookmark(Bookmark bookmark) async {
    if (_token == null) return;
    await http.post(Uri.parse('$API_URL/user/bookmark/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token'
        },
        body: json.encode(bookmark.toJson()));
  }

  Future<void> _apiRemoveBookmark(String id) async {
    if (_token == null) return;
    await http.post(Uri.parse('$API_URL/user/bookmark/remove'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token'
        },
        body: json.encode({'id': id}));
  }

  Future<void> _apiSetHighlight(Highlight highlight) async {
    if (_token == null) return;
    await http.post(Uri.parse('$API_URL/user/highlight/set'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token'
        },
        body: json.encode(highlight.toJson()));
  }

  Future<void> _apiRemoveHighlight(String id) async {
    if (_token == null) return;
    await http.post(Uri.parse('$API_URL/user/highlight/remove'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token'
        },
        body: json.encode({'id': id}));
  }

  Future<void> _apiSaveNote(Note note) async {
    if (_token == null) return;
    await http.post(Uri.parse('$API_URL/user/note/save'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token'
        },
        body: json.encode(note.toJson()));
  }

  Future<void> _apiRemoveNote(String id) async {
    if (_token == null) return;
    await http.post(Uri.parse('$API_URL/user/note/remove'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token'
        },
        body: json.encode({'id': id}));
  }

  void changeLanguage(String newLanguageCode) {
    if (newLanguageCode != _currentLanguageCode) {
      loadBible(newLanguageCode);
    }
  }

  Future<void> shareVerse(
    String bookId,
    int chapterIndex,
    int verseIndex,
  ) async {
    final String verseUrl =
        'https://yourbibleapp.com/read?book=$bookId&chapter=${chapterIndex + 1}&verse=${verseIndex + 1}';
    await Share.share(verseUrl);
  }
}