// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Holy Read';

  @override
  String get navRead => 'Read';

  @override
  String get navBookmarks => 'Bookmarks';

  @override
  String get navNotes => 'Notes';

  @override
  String get navSearch => 'Search';

  @override
  String get navSettings => 'Mine';

  @override
  String get settingsTitle => 'Preferences';

  @override
  String get settingsSubtitle => 'Configure your perfect reading environment';

  @override
  String get settingsUiLanguage => 'Localization';

  @override
  String get settingsVisualStyle => 'Visual Style';

  @override
  String get settingsReadingControls => 'Reading & Audio';

  @override
  String get settingsFontSize => 'Font Size';

  @override
  String get settingsReadingEffect => 'Reading Mode';

  @override
  String get settingsAnimationEffect => 'Page Animation';

  @override
  String get settingsCustomBg => 'Custom Background';

  @override
  String get settingsAccentColor => 'Accent Color';

  @override
  String get settingsSpeechRate => 'Speech Speed';

  @override
  String get settingsContinuousReading => 'Continuous Playback';

  @override
  String get settingsContinuousReadingDesc =>
      'Automatically advance to the next verse, ideal for focused meditation.';

  @override
  String get settingsPauseOnSwitch => 'Pause on Module Switch';

  @override
  String get settingsPauseOnSwitchDesc =>
      'Automatically pause playback when manually changing chapters.';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSepia => 'Sepia';

  @override
  String get settingsFontFamily => 'Font Family';

  @override
  String get settingsLineHeight => 'Line Spacing';

  @override
  String get settingsEffectsScroll => 'Vertical Scroll';

  @override
  String get settingsEffectsHorizontal => 'Horizontal Slide';

  @override
  String get settingsEffectsPageFlip => 'Full Screen';

  @override
  String get settingsEffectsPaginated => 'Book Mode';

  @override
  String get settingsAnimationsNone => 'None';

  @override
  String get settingsAnimationsFade => 'Fade';

  @override
  String get settingsAnimationsSlide => 'Slide';

  @override
  String get settingsAnimationsCurl => 'Curl';

  @override
  String get settingsFontsSerif => 'Serif (Classic)';

  @override
  String get settingsFontsSans => 'Sans (Modern)';

  @override
  String get settingsFontsKai => 'Kaiti (Elegant)';

  @override
  String get settingsFontsRounded => 'Rounded (Soft)';

  @override
  String get readerDailyWisdom => 'Daily Wisdom';

  @override
  String get readerAppTitle => 'Holy Read';

  @override
  String get readerMenu => 'Books';

  @override
  String readerChapterSelect(Object book, Object chapter) {
    return '$book • Ch. $chapter';
  }

  @override
  String get readerRangeSelect => 'Range Select';

  @override
  String get readerSelectStartEnd => 'Select start and end verses';

  @override
  String readerVerseSingle(Object verse) {
    return 'Verse $verse';
  }

  @override
  String readerVerseRange(Object start, Object end) {
    return 'Verses $start-$end';
  }

  @override
  String get readerBookmark => 'Bookmark';

  @override
  String get readerStop => 'Stop';

  @override
  String get readerListen => 'Listen';

  @override
  String get readerPlayChapter => 'Play Chapter';

  @override
  String get readerHighlight => 'Highlight';

  @override
  String get readerAddNote => 'Add a note...';

  @override
  String get readerReading => 'Reading...';

  @override
  String get readerPrevChapter => 'Previous';

  @override
  String get readerNextChapter => 'Next';

  @override
  String get readerFullscreenReader => 'Fullscreen Reader';

  @override
  String get readerExitFullscreen => 'Exit Fullscreen';

  @override
  String get readerNotePlaceholder => 'Write your spiritual reflection...';

  @override
  String get readerShare => 'Share Bible Verse';

  @override
  String get readerShareSuccess => 'Verse and link copied to clipboard!';

  @override
  String get readerDrawerBooks => 'Books';

  @override
  String get readerDrawerTitle => 'Books';

  @override
  String get readerNote => 'Note';

  @override
  String get commonSave => 'Save';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonClose => 'Close';

  @override
  String get commonExpand => 'Show Full';

  @override
  String get commonCollapse => 'Collapse';

  @override
  String get bookmarksTitle => 'Bookmarks';

  @override
  String bookmarksCount(Object count) {
    return 'You have $count saved verses';
  }

  @override
  String get bookmarksEmpty => 'No bookmarks yet.';

  @override
  String get bookmarksSearchPlaceholder => 'Search bookmarks...';

  @override
  String get bookmarksEdit => 'Edit';

  @override
  String bookmarksSelectedCount(Object count) {
    return '$count Selected';
  }

  @override
  String bookmarksBatchDelete(Object count) {
    return 'Delete Selected ($count)';
  }

  @override
  String get bookmarksSelectAll => 'Select All';

  @override
  String get bookmarksReverseSelect => 'Reverse Select';

  @override
  String bookmarksDeleteConfirm(Object count) {
    return 'Delete these $count bookmarks?';
  }

  @override
  String get bookmarksCancel => 'Cancel';

  @override
  String get bookmarksConfirm => 'Delete';

  @override
  String get notesTitle => 'Spiritual Notes';

  @override
  String notesCount(Object count) {
    return 'Reflecting on $count insights';
  }

  @override
  String get notesSearchPlaceholder => 'Search notes...';

  @override
  String get notesEmpty => 'No notes found.';

  @override
  String get notesEdit => 'Edit';

  @override
  String notesSelectedCount(Object count) {
    return '$count Selected';
  }

  @override
  String notesBatchDelete(Object count) {
    return 'Delete Selected ($count)';
  }

  @override
  String get notesSelectAll => 'Select All';

  @override
  String get notesReverseSelect => 'Reverse Select';

  @override
  String notesDeleteConfirm(Object count) {
    return 'Delete these $count notes?';
  }

  @override
  String get notesCancel => 'Cancel';

  @override
  String get notesConfirm => 'Delete';

  @override
  String get globalSearchTitle => 'Global Search';

  @override
  String get globalSearchSubtitle => 'Search for Truth and Wisdom in the Bible';

  @override
  String get globalSearchPlaceholder =>
      'Enter keywords to search verse content...';

  @override
  String globalSearchCount(Object count) {
    return 'Found $count verses';
  }

  @override
  String get globalSearchEmpty => 'No verses found. Try different keywords.';

  @override
  String get globalSearchSearching => 'Searching the scriptures...';

  @override
  String globalSearchResultFormat(Object book, Object chapter, Object verse) {
    return '$book $chapter:$verse';
  }

  @override
  String get authLoginTitle => 'Welcome Back';

  @override
  String get authRegisterTitle => 'Create Account';

  @override
  String get authLoginDesc => 'Sign in to sync your data across devices';

  @override
  String get authRegisterDesc => 'Start your spiritual journey with cloud sync';

  @override
  String get authUsernamePlaceholder => 'Username';

  @override
  String get authPasswordPlaceholder => 'Password';

  @override
  String get authLoginBtn => 'Sign In';

  @override
  String get authRegisterBtn => 'Create Account';

  @override
  String get authNoAccount => 'Don\'t have an account?';

  @override
  String get authHasAccount => 'Already have an account?';

  @override
  String get authSwitchRegister => 'Sign Up';

  @override
  String get authSwitchLogin => 'Login';

  @override
  String get authLoggedIn => 'Account synced';

  @override
  String get authLogout => 'Log Out';

  @override
  String get authGuestUser => 'Guest User';

  @override
  String get authSyncActive => 'Cloud sync active';

  @override
  String get authSyncPrompt => 'Sign in to sync your data';

  @override
  String get simplifiedChinese => 'Simplified Chinese';

  @override
  String get traditionalChinese => 'Traditional Chinese';

  @override
  String get english => 'English';

  @override
  String get bookGn => 'Genesis';

  @override
  String get bookEx => 'Exodus';

  @override
  String get bookLv => 'Leviticus';

  @override
  String get bookNm => 'Numbers';

  @override
  String get bookDt => 'Deuteronomy';

  @override
  String get bookJs => 'Joshua';

  @override
  String get bookJud => 'Judges';

  @override
  String get bookRt => 'Ruth';

  @override
  String get book1Sm => '1 Samuel';

  @override
  String get book2Sm => '2 Samuel';

  @override
  String get book1kgs => '1 Kings';

  @override
  String get book2kgs => '2 Kings';

  @override
  String get book1Ch => '1 Chronicles';

  @override
  String get book2Ch => '2 Chronicles';

  @override
  String get bookEzr => 'Ezra';

  @override
  String get bookNe => 'Nehemiah';

  @override
  String get bookEt => 'Esther';

  @override
  String get bookJob => 'Job';

  @override
  String get bookPs => 'Psalms';

  @override
  String get bookPrv => 'Proverbs';

  @override
  String get bookEc => 'Ecclesiastes';

  @override
  String get bookSo => 'Song of Solomon';

  @override
  String get bookIs => 'Isaiah';

  @override
  String get bookJr => 'Jeremiah';

  @override
  String get bookLm => 'Lamentations';

  @override
  String get bookEz => 'Ezekiel';

  @override
  String get bookDn => 'Daniel';

  @override
  String get bookHo => 'Hosea';

  @override
  String get bookJl => 'Joel';

  @override
  String get bookAm => 'Amos';

  @override
  String get bookOb => 'Obadiah';

  @override
  String get bookJn => 'Jonah';

  @override
  String get bookMi => 'Micah';

  @override
  String get bookNa => 'Naum';

  @override
  String get bookHk => 'Habakkuk';

  @override
  String get bookZp => 'Zephaniah';

  @override
  String get bookHg => 'Haggai';

  @override
  String get bookZc => 'Zechariah';

  @override
  String get bookMl => 'Malachi';

  @override
  String get bookMt => 'Matthew';

  @override
  String get bookMk => 'Mark';

  @override
  String get bookLk => 'Luke';

  @override
  String get bookJo => 'John';

  @override
  String get bookAct => 'Acts';

  @override
  String get bookRm => 'Romans';

  @override
  String get book1Co => '1 Corinthians';

  @override
  String get book2Co => '2 Corinthians';

  @override
  String get bookGl => 'Galatians';

  @override
  String get bookEph => 'Ephesians';

  @override
  String get bookPh => 'Philippians';

  @override
  String get bookCl => 'Colossians';

  @override
  String get book1ts => '1 Thessalonians';

  @override
  String get book2ts => '2 Thessalonians';

  @override
  String get book1tm => '1 Timothy';

  @override
  String get book2tm => '2 Timothy';

  @override
  String get bookTt => 'Titus';

  @override
  String get bookPhm => 'Philemon';

  @override
  String get bookHb => 'Hebrews';

  @override
  String get bookJm => 'James';

  @override
  String get book1Pe => '1 Peter';

  @override
  String get book2Pe => '2 Peter';

  @override
  String get book1Jn => '1 John';

  @override
  String get book2Jn => '2 John';

  @override
  String get book3Jn => '3 John';

  @override
  String get bookJd => 'Jude';

  @override
  String get bookRe => 'Revelation';
}
