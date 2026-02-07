import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:async';
 // Import generated AppLocalizations

import 'l10n/app_localizations.dart';
import 'pages/reader_page.dart';
import 'pages/bookmarks_page.dart';
import 'pages/notes_page.dart';
import 'pages/search_page.dart';
import 'pages/settings_page.dart';
import 'providers/app_provider.dart';
import 'services/deeplink_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  
  final appProvider = AppProvider();
  
  // Handle initial deep link from iOS/Android
  final deepLinkUri = await _getInitialDeepLink();
  
  await appProvider.initializeApp(Uri.base);
  
  runApp(
    ChangeNotifierProvider.value(
      value: appProvider,
      child: MyApp(initialDeepLink: deepLinkUri),
    ),
  );
}

Future<Uri?> _getInitialDeepLink() async {
  try {
    final platform = MethodChannel('com.berlin.bible_reader/deeplink');
    final String? deepLinkUrl = await platform.invokeMethod<String?>('getInitialDeepLink');
    if (deepLinkUrl != null) {
      return Uri.parse(deepLinkUrl);
    }
  } catch (e) {
    // Platform not available or deeplink not present
  }
  return null;
}

class MyApp extends StatelessWidget {
  final Uri? initialDeepLink;
  
  const MyApp({super.key, this.initialDeepLink});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle, // Localized title
          theme: provider.theme.getThemeData(
            accentColor: provider.accentColor,
            fontKey: provider.fontFamily,
          ),
          home: AppShell(initialDeepLink: initialDeepLink),
          locale: provider.appLocale, // Set app locale dynamically
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales, // Supported locales from generated file
        );
      },
    );
  }
}

class AppShell extends StatefulWidget {
  final Uri? initialDeepLink;
  
  const AppShell({super.key, this.initialDeepLink});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  // _selectedIndex is now managed by the provider, but we keep it here
  // to avoid immediate UI glitches before provider is fully initialized.
  // The actual state will be read from the provider.
  int _internalSelectedIndex = 0;
  late final DeepLinkService _deepLinkService;
  StreamSubscription? _deepLinkSubscription;
  bool _initialDeepLinkProcessed = false;

  @override
  void initState() {
    super.initState();
    _deepLinkService = DeepLinkService();
    _setupDeepLinkListener();
    
    // Handle initial deep link if provided
    if (widget.initialDeepLink != null && !_initialDeepLinkProcessed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _processDeepLink(widget.initialDeepLink!);
        _initialDeepLinkProcessed = true;
      });
    }
  }

  void _setupDeepLinkListener() {
    _deepLinkSubscription = _deepLinkService.deepLinkStream.listen((deepLinkData) {
      _handleDeepLink(deepLinkData);
    });
  }

  void _processDeepLink(Uri uri) {
    final deepLinkData = DeepLinkData.fromUri(uri);
    _handleDeepLink(deepLinkData);
  }

  void _handleDeepLink(DeepLinkData deepLinkData) {
    final provider = context.read<AppProvider>();
    
    if (deepLinkData.bookIndex != null && deepLinkData.chapterIndex != null) {
      // Navigate to reader page and set the book and chapter
      provider.navigateTo(
        deepLinkData.bookIndex!,
        deepLinkData.chapterIndex!,
        deepLinkData.verseNum,
      );
      
      // Switch to reader tab
      setState(() {
        _internalSelectedIndex = 0;
        provider.currentTabIndex = 0;
      });
    }
  }

  @override
  void dispose() {
    _deepLinkSubscription?.cancel();
    super.dispose();
  }

  static const List<Widget> _pages = <Widget>[
    ReaderPage(),
    BookmarksPage(),
    NotesPage(),
    SearchPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        // Update internal index from provider if it has changed externally
        if (_internalSelectedIndex != provider.currentTabIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _internalSelectedIndex = provider.currentTabIndex;
            });
          });
        }

        return Scaffold(
          body: IndexedStack(
            index: _internalSelectedIndex,
            children: _pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.book_online),
                label: AppLocalizations.of(context)!.navRead,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.bookmark),
                label: AppLocalizations.of(context)!.navBookmarks,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.note),
                label: AppLocalizations.of(context)!.navNotes,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.search),
                label: AppLocalizations.of(context)!.navSearch,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: AppLocalizations.of(context)!.navSettings,
              ),
            ],
            currentIndex: _internalSelectedIndex,
            selectedItemColor: Theme.of(context).primaryColor, // Use theme primary color
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              provider.currentTabIndex = index; // Update provider
              setState(() {
                _internalSelectedIndex = index; // Update internal state immediately
              });
            },
            type: BottomNavigationBarType.fixed, // To show all labels
          ),
        );
      },
    );
  }
}
