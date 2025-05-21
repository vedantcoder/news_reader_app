import 'package:flutter/material.dart';
import '../models/news_article.dart';

class ArticleCard extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback onTap;

  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        onTap: onTap,
        title: Text(
          article.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              article.content.length > 80
                  ? article.content.substring(0, 80) + '...'
                  : article.content,
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: [
                Chip(label: Text(article.category)),
                if (article.isTrending)
                  Chip(
                    label: const Text('Trending'),
                    backgroundColor: Colors.orange.shade200,
                  ),
                if (!article.isLong)
                  Chip(
                    label: const Text('Short'),
                    backgroundColor: Colors.green.shade100,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
