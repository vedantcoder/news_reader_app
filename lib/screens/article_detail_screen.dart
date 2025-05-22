//article_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/news_article.dart';
import '../provider/bookmark_provider.dart';

class ArticleDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NewsArticle article = ModalRoute.of(context)!.settings.arguments as NewsArticle;
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);
    final isBookmarked = bookmarkProvider.isBookmarked(article);

    // Function to launch URL externally
    void _launchURL() async {
      final urlString = article.url.trim();
      if (urlString.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Article URL is empty.')),
        );
        return;
      }

      Uri? url;
      try {
        url = Uri.parse(urlString.startsWith('http') ? urlString : 'https://$urlString');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid URL format.')),
        );
        return;
      }

      print('Attempting to launch: $url');

      final canLaunch = await canLaunchUrl(url);
      if (!canLaunch) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch the article URL')),
        );
        return;
      }

      final success = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to open the article.')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
        actions: [
          IconButton(
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () {
              bookmarkProvider.toggleBookmark(article);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isBookmarked
                      ? 'Removed from bookmarks'
                      : 'Added to bookmarks'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl != null && article.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: 500,
                    maxWidth: 500,
                  ),
                  child: Image.network(
                    article.imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              article.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            if ((article.date != null && article.date!.isNotEmpty) ||
                (article.time != null && article.time!.isNotEmpty))
              Text(
                '${article.date ?? ''} ${article.time ?? ''}'.trim(),
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            const SizedBox(height: 16),
            Text(
              article.content.isNotEmpty ? article.content : 'Content not available.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _launchURL,
              child: const Text('Read Full Article'),
            ),
          ],
        ),
      ),
    );
  }
}