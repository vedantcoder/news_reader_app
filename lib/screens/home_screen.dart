import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../models/news_article.dart';
import '../widgets/article_card.dart';
import '../data/dummy_data.dart';
import '../provider/settings_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedCategory;

  List<NewsArticle> applyGlobalFilters(List<NewsArticle> articles, SettingsProvider settings) {
    return articles.where((article) {
      if (settings.showShortOnly && article.isLong) return false;
      if (settings.showTrendingOnly && !article.isTrending) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    final filteredArticlesRaw = selectedCategory == null
        ? dummyArticles
        : dummyArticles.where((article) => article.category == selectedCategory).toList();

    final filteredArticles = applyGlobalFilters(filteredArticlesRaw, settingsProvider);

    final categories = dummyArticles.map((article) => article.category).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('News Reader'),
        actions: [
          TextButton(onPressed: () => Navigator.pushNamed(context, '/'), child: Text('Home', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () => Navigator.pushNamed(context, '/category'), child: Text('Categories', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () => Navigator.pushNamed(context, '/bookmarks'), child: Text('Bookmarks', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () => Navigator.pushNamed(context, '/settings'), child: Text('Settings', style: TextStyle(color: Colors.white))),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome to News Reader!', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 16),
            CarouselSlider(
              options: CarouselOptions(height: 50, viewportFraction: 0.4, enlargeCenterPage: true, enableInfiniteScroll: true, autoPlay: true),
              items: categories.map((category) {
                final isSelected = category == selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() {
                    selectedCategory = (selectedCategory == category) ? null : category;
                  }),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(category, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w600)),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 24),
            Text(
              selectedCategory == null ? 'Latest Articles' : 'Articles in "$selectedCategory"',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: filteredArticles.length,
                itemBuilder: (context, index) {
                  final article = filteredArticles[index];
                  return ArticleCard(
                    article: article,
                    onTap: () {
                      Navigator.pushNamed(context, '/article', arguments: article);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
