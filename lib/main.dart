//main.dart
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
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to SettingsProvider for theme changes
    final settings = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      title: 'News Reader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light, // <-- use provider value here
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