import 'package:hive/hive.dart';

part 'news_model.g.dart';

@HiveType(typeId: 5)
class NewsItem extends HiveObject {
  @HiveField(0)
  String title;
  
  @HiveField(1)
  String? description;
  
  @HiveField(2)
  String? imageUrl;
  
  @HiveField(3)
  String url;
  
  @HiveField(4)
  String? publishedAt;
  
  @HiveField(5)
  String fetchedAt;

  NewsItem({
    required this.title,
    this.description,
    this.imageUrl,
    required this.url,
    this.publishedAt,
    required this.fetchedAt,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) => NewsItem(
    title: json['title'] ?? '',
    description: json['description'],
    imageUrl: json['image_url'],
    url: json['url'] ?? '',
    publishedAt: json['published_at'],
    fetchedAt: json['fetched_at'] ?? DateTime.now().toIso8601String(),
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'image_url': imageUrl,
    'url': url,
    'published_at': publishedAt,
    'fetched_at': fetchedAt,
  };
}
