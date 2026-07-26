import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spider_panel/theme/app_theme.dart';
import 'package:spider_panel/providers/auth_provider.dart';
import 'package:spider_panel/screens/widgets/glass_card.dart';

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  List<Map<String, dynamic>> _news = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final api = ref.read(apiServiceProvider);
      final newsItems = await api.getNews();
      
      final news = newsItems.map((item) => {
        'title': item.title,
        'description': item.description ?? '',
        'imageUrl': item.imageUrl,
        'url': item.url,
        'publishedAt': item.publishedAt ?? '',
        'fetchedAt': item.fetchedAt,
      }).toList();

      setState(() {
        _news = news;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = ref.watch(customThemeProvider);
    final neonColor = AppTheme.neonColors[customTheme]['primary']!;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0F0F1A),
            const Color(0xFF1A1A2E),
            const Color(0xFF16213E),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'News',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadNews,
              tooltip: 'Refresh',
            ),
          ],
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 64, color: Colors.white38),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load news',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _error!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white38,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _loadNews,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _news.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.newspaper_outlined, size: 64, color: Colors.white38),
                              const SizedBox(height: 16),
                              Text(
                                'No news available',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadNews,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _news.length,
                            itemBuilder: (context, index) {
                              final newsItem = _news[index];
                              return GlassCard(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (newsItem['imageUrl'] != null &&
                                        (newsItem['imageUrl'] as String).isNotEmpty)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          newsItem['imageUrl'],
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              height: 150,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    neonColor.withOpacity(0.2),
                                                    neonColor.withOpacity(0.05),
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Icon(
                                                Icons.image,
                                                color: neonColor.withOpacity(0.3),
                                                size: 48,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    if (newsItem['imageUrl'] != null &&
                                        (newsItem['imageUrl'] as String).isNotEmpty)
                                      const SizedBox(height: 12),
                                    Text(
                                      newsItem['title'] ?? 'Untitled',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    if ((newsItem['description'] as String?).isNotEmpty)
                                      Text(
                                        newsItem['description'],
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: Colors.white70,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (newsItem['publishedAt'] != null &&
                                            (newsItem['publishedAt'] as String).isNotEmpty)
                                          Row(
                                            children: [
                                              Icon(Icons.access_time, size: 14, color: Colors.white38),
                                              const SizedBox(width: 4),
                                              Text(
                                                newsItem['publishedAt'],
                                                style: theme.textTheme.bodySmall?.copyWith(
                                                  color: Colors.white38,
                                                ),
                                              ),
                                            ],
                                          ),
                                        Icon(
                                          Icons.open_in_new,
                                          size: 16,
                                          color: neonColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ).animate().fadeIn(
                                delay: Duration(milliseconds: index * 100),
                              ).slideY(begin: 0.2, end: 0);
                            },
                          ),
                        ),
        ),
      ),
    );
  }
}