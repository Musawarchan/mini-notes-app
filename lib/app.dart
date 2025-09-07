import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/viewmodel/theme_viewmodel.dart';
import 'features/notes/viewmodel/notes_viewmodel.dart';
import 'features/posts/viewmodel/posts_viewmodel.dart';
import 'features/settings/view/settings_view.dart';
import 'features/notes/view/notes_view.dart';
import 'features/posts/view/posts_view.dart';

class NotesMiniApp extends StatelessWidget {
  const NotesMiniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeViewModel()..init(),
        ),
        ChangeNotifierProvider(create: (_) => NotesViewModel()),
        ChangeNotifierProvider(create: (_) => PostsViewModel()),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeViewModel, child) {
          return MaterialApp(
            title: 'Notes Mini App',
            theme: AppTheme.lightTheme(
                AppTheme.seedColors[themeViewModel.seedColorIndex]),
            darkTheme: AppTheme.darkTheme(
                AppTheme.seedColors[themeViewModel.seedColorIndex]),
            themeMode: themeViewModel.themeMode,
            home: const MainNavigationView(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int _currentIndex = 0;

  final List<Widget> _views = [
    const NotesView(),
    const PostsView(),
    const SettingsView(),
  ];

  final List<String> _titles = [
    'Notes',
    'Posts',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
      ),
      body: _views[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.note),
            label: 'Notes',
          ),
          NavigationDestination(
            icon: Icon(Icons.article),
            label: 'Posts',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
