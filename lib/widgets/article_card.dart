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
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            isDesktop ? _buildDesktopLayout(context) : _buildMobileLayout(context),
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: _buildBookmarkIcon(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        if (article.imageUrl != null)
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
            child: Image.network(
              article.imageUrl!,
              width: 160,
              height: 160,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 160,
                  height: 160,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
            ),
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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              article.imageUrl!,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
            ),
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
        _buildTags(),
        const SizedBox(height: 6),
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

  Widget _buildTags() {
    List<Widget> tags = [];

    if (article.isTrending) {
      tags.add(_buildTag('Trending', Colors.redAccent));
    }
    if (article.isLong == false) {
      tags.add(_buildTag('Short', Colors.blueAccent));
    }

    if (tags.isEmpty) return const SizedBox.shrink();

    return Row(
      children: tags
          .map((tag) => Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: tag,
      ))
          .toList(),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBookmarkIcon(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);
    final isBookmarked = bookmarkProvider.isBookmarked(article);

    return IconButton(
      icon: Icon(
        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
        color: isBookmarked ? Colors.amber[700] : Colors.grey[700],
      ),
      onPressed: () {
        bookmarkProvider.toggleBookmark(article);
      },
      tooltip: isBookmarked ? 'Remove Bookmark' : 'Add Bookmark',
    );
  }
}