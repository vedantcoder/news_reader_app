import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_article.dart';

class NewsService {
  static const _apiKey = '3164a20e8f8f42a9b379caba9ed678c2';
  static const _baseUrl = 'https://newsapi.org/v2/top-headlines';
  static const _country = 'us';

  static final List<String> categories = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology',
  ];

  static Future<List<NewsArticle>> fetchAllCategoriesNews() async {
    final List<NewsArticle> allArticles = [];

    for (var category in categories) {
      final url = '$_baseUrl?country=$_country&category=$category&apiKey=$_apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> articlesJson = data['articles'];

        final articles = articlesJson.map((json) {
          return NewsArticle.fromJson(json, category);
        }).toList();

        allArticles.addAll(articles);
      } else {
        print('Failed to load $category news: ${response.statusCode}');
      }
    }

    return allArticles;
  }
}