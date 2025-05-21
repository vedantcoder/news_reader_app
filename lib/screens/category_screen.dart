import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../models/news_article.dart';
import '../widgets/article_card.dart';
import '../data/dummy_data.dart';
import '../provider/settings_provider.dart';

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

    // Get initial category from arguments if any
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      selectedCategory = args;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    // All unique categories from dummyArticles
    final categories = dummyArticles
        .map((article) => article.category)
        .toSet()
        .toList();

    // Filter articles by selectedCategory and global filters
    final filteredArticles = dummyArticles.where((article) {
      if (selectedCategory == null) return false; // No category selected: show no articles
      if (article.category != selectedCategory) return false;
      if (settings.showShortOnly && article.isLong) return false;
      if (settings.showTrendingOnly && !article.isTrending) return false;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedCategory == null
            ? 'Select a Category'
            : 'Category: $selectedCategory'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Carousel
            CarouselSlider(
              options: CarouselOptions(
                height: 50,
                viewportFraction: 0.4,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                autoPlay: true,
              ),
              items: categories.map((category) {
                final isSelected = category == selectedCategory;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedCategory == category) {
                        selectedCategory = null; // deselect category on tap
                      } else {
                        selectedCategory = category;
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Filter Info Chips
            Row(
              children: [
                if (settings.showShortOnly)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 4, bottom: 4),
                    child: Chip(
                      label: const Text('Short Only'),
                      backgroundColor: Colors.greenAccent.shade100,
                    ),
                  ),
                if (settings.showTrendingOnly)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 4, bottom: 4),
                    child: Chip(
                      label: const Text('Trending Only'),
                      backgroundColor: Colors.orangeAccent.shade100,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            if (selectedCategory == null)
              const Expanded(
                child: Center(
                  child: Text(
                    'Please select a category from above to see articles.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              Expanded(
                child: filteredArticles.isEmpty
                    ? const Center(child: Text('No articles match your current filters.'))
                    : ListView.builder(
                  itemCount: filteredArticles.length,
                  itemBuilder: (context, index) {
                    final article = filteredArticles[index];
                    return ArticleCard(
                      article: article,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/article',
                          arguments: article,
                        );
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
