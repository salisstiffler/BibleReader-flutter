import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Holy Read'**
  String get appTitle;

  /// No description provided for @navRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get navRead;

  /// No description provided for @navBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get navBookmarks;

  /// No description provided for @navNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get navNotes;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Mine'**
  String get navSettings;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure your perfect reading environment'**
  String get settingsSubtitle;

  /// No description provided for @settingsUiLanguage.
  ///
  /// In en, this message translates to:
  /// **'Localization'**
  String get settingsUiLanguage;

  /// No description provided for @settingsVisualStyle.
  ///
  /// In en, this message translates to:
  /// **'Visual Style'**
  String get settingsVisualStyle;

  /// No description provided for @settingsReadingControls.
  ///
  /// In en, this message translates to:
  /// **'Reading & Audio'**
  String get settingsReadingControls;

  /// No description provided for @settingsFontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get settingsFontSize;

  /// No description provided for @settingsReadingEffect.
  ///
  /// In en, this message translates to:
  /// **'Reading Mode'**
  String get settingsReadingEffect;

  /// No description provided for @settingsAnimationEffect.
  ///
  /// In en, this message translates to:
  /// **'Page Animation'**
  String get settingsAnimationEffect;

  /// No description provided for @settingsCustomBg.
  ///
  /// In en, this message translates to:
  /// **'Custom Background'**
  String get settingsCustomBg;

  /// No description provided for @settingsAccentColor.
  ///
  /// In en, this message translates to:
  /// **'Accent Color'**
  String get settingsAccentColor;

  /// No description provided for @settingsSpeechRate.
  ///
  /// In en, this message translates to:
  /// **'Speech Speed'**
  String get settingsSpeechRate;

  /// No description provided for @settingsContinuousReading.
  ///
  /// In en, this message translates to:
  /// **'Continuous Playback'**
  String get settingsContinuousReading;

  /// No description provided for @settingsContinuousReadingDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically advance to the next verse, ideal for focused meditation.'**
  String get settingsContinuousReadingDesc;

  /// No description provided for @settingsPauseOnSwitch.
  ///
  /// In en, this message translates to:
  /// **'Pause on Module Switch'**
  String get settingsPauseOnSwitch;

  /// No description provided for @settingsPauseOnSwitchDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically pause playback when manually changing chapters.'**
  String get settingsPauseOnSwitchDesc;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSepia.
  ///
  /// In en, this message translates to:
  /// **'Sepia'**
  String get settingsThemeSepia;

  /// No description provided for @settingsFontFamily.
  ///
  /// In en, this message translates to:
  /// **'Font Family'**
  String get settingsFontFamily;

  /// No description provided for @settingsLineHeight.
  ///
  /// In en, this message translates to:
  /// **'Line Spacing'**
  String get settingsLineHeight;

  /// No description provided for @settingsEffectsScroll.
  ///
  /// In en, this message translates to:
  /// **'Vertical Scroll'**
  String get settingsEffectsScroll;

  /// No description provided for @settingsEffectsHorizontal.
  ///
  /// In en, this message translates to:
  /// **'Horizontal Slide'**
  String get settingsEffectsHorizontal;

  /// No description provided for @settingsEffectsPageFlip.
  ///
  /// In en, this message translates to:
  /// **'Full Screen'**
  String get settingsEffectsPageFlip;

  /// No description provided for @settingsEffectsPaginated.
  ///
  /// In en, this message translates to:
  /// **'Book Mode'**
  String get settingsEffectsPaginated;

  /// No description provided for @settingsAnimationsNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get settingsAnimationsNone;

  /// No description provided for @settingsAnimationsFade.
  ///
  /// In en, this message translates to:
  /// **'Fade'**
  String get settingsAnimationsFade;

  /// No description provided for @settingsAnimationsSlide.
  ///
  /// In en, this message translates to:
  /// **'Slide'**
  String get settingsAnimationsSlide;

  /// No description provided for @settingsAnimationsCurl.
  ///
  /// In en, this message translates to:
  /// **'Curl'**
  String get settingsAnimationsCurl;

  /// No description provided for @settingsFontsSerif.
  ///
  /// In en, this message translates to:
  /// **'Serif (Classic)'**
  String get settingsFontsSerif;

  /// No description provided for @settingsFontsSans.
  ///
  /// In en, this message translates to:
  /// **'Sans (Modern)'**
  String get settingsFontsSans;

  /// No description provided for @settingsFontsKai.
  ///
  /// In en, this message translates to:
  /// **'Kaiti (Elegant)'**
  String get settingsFontsKai;

  /// No description provided for @settingsFontsRounded.
  ///
  /// In en, this message translates to:
  /// **'Rounded (Soft)'**
  String get settingsFontsRounded;

  /// No description provided for @readerDailyWisdom.
  ///
  /// In en, this message translates to:
  /// **'Daily Wisdom'**
  String get readerDailyWisdom;

  /// No description provided for @readerAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Holy Read'**
  String get readerAppTitle;

  /// No description provided for @readerMenu.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get readerMenu;

  /// No description provided for @readerChapterSelect.
  ///
  /// In en, this message translates to:
  /// **'{book} • Ch. {chapter}'**
  String readerChapterSelect(Object book, Object chapter);

  /// No description provided for @readerRangeSelect.
  ///
  /// In en, this message translates to:
  /// **'Range Select'**
  String get readerRangeSelect;

  /// No description provided for @readerSelectStartEnd.
  ///
  /// In en, this message translates to:
  /// **'Select start and end verses'**
  String get readerSelectStartEnd;

  /// No description provided for @readerVerseSingle.
  ///
  /// In en, this message translates to:
  /// **'Verse {verse}'**
  String readerVerseSingle(Object verse);

  /// No description provided for @readerVerseRange.
  ///
  /// In en, this message translates to:
  /// **'Verses {start}-{end}'**
  String readerVerseRange(Object start, Object end);

  /// No description provided for @readerBookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get readerBookmark;

  /// No description provided for @readerStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get readerStop;

  /// No description provided for @readerListen.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get readerListen;

  /// No description provided for @readerPlayChapter.
  ///
  /// In en, this message translates to:
  /// **'Play Chapter'**
  String get readerPlayChapter;

  /// No description provided for @readerHighlight.
  ///
  /// In en, this message translates to:
  /// **'Highlight'**
  String get readerHighlight;

  /// No description provided for @readerAddNote.
  ///
  /// In en, this message translates to:
  /// **'Add a note...'**
  String get readerAddNote;

  /// No description provided for @readerReading.
  ///
  /// In en, this message translates to:
  /// **'Reading...'**
  String get readerReading;

  /// No description provided for @readerPrevChapter.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get readerPrevChapter;

  /// No description provided for @readerNextChapter.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get readerNextChapter;

  /// No description provided for @readerFullscreenReader.
  ///
  /// In en, this message translates to:
  /// **'Fullscreen Reader'**
  String get readerFullscreenReader;

  /// No description provided for @readerExitFullscreen.
  ///
  /// In en, this message translates to:
  /// **'Exit Fullscreen'**
  String get readerExitFullscreen;

  /// No description provided for @readerNotePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Write your spiritual reflection...'**
  String get readerNotePlaceholder;

  /// No description provided for @readerShare.
  ///
  /// In en, this message translates to:
  /// **'Share Bible Verse'**
  String get readerShare;

  /// No description provided for @readerShareSuccess.
  ///
  /// In en, this message translates to:
  /// **'Verse and link copied to clipboard!'**
  String get readerShareSuccess;

  /// No description provided for @readerDrawerBooks.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get readerDrawerBooks;

  /// No description provided for @readerDrawerTitle.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get readerDrawerTitle;

  /// No description provided for @readerNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get readerNote;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonExpand.
  ///
  /// In en, this message translates to:
  /// **'Show Full'**
  String get commonExpand;

  /// No description provided for @commonCollapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get commonCollapse;

  /// No description provided for @bookmarksTitle.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarksTitle;

  /// No description provided for @bookmarksCount.
  ///
  /// In en, this message translates to:
  /// **'You have {count} saved verses'**
  String bookmarksCount(Object count);

  /// No description provided for @bookmarksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet.'**
  String get bookmarksEmpty;

  /// No description provided for @bookmarksSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search bookmarks...'**
  String get bookmarksSearchPlaceholder;

  /// No description provided for @bookmarksEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get bookmarksEdit;

  /// No description provided for @bookmarksSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Selected'**
  String bookmarksSelectedCount(Object count);

  /// No description provided for @bookmarksBatchDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Selected ({count})'**
  String bookmarksBatchDelete(Object count);

  /// No description provided for @bookmarksSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get bookmarksSelectAll;

  /// No description provided for @bookmarksReverseSelect.
  ///
  /// In en, this message translates to:
  /// **'Reverse Select'**
  String get bookmarksReverseSelect;

  /// No description provided for @bookmarksDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete these {count} bookmarks?'**
  String bookmarksDeleteConfirm(Object count);

  /// No description provided for @bookmarksCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get bookmarksCancel;

  /// No description provided for @bookmarksConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get bookmarksConfirm;

  /// No description provided for @notesTitle.
  ///
  /// In en, this message translates to:
  /// **'Spiritual Notes'**
  String get notesTitle;

  /// No description provided for @notesCount.
  ///
  /// In en, this message translates to:
  /// **'Reflecting on {count} insights'**
  String notesCount(Object count);

  /// No description provided for @notesSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search notes...'**
  String get notesSearchPlaceholder;

  /// No description provided for @notesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notes found.'**
  String get notesEmpty;

  /// No description provided for @notesEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get notesEdit;

  /// No description provided for @notesSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Selected'**
  String notesSelectedCount(Object count);

  /// No description provided for @notesBatchDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Selected ({count})'**
  String notesBatchDelete(Object count);

  /// No description provided for @notesSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get notesSelectAll;

  /// No description provided for @notesReverseSelect.
  ///
  /// In en, this message translates to:
  /// **'Reverse Select'**
  String get notesReverseSelect;

  /// No description provided for @notesDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete these {count} notes?'**
  String notesDeleteConfirm(Object count);

  /// No description provided for @notesCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get notesCancel;

  /// No description provided for @notesConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get notesConfirm;

  /// No description provided for @globalSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Global Search'**
  String get globalSearchTitle;

  /// No description provided for @globalSearchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search for Truth and Wisdom in the Bible'**
  String get globalSearchSubtitle;

  /// No description provided for @globalSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter keywords to search verse content...'**
  String get globalSearchPlaceholder;

  /// No description provided for @globalSearchCount.
  ///
  /// In en, this message translates to:
  /// **'Found {count} verses'**
  String globalSearchCount(Object count);

  /// No description provided for @globalSearchEmpty.
  ///
  /// In en, this message translates to:
  /// **'No verses found. Try different keywords.'**
  String get globalSearchEmpty;

  /// No description provided for @globalSearchSearching.
  ///
  /// In en, this message translates to:
  /// **'Searching the scriptures...'**
  String get globalSearchSearching;

  /// No description provided for @globalSearchResultFormat.
  ///
  /// In en, this message translates to:
  /// **'{book} {chapter}:{verse}'**
  String globalSearchResultFormat(Object book, Object chapter, Object verse);

  /// No description provided for @authLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get authLoginTitle;

  /// No description provided for @authRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authRegisterTitle;

  /// No description provided for @authLoginDesc.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync your data across devices'**
  String get authLoginDesc;

  /// No description provided for @authRegisterDesc.
  ///
  /// In en, this message translates to:
  /// **'Start your spiritual journey with cloud sync'**
  String get authRegisterDesc;

  /// No description provided for @authUsernamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get authUsernamePlaceholder;

  /// No description provided for @authPasswordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordPlaceholder;

  /// No description provided for @authLoginBtn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authLoginBtn;

  /// No description provided for @authRegisterBtn.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authRegisterBtn;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authNoAccount;

  /// No description provided for @authHasAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authHasAccount;

  /// No description provided for @authSwitchRegister.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authSwitchRegister;

  /// No description provided for @authSwitchLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authSwitchLogin;

  /// No description provided for @authLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Account synced'**
  String get authLoggedIn;

  /// No description provided for @authLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get authLogout;

  /// No description provided for @authGuestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get authGuestUser;

  /// No description provided for @authSyncActive.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync active'**
  String get authSyncActive;

  /// No description provided for @authSyncPrompt.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync your data'**
  String get authSyncPrompt;

  /// No description provided for @simplifiedChinese.
  ///
  /// In en, this message translates to:
  /// **'Simplified Chinese'**
  String get simplifiedChinese;

  /// No description provided for @traditionalChinese.
  ///
  /// In en, this message translates to:
  /// **'Traditional Chinese'**
  String get traditionalChinese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @bookGn.
  ///
  /// In en, this message translates to:
  /// **'Genesis'**
  String get bookGn;

  /// No description provided for @bookEx.
  ///
  /// In en, this message translates to:
  /// **'Exodus'**
  String get bookEx;

  /// No description provided for @bookLv.
  ///
  /// In en, this message translates to:
  /// **'Leviticus'**
  String get bookLv;

  /// No description provided for @bookNm.
  ///
  /// In en, this message translates to:
  /// **'Numbers'**
  String get bookNm;

  /// No description provided for @bookDt.
  ///
  /// In en, this message translates to:
  /// **'Deuteronomy'**
  String get bookDt;

  /// No description provided for @bookJs.
  ///
  /// In en, this message translates to:
  /// **'Joshua'**
  String get bookJs;

  /// No description provided for @bookJud.
  ///
  /// In en, this message translates to:
  /// **'Judges'**
  String get bookJud;

  /// No description provided for @bookRt.
  ///
  /// In en, this message translates to:
  /// **'Ruth'**
  String get bookRt;

  /// No description provided for @book1Sm.
  ///
  /// In en, this message translates to:
  /// **'1 Samuel'**
  String get book1Sm;

  /// No description provided for @book2Sm.
  ///
  /// In en, this message translates to:
  /// **'2 Samuel'**
  String get book2Sm;

  /// No description provided for @book1kgs.
  ///
  /// In en, this message translates to:
  /// **'1 Kings'**
  String get book1kgs;

  /// No description provided for @book2kgs.
  ///
  /// In en, this message translates to:
  /// **'2 Kings'**
  String get book2kgs;

  /// No description provided for @book1Ch.
  ///
  /// In en, this message translates to:
  /// **'1 Chronicles'**
  String get book1Ch;

  /// No description provided for @book2Ch.
  ///
  /// In en, this message translates to:
  /// **'2 Chronicles'**
  String get book2Ch;

  /// No description provided for @bookEzr.
  ///
  /// In en, this message translates to:
  /// **'Ezra'**
  String get bookEzr;

  /// No description provided for @bookNe.
  ///
  /// In en, this message translates to:
  /// **'Nehemiah'**
  String get bookNe;

  /// No description provided for @bookEt.
  ///
  /// In en, this message translates to:
  /// **'Esther'**
  String get bookEt;

  /// No description provided for @bookJob.
  ///
  /// In en, this message translates to:
  /// **'Job'**
  String get bookJob;

  /// No description provided for @bookPs.
  ///
  /// In en, this message translates to:
  /// **'Psalms'**
  String get bookPs;

  /// No description provided for @bookPrv.
  ///
  /// In en, this message translates to:
  /// **'Proverbs'**
  String get bookPrv;

  /// No description provided for @bookEc.
  ///
  /// In en, this message translates to:
  /// **'Ecclesiastes'**
  String get bookEc;

  /// No description provided for @bookSo.
  ///
  /// In en, this message translates to:
  /// **'Song of Solomon'**
  String get bookSo;

  /// No description provided for @bookIs.
  ///
  /// In en, this message translates to:
  /// **'Isaiah'**
  String get bookIs;

  /// No description provided for @bookJr.
  ///
  /// In en, this message translates to:
  /// **'Jeremiah'**
  String get bookJr;

  /// No description provided for @bookLm.
  ///
  /// In en, this message translates to:
  /// **'Lamentations'**
  String get bookLm;

  /// No description provided for @bookEz.
  ///
  /// In en, this message translates to:
  /// **'Ezekiel'**
  String get bookEz;

  /// No description provided for @bookDn.
  ///
  /// In en, this message translates to:
  /// **'Daniel'**
  String get bookDn;

  /// No description provided for @bookHo.
  ///
  /// In en, this message translates to:
  /// **'Hosea'**
  String get bookHo;

  /// No description provided for @bookJl.
  ///
  /// In en, this message translates to:
  /// **'Joel'**
  String get bookJl;

  /// No description provided for @bookAm.
  ///
  /// In en, this message translates to:
  /// **'Amos'**
  String get bookAm;

  /// No description provided for @bookOb.
  ///
  /// In en, this message translates to:
  /// **'Obadiah'**
  String get bookOb;

  /// No description provided for @bookJn.
  ///
  /// In en, this message translates to:
  /// **'Jonah'**
  String get bookJn;

  /// No description provided for @bookMi.
  ///
  /// In en, this message translates to:
  /// **'Micah'**
  String get bookMi;

  /// No description provided for @bookNa.
  ///
  /// In en, this message translates to:
  /// **'Naum'**
  String get bookNa;

  /// No description provided for @bookHk.
  ///
  /// In en, this message translates to:
  /// **'Habakkuk'**
  String get bookHk;

  /// No description provided for @bookZp.
  ///
  /// In en, this message translates to:
  /// **'Zephaniah'**
  String get bookZp;

  /// No description provided for @bookHg.
  ///
  /// In en, this message translates to:
  /// **'Haggai'**
  String get bookHg;

  /// No description provided for @bookZc.
  ///
  /// In en, this message translates to:
  /// **'Zechariah'**
  String get bookZc;

  /// No description provided for @bookMl.
  ///
  /// In en, this message translates to:
  /// **'Malachi'**
  String get bookMl;

  /// No description provided for @bookMt.
  ///
  /// In en, this message translates to:
  /// **'Matthew'**
  String get bookMt;

  /// No description provided for @bookMk.
  ///
  /// In en, this message translates to:
  /// **'Mark'**
  String get bookMk;

  /// No description provided for @bookLk.
  ///
  /// In en, this message translates to:
  /// **'Luke'**
  String get bookLk;

  /// No description provided for @bookJo.
  ///
  /// In en, this message translates to:
  /// **'John'**
  String get bookJo;

  /// No description provided for @bookAct.
  ///
  /// In en, this message translates to:
  /// **'Acts'**
  String get bookAct;

  /// No description provided for @bookRm.
  ///
  /// In en, this message translates to:
  /// **'Romans'**
  String get bookRm;

  /// No description provided for @book1Co.
  ///
  /// In en, this message translates to:
  /// **'1 Corinthians'**
  String get book1Co;

  /// No description provided for @book2Co.
  ///
  /// In en, this message translates to:
  /// **'2 Corinthians'**
  String get book2Co;

  /// No description provided for @bookGl.
  ///
  /// In en, this message translates to:
  /// **'Galatians'**
  String get bookGl;

  /// No description provided for @bookEph.
  ///
  /// In en, this message translates to:
  /// **'Ephesians'**
  String get bookEph;

  /// No description provided for @bookPh.
  ///
  /// In en, this message translates to:
  /// **'Philippians'**
  String get bookPh;

  /// No description provided for @bookCl.
  ///
  /// In en, this message translates to:
  /// **'Colossians'**
  String get bookCl;

  /// No description provided for @book1ts.
  ///
  /// In en, this message translates to:
  /// **'1 Thessalonians'**
  String get book1ts;

  /// No description provided for @book2ts.
  ///
  /// In en, this message translates to:
  /// **'2 Thessalonians'**
  String get book2ts;

  /// No description provided for @book1tm.
  ///
  /// In en, this message translates to:
  /// **'1 Timothy'**
  String get book1tm;

  /// No description provided for @book2tm.
  ///
  /// In en, this message translates to:
  /// **'2 Timothy'**
  String get book2tm;

  /// No description provided for @bookTt.
  ///
  /// In en, this message translates to:
  /// **'Titus'**
  String get bookTt;

  /// No description provided for @bookPhm.
  ///
  /// In en, this message translates to:
  /// **'Philemon'**
  String get bookPhm;

  /// No description provided for @bookHb.
  ///
  /// In en, this message translates to:
  /// **'Hebrews'**
  String get bookHb;

  /// No description provided for @bookJm.
  ///
  /// In en, this message translates to:
  /// **'James'**
  String get bookJm;

  /// No description provided for @book1Pe.
  ///
  /// In en, this message translates to:
  /// **'1 Peter'**
  String get book1Pe;

  /// No description provided for @book2Pe.
  ///
  /// In en, this message translates to:
  /// **'2 Peter'**
  String get book2Pe;

  /// No description provided for @book1Jn.
  ///
  /// In en, this message translates to:
  /// **'1 John'**
  String get book1Jn;

  /// No description provided for @book2Jn.
  ///
  /// In en, this message translates to:
  /// **'2 John'**
  String get book2Jn;

  /// No description provided for @book3Jn.
  ///
  /// In en, this message translates to:
  /// **'3 John'**
  String get book3Jn;

  /// No description provided for @bookJd.
  ///
  /// In en, this message translates to:
  /// **'Jude'**
  String get bookJd;

  /// No description provided for @bookRe.
  ///
  /// In en, this message translates to:
  /// **'Revelation'**
  String get bookRe;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
