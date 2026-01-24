import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/reader_page.dart';
import 'pages/bookmarks_page.dart';
import 'pages/notes_page.dart';
import 'pages/settings_page.dart';
import 'providers/app_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppProvider(),
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
        return MaterialApp(
          title: 'Bible Reader',
          theme: provider.theme.themeData, // Use theme from provider
          home: const AppShell(),
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
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.book_online),
                label: 'Read',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                label: 'Bookmarks',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.note),
                label: 'Notes',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
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
