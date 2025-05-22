import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../models/news_article.dart';
import '../widgets/article_card.dart';
import '../provider/settings_provider.dart';
import '../services/news_api.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String? selectedCategory;
  List<NewsArticle> allArticles = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      selectedCategory = args;
    }

    if (isLoading) {
      fetchArticles();
    }
  }

  Future<void> fetchArticles() async {
    try {
      final articles = await NewsService.fetchAllCategoriesNews();
      setState(() {
        allArticles = articles;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load news: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Extract unique categories from the fetched articles
    final categories = allArticles
        .map((article) => article.category)
        .toSet()
        .toList();

    // Filter articles based on selected category and filters
    final filteredArticles = allArticles.where((article) {
      if (selectedCategory == null) return false;
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
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth < 600 ? 16.0 : 32.0,
          vertical: 20.0,
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(child: Text(errorMessage!))
            : Column(
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
                        selectedCategory = null;
                      } else {
                        selectedCategory = category;
                      }
                    });
                  },
                  child: Container(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blueAccent
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color:
                          isSelected ? Colors.white : Colors.black87,
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
                    padding: const EdgeInsets.only(
                        right: 8.0, top: 4, bottom: 4),
                    child: Chip(
                      label: const Text('Short Only'),
                      backgroundColor:
                      Colors.greenAccent.shade100,
                    ),
                  ),
                if (settings.showTrendingOnly)
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 8.0, top: 4, bottom: 4),
                    child: Chip(
                      label: const Text('Trending Only'),
                      backgroundColor:
                      Colors.orangeAccent.shade100,
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
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              Expanded(
                child: filteredArticles.isEmpty
                    ? const Center(
                    child: Text(
                        'No articles match your current filters.'))
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