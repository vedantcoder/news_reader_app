import 'package:flutter/material.dart';
import '../models/news_article.dart';

class BookmarkProvider with ChangeNotifier {
  final List<NewsArticle> _bookmarkedArticles = [];

  List<NewsArticle> get bookmarkedArticles => _bookmarkedArticles;

  void toggleBookmark(NewsArticle article) {
    if (_bookmarkedArticles.contains(article)) {
      _bookmarkedArticles.remove(article);
    } else {
      _bookmarkedArticles.add(article);
    }
    notifyListeners();
  }

  bool isBookmarked(NewsArticle article) {
    return _bookmarkedArticles.contains(article);
  }
}