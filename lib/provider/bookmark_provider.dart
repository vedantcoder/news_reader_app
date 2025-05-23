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
    loadBookmarks();
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
    final jsonList = _bookmarkedArticles.map((a) => a.toJson()).toList();
    await prefs.setString('bookmarks', jsonEncode(jsonList));
  }

  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('bookmarks');
    if (jsonString == null) return;

    final List<dynamic> jsonList = jsonDecode(jsonString);
    _bookmarkedArticles = jsonList
        .map((jsonItem) =>
        NewsArticle.fromMap(jsonItem as Map<String, dynamic>))
        .toList();

    notifyListeners();
  }
}