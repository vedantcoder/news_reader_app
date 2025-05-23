import 'package:flutter/material.dart';
import '../models/news_article.dart';
import '../services/news_api.dart';

class NewsProvider with ChangeNotifier {
  List<NewsArticle> _articles = [];
  bool _isLoading = true;

  List<NewsArticle> get articles => _articles;
  bool get isLoading => _isLoading;
  List<NewsArticle> get allArticles => _articles; // Optional alias

  Future<void> fetchArticles() async {
    _isLoading = true;
    notifyListeners();

    _articles = await NewsService.fetchAllCategoriesNews();

    _isLoading = false;
    notifyListeners();
  }
}