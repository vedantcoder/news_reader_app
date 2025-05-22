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
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        article.imageUrl!,
                        width: isWide ? 120 : 80,
                        height: isWide ? 80 : 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        if (article.date != null || article.time != null)
                          Text(
                            '${article.date ?? ''} ${article.time ?? ''}',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        const SizedBox(height: 6),
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
                                backgroundColor: Colors.black,
                              ),
                            if (!article.isLong)
                              Chip(
                                label: const Text('Short'),
                                backgroundColor: Colors.black,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}