import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Required for accessing other providers
import '../models/news_article.dart';
import '../services/news_api.dart';
import 'bookmark_provider.dart';

class NewsProvider with ChangeNotifier {
  List<NewsArticle> _articles = [];
  bool _isLoading = true;

  List<NewsArticle> get articles => _articles;
  bool get isLoading => _isLoading;

  Future<void> loadArticles(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    _articles = await NewsService.fetchAllCategoriesNews();

    // Update bookmark provider with the list of all fetched articles
    final bookmarkProvider = Provider.of<BookmarkProvider>(context, listen: false);
    bookmarkProvider.setAvailableArticles(_articles);

    _isLoading = false;
    notifyListeners();
  }
}