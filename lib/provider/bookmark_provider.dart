import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_article.dart';

class BookmarkProvider with ChangeNotifier {
  List<NewsArticle> _bookmarkedArticles = [];
  List<NewsArticle> get bookmarkedArticles => _bookmarkedArticles;

  // Reference list to compare URLs when reloading bookmarks
  List<NewsArticle> _allArticles = [];

  void setAvailableArticles(List<NewsArticle> allArticles) {
    _allArticles = allArticles;
    _loadBookmarksFromPrefs();
  }

  Future<void> toggleBookmark(NewsArticle article) async {
    final isBookmarked = _bookmarkedArticles.any((a) => a.url == article.url);

    if (isBookmarked) {
      _bookmarkedArticles.removeWhere((a) => a.url == article.url);
    } else {
      _bookmarkedArticles.add(article);
    }

    notifyListeners();
    await _saveBookmarksToPrefs();
  }

  bool isBookmarked(NewsArticle article) {
    return _bookmarkedArticles.any((a) => a.url == article.url);
  }

  Future<void> _saveBookmarksToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final urls = _bookmarkedArticles.map((a) => a.url).toList();
    await prefs.setStringList('bookmarks', urls);
  }

  Future<void> _loadBookmarksFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final urls = prefs.getStringList('bookmarks') ?? [];

    _bookmarkedArticles = _allArticles
        .where((article) => urls.contains(article.url))
        .toList();

    notifyListeners();
  }
}
