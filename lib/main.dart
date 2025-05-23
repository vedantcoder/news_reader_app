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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Instantiate providers manually
  final settingsProvider = SettingsProvider();
  final newsProvider = NewsProvider();
  final bookmarkProvider = BookmarkProvider();

  // Load articles before bookmarks (important for correct matching)
  await newsProvider.fetchArticles();
  bookmarkProvider.setAvailableArticles(newsProvider.allArticles);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => settingsProvider),
        ChangeNotifierProvider(create: (_) => newsProvider),
        ChangeNotifierProvider(create: (_) => bookmarkProvider),
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
        '/': (context) => HomeScreen(),
        '/category': (context) => CategoryScreen(),
        '/bookmarks': (context) => BookmarksScreen(),
        '/settings': (context) => SettingsScreen(),
        '/article': (context) => ArticleDetailScreen(),
      },
    );
  }
}
