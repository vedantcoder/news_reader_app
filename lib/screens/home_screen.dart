import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../models/news_article.dart';
import '../widgets/article_card.dart';
import '../provider/settings_provider.dart';
import '../provider/news_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);
      newsProvider.fetchArticles();
    });
  }

  Future<void> _refreshArticles() async {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    await newsProvider.fetchArticles();
  }

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
    final newsProvider = Provider.of<NewsProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    if (newsProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (newsProvider.error != null) {
      return Scaffold(
        body: Center(child: Text('Failed to load news: ${newsProvider.error}')),
      );
    }

    final allArticles = newsProvider.articles;
    final filteredArticles = applyGlobalFilters(allArticles, settingsProvider);

    var filteredByCategory = selectedCategory == null
        ? filteredArticles
        : filteredArticles.where((a) => a.category == selectedCategory).toList();

    filteredByCategory.sort((a, b) {
      final dateA = a.date != null ? DateTime.tryParse(a.date!) ?? DateTime(1970) : DateTime(1970);
      final dateB = b.date != null ? DateTime.tryParse(b.date!) ?? DateTime(1970) : DateTime(1970);
      return dateB.compareTo(dateA);
    });

    final displayedArticles = filteredByCategory.take(8).toList();
    final categories = allArticles.map((a) => a.category).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Reader'),
        actions: [
          TextButton(onPressed: () => Navigator.pushNamed(context, '/'), child: const Text('Home')),
          TextButton(onPressed: () => Navigator.pushNamed(context, '/category'), child: const Text('Categories')),
          TextButton(onPressed: () => Navigator.pushNamed(context, '/bookmarks'), child: const Text('Bookmarks')),
          TextButton(onPressed: () => Navigator.pushNamed(context, '/settings'), child: const Text('Settings')),
          IconButton(
            icon: Icon(settingsProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => settingsProvider.toggleDarkMode(!settingsProvider.isDarkMode),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth < 600 ? 16.0 : 32.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome to News Reader!', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            CarouselSlider(
              options: CarouselOptions(height: 50, viewportFraction: 0.4, autoPlay: true),
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
                      child: Text(category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  ),
                );
              }).toList(),
            ),
            Row(
              children: [
                if (settingsProvider.showShortOnly)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 4, bottom: 4),
                    child: Chip(label: const Text('Short Only'), backgroundColor: Colors.black),
                  ),
                if (settingsProvider.showTrendingOnly)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 4, bottom: 4),
                    child: Chip(label: const Text('Trending Only'), backgroundColor: Colors.black),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              selectedCategory == null
                  ? 'Latest Articles (8)'
                  : 'Latest in $selectedCategory (${displayedArticles.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: displayedArticles.isEmpty
                  ? const Center(child: Text('No articles match your filters'))
                  : RefreshIndicator(
                onRefresh: _refreshArticles,
                child: ListView.builder(
                  itemCount: displayedArticles.length,
                  itemBuilder: (context, index) {
                    final article = displayedArticles[index];
                    return ArticleCard(
                      article: article,
                      onTap: () => Navigator.pushNamed(context, '/article', arguments: article),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}