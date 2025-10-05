import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/memorization_provider.dart';
import 'providers/discipleship_provider.dart';
import 'screens/memorization/memorization_screen.dart';
import 'screens/evangelism_screen.dart';
import 'screens/prayer_screen.dart';
import 'screens/reading_screen.dart';
import 'screens/notes_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = NotificationService();
  await notificationService.init();

  runApp(DiscipleshipApp(notificationService: notificationService));
}

class DiscipleshipApp extends StatelessWidget {
  const DiscipleshipApp({super.key, required this.notificationService});

  final NotificationService notificationService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MemorizationProvider(notificationService),
        ),
        ChangeNotifierProvider(create: (_) => DiscipleshipProvider()),
      ],
      child: MaterialApp(
        title: 'Discipleship Coach',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const _RootScaffold(),
      ),
    );
  }
}

class _RootScaffold extends StatefulWidget {
  const _RootScaffold();

  @override
  State<_RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<_RootScaffold> {
  int _currentIndex = 0;

  static const _pages = [
    MemorizationScreen(),
    EvangelismScreen(),
    PrayerScreen(),
    ReadingScreen(),
    NotesScreen(),
  ];

  static const _titles = [
    'Memorize Scripture',
    'Evangelism',
    'Prayer',
    'Bible Reading',
    'Notes & Journaling',
  ];

  @override
  Widget build(BuildContext context) {
    final navigationBar = NavigationBar(
      selectedIndex: _currentIndex,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.menu_book), label: 'Verses'),
        NavigationDestination(icon: Icon(Icons.campaign), label: 'Evangelism'),
        NavigationDestination(icon: Icon(Icons.hands_clapping_outlined), label: 'Prayer'),
        NavigationDestination(icon: Icon(Icons.auto_stories), label: 'Reading'),
        NavigationDestination(icon: Icon(Icons.edit_note), label: 'Notes'),
      ],
      onDestinationSelected: (index) => setState(() => _currentIndex = index),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: navigationBar,
    );
  }
}
