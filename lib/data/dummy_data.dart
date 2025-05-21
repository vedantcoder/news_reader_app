import '../models/news_article.dart';

final List<NewsArticle> dummyArticles = [
  NewsArticle(
    title: "AI Takes Over the World?",
    content: "Experts debate the future of artificial intelligence in society.",
    category: "Technology",
    isLong: false,
    isTrending: true,
  ),
  NewsArticle(
    title: "Global Markets Rally",
    content: "Markets see significant gains after interest rate cuts.",
    category: "Finance",
    isLong: true,
    isTrending: false,
  ),
  NewsArticle(
    title: "Mars Mission Announced",
    content: "NASA plans to send astronauts to Mars by 2035.",
    category: "Science",
    isLong: false,
    isTrending: true,
  ),
  NewsArticle(
    title: "Olympics 2024 Preview",
    content: "Here's what to expect from the upcoming Olympic Games.",
    category: "Sports",
    isLong: true,
    isTrending: false,
  ),
];
