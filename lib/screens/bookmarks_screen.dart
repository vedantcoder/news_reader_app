import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/bookmark_provider.dart';
import '../widgets/article_card.dart';

class BookmarksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);
    final bookmarkedArticles = bookmarkProvider.bookmarkedArticles;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth < 600 ? 16.0 : 32.0, vertical: 20.0),
        child: bookmarkedArticles.isEmpty
            ? Center(child: Text('No bookmarked articles.', style: Theme.of(context).textTheme.bodyLarge))
            : ListView.builder(
          itemCount: bookmarkedArticles.length,
          itemBuilder: (context, index) {
            final article = bookmarkedArticles[index];
            return ArticleCard(
              article: article,
              onTap: () {
                Navigator.pushNamed(context, '/article', arguments: article);
              },
            );
          },
        ),
      ),
    );
  }
}