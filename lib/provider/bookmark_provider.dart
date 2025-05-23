//bookmark_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_article.dart';

class BookmarkProvider with ChangeNotifier {
  List<NewsArticle> _bookmarkedArticles = [];
  List<NewsArticle> get bookmarkedArticles => _bookmarkedArticles;

  List<NewsArticle> _allArticles = [];

  void setAvailableArticles(List<NewsArticle> allArticles) {
    _allArticles = allArticles;
    loadBookmarks(); // Load after all articles are available
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
    final List<String> encodedArticles = _bookmarkedArticles
        .map((article) => jsonEncode(article.toJson()))
        .toList();
    await prefs.setStringList('bookmarks', encodedArticles);
  }

  Future<void> loadBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? encodedArticles = prefs.getStringList('bookmarks');

      if (encodedArticles != null) {
        _bookmarkedArticles = encodedArticles
            .map((articleStr) => NewsArticle.fromMap(jsonDecode(articleStr)))
            .toList();
      }
    } catch (e) {
      print('Error loading bookmarks: $e');
      _bookmarkedArticles = []; // fallback
    }

    notifyListeners();
  }
}