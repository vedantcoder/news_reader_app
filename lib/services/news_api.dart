//news_api.dart (service)
import 'dart:convert';
import 'dart:async'; // Required for Future.delayed
import 'package:http/http.dart' as http;
import '../models/news_article.dart';

class NewsService {
  static const _apiKey = '4FSzvt8t6eNSxZBQNugzmjixXZIjTqXWFQG1H8b5';
  static const _baseUrl = 'https://api.thenewsapi.com/v1/news/all';

  static final List<String> allCategories = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology',
  ];

  static Future<List<NewsArticle>> fetchAllCategoriesNews({bool testMode = false}) async {
    final List<NewsArticle> allArticles = [];

    // If testMode is true, fetch only the 'general' category, else fetch all categories
    final categories = testMode ? ['general'] : allCategories;

    for (var category in categories) {
      final url = Uri.parse(
        '$_baseUrl?api_token=$_apiKey&language=en&categories=$category&limit=10',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey('data')) {
          final List<dynamic> articlesJson = data['data'];

          final articles = articlesJson.map((json) {
            return NewsArticle.fromNewsApiJson(json, category);
          }).toList();

          allArticles.addAll(articles);
        } else {
          print('No "data" key in response for $category');
        }
      } else {
        print('Failed to load $category news: ${response.statusCode}');
      }

      // Respect 1 request per second rate limit
      await Future.delayed(const Duration(seconds: 1));
    }

    return allArticles;
  }
}
