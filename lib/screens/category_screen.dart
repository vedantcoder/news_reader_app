import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../models/news_article.dart';
import '../widgets/article_card.dart';
import '../provider/settings_provider.dart';
import '../provider/news_provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String? selectedCategory;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      selectedCategory = args;
    }

    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    if (newsProvider.articles.isEmpty && !newsProvider.isLoading) {
      newsProvider.fetchArticles();
    }
  }

  List<NewsArticle> applyGlobalFilters(List<NewsArticle> articles, SettingsProvider settings, String? category) {
    return articles.where((article) {
      if (category != null && article.category != category) return false;
      if (settings.showShortOnly && article.isLong) return false;
      if (settings.showTrendingOnly && !article.isTrending) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
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

    final categories = newsProvider.articles.map((a) => a.category).toSet().toList();

    // If no category selected, show message asking to select a category
    if (selectedCategory == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Categories'),
          actions: [
            TextButton(onPressed: () => Navigator.pushNamed(context, '/'), child: const Text('Home')),
            TextButton(onPressed: () => Navigator.pushNamed(context, '/category'), child: const Text('Categories')),
            TextButton(onPressed: () => Navigator.pushNamed(context, '/bookmarks'), child: const Text('Bookmarks')),
            TextButton(onPressed: () => Navigator.pushNamed(context, '/settings'), child: const Text('Settings')),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth < 600 ? 16.0 : 32.0, vertical: 20.0),
          child: Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(height: 50, viewportFraction: 0.4, autoPlay: true),
                items: categories.map((category) {
                  return GestureDetector(
                    onTap: () => setState(() {
                      selectedCategory = category;
                    }),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(category,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  'Please select a category',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Category is selected - show articles for that category
    final filteredArticles = applyGlobalFilters(newsProvider.articles, settings, selectedCategory);

    // Sort articles by date descending
    filteredArticles.sort((a, b) {
      final dateA = a.date != null ? DateTime.tryParse(a.date!) ?? DateTime(1970) : DateTime(1970);
      final dateB = b.date != null ? DateTime.tryParse(b.date!) ?? DateTime(1970) : DateTime(1970);
      return dateB.compareTo(dateA);
    });

    final displayedArticles = filteredArticles.take(8).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Category: $selectedCategory'),
        actions: [
          TextButton(onPressed: () => Navigator.pushNamed(context, '/'), child: const Text('Home')),
          TextButton(onPressed: () => Navigator.pushNamed(context, '/category'), child: const Text('Categories')),
          TextButton(onPressed: () => Navigator.pushNamed(context, '/bookmarks'), child: const Text('Bookmarks')),
          TextButton(onPressed: () => Navigator.pushNamed(context, '/settings'), child: const Text('Settings')),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth < 600 ? 16.0 : 32.0, vertical: 20.0),
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(height: 50, viewportFraction: 0.4, autoPlay: true),
              items: categories.map((category) {
                final isSelected = category == selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() {
                    selectedCategory = category;
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
            const SizedBox(height: 24),
            if (displayedArticles.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'No articles found in this category',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              )
            else
              Expanded(
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
          ],
        ),
      ),
    );
  }
}