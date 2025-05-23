import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_reader_app/models/news_article.dart';
import 'package:news_reader_app/provider/bookmark_provider.dart';

class ArticleCard extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback? onTap;

  const ArticleCard({super.key, required this.article, this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: isDesktop ? _buildDesktopLayout(context) : _buildMobileLayout(context),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        if (article.imageUrl != null)
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                child: Image.network(
                  article.imageUrl!,
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: _buildBookmarkIcon(context),
              ),
            ],
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildTextContent(context, isDesktop: true),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (article.imageUrl != null)
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  article.imageUrl!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: _buildBookmarkIcon(context),
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildTextContent(context, isDesktop: false),
        ),
      ],
    );
  }

  Widget _buildTextContent(BuildContext context, {required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          article.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          article.content,
          maxLines: isDesktop ? 4 : 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        Text(
          '${article.date ?? ''} ${article.time ?? ''}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBookmarkIcon(BuildContext context) {
    final provider = Provider.of<BookmarkProvider>(context);
    final isBookmarked = provider.isBookmarked(article);

    return GestureDetector(
      onTap: () => provider.toggleBookmark(article),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(6),
        child: Icon(
          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}