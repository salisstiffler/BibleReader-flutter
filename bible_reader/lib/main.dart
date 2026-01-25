import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Import flutter_localizations
 // Import generated AppLocalizations

import 'l10n/app_localizations.dart';
import 'pages/reader_page.dart';
import 'pages/bookmarks_page.dart';
import 'pages/notes_page.dart';
import 'pages/settings_page.dart';
import 'providers/app_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  final appProvider = AppProvider();
  await appProvider.initializeApp(Uri.base);
  runApp(
    ChangeNotifierProvider.value(
      value: appProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        print('MyApp: AppLocalizations.supportedLocales: ${AppLocalizations.supportedLocales}');
        print('MyApp: Current provider.appLocale: ${provider.appLocale}');
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle, // Localized title
          theme: provider.theme.themeData,
          home: const AppShell(),
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
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  // _selectedIndex is now managed by the provider, but we keep it here
  // to avoid immediate UI glitches before provider is fully initialized.
  // The actual state will be read from the provider.
  int _internalSelectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    ReaderPage(),
    BookmarksPage(),
    NotesPage(),
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
                label: AppLocalizations.of(context)!.readTab,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.bookmark),
                label: AppLocalizations.of(context)!.bookmarksTab,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.note),
                label: AppLocalizations.of(context)!.notesTab,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: AppLocalizations.of(context)!.settingsTab,
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
