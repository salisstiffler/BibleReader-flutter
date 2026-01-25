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

  /// No description provided for @readTab.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get readTab;

  /// No description provided for @bookmarksTab.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarksTab;

  /// No description provided for @notesTab.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesTab;

  /// No description provided for @settingsTab.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTab;

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

  /// No description provided for @localizationSection.
  ///
  /// In en, this message translates to:
  /// **'Localization'**
  String get localizationSection;

  /// No description provided for @visualStyleSection.
  ///
  /// In en, this message translates to:
  /// **'Visual Style'**
  String get visualStyleSection;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @sepiaTheme.
  ///
  /// In en, this message translates to:
  /// **'Sepia'**
  String get sepiaTheme;

  /// No description provided for @readingControlsSection.
  ///
  /// In en, this message translates to:
  /// **'Reading Controls'**
  String get readingControlsSection;

  /// No description provided for @typographySize.
  ///
  /// In en, this message translates to:
  /// **'Typography Size'**
  String get typographySize;

  /// No description provided for @speechRate.
  ///
  /// In en, this message translates to:
  /// **'Speech Rate'**
  String get speechRate;

  /// No description provided for @continuousReading.
  ///
  /// In en, this message translates to:
  /// **'Continuous Reading'**
  String get continuousReading;

  /// No description provided for @continuousReadingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-play subsequent verses for hands-free study.'**
  String get continuousReadingSubtitle;

  /// No description provided for @pauseOnChapterSwitch.
  ///
  /// In en, this message translates to:
  /// **'Pause on Chapter Switch'**
  String get pauseOnChapterSwitch;

  /// No description provided for @pauseOnChapterSwitchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Automatically pause playback when manually switching chapters.'**
  String get pauseOnChapterSwitchSubtitle;

  /// No description provided for @selectChapter.
  ///
  /// In en, this message translates to:
  /// **'Select Chapter'**
  String get selectChapter;

  /// No description provided for @previousChapter.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previousChapter;

  /// No description provided for @nextChapter.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextChapter;

  /// No description provided for @listenChapter.
  ///
  /// In en, this message translates to:
  /// **'Listen Chapter'**
  String get listenChapter;

  /// No description provided for @pauseListening.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseListening;

  /// No description provided for @dailyWisdom.
  ///
  /// In en, this message translates to:
  /// **'Daily Wisdom'**
  String get dailyWisdom;

  /// No description provided for @writeYourSpiritualReflection.
  ///
  /// In en, this message translates to:
  /// **'Write your spiritual reflection...'**
  String get writeYourSpiritualReflection;

  /// No description provided for @bookNotFound.
  ///
  /// In en, this message translates to:
  /// **'Book not found'**
  String get bookNotFound;

  /// No description provided for @chapterOrVerseOutOfBounds.
  ///
  /// In en, this message translates to:
  /// **'Chapter or verse out of bounds'**
  String get chapterOrVerseOutOfBounds;

  /// No description provided for @ttsError.
  ///
  /// In en, this message translates to:
  /// **'TTS Error'**
  String get ttsError;

  /// No description provided for @invalidDeepLinkParameters.
  ///
  /// In en, this message translates to:
  /// **'Invalid deep link parameters.'**
  String get invalidDeepLinkParameters;

  /// No description provided for @simplifiedChinese.
  ///
  /// In en, this message translates to:
  /// **'Simplified'**
  String get simplifiedChinese;

  /// No description provided for @traditionalChinese.
  ///
  /// In en, this message translates to:
  /// **'Traditional'**
  String get traditionalChinese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @noBookmarksYet.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet. Bookmark verses from the Reader page.'**
  String get noBookmarksYet;

  /// No description provided for @noNotesYet.
  ///
  /// In en, this message translates to:
  /// **'No notes yet. Add notes to verses from the Reader page.'**
  String get noNotesYet;

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
  /// **'Nahum'**
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
