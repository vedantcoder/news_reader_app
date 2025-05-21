import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/bookmark_provider.dart';
import '../provider/settings_provider.dart';
import '../widgets/article_card.dart';
import '../models/news_article.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  List<NewsArticle> applyGlobalFilters(List<NewsArticle> articles, SettingsProvider settings) {
    return articles.where((article) {
      if (settings.showShortOnly && article.isLong) return false;  // Use isLong here
      if (settings.showTrendingOnly && !article.isTrending) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    final allBookmarked = bookmarkProvider.bookmarkedArticles;
    final filteredArticles = applyGlobalFilters(allBookmarked, settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarked Articles'),
        actions: [
          TextButton(onPressed: () => Navigator.pushNamed(context, '/'), child: const Text('Home', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () => Navigator.pushNamed(context, '/category'), child: const Text('Categories', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () => Navigator.pushNamed(context, '/bookmarks'), child: const Text('Bookmarks', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () => Navigator.pushNamed(context, '/settings'), child: const Text('Settings', style: TextStyle(color: Colors.white))),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Chips Row
            Row(
              children: [
                if (settingsProvider.showShortOnly)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                    child: Chip(
                      label: const Text('Short Only'),
                      backgroundColor: Colors.green.shade100,
                    ),
                  ),
                if (settingsProvider.showTrendingOnly)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                    child: Chip(
                      label: const Text('Trending Only'),
                      backgroundColor: Colors.orange.shade100,
                    ),
                  ),
              ],
            ),

            // Show message if no articles after filtering
            if (filteredArticles.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('No bookmarks match your current filters.'),
                ),
              )
            else
            // Article List
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
