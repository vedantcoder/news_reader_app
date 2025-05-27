import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/home_screen.dart';
import './screens/bookmarks_screen.dart';
import './screens/category_screen.dart';
import './screens/settings_screen.dart';
import './screens/article_detail_screen.dart';

import './provider/bookmark_provider.dart';
import './provider/settings_provider.dart';
import './provider/news_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      title: 'News Reader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const StartupWrapper(),
        '/category': (context) => CategoryScreen(),
        '/bookmarks': (context) => BookmarksScreen(),
        '/settings': (context) => SettingsScreen(),
        '/article': (context) => ArticleDetailScreen(),
      },
    );
  }
}

/// Widget to handle async initialization and show loading UI before showing HomeScreen
class StartupWrapper extends StatefulWidget {
  const StartupWrapper({super.key});

  @override
  State<StartupWrapper> createState() => _StartupWrapperState();
}

class _StartupWrapperState extends State<StartupWrapper> {
  bool _isInitialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);
      final bookmarkProvider = Provider.of<BookmarkProvider>(context, listen: false);

      await newsProvider.fetchArticles();

      // After articles loaded, provide them to bookmark provider
      bookmarkProvider.setAvailableArticles(newsProvider.articles);

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        body: Center(child: Text('Error loading app data: $_error')),
      );
    }

    if (!_isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Initialization complete - show HomeScreen
    return HomeScreen();
  }
}