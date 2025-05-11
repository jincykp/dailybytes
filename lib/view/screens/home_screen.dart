import 'package:dailybytes/viewmodel/article_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Fetch articles when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ArticleProvider>(context, listen: false).fetchArticles();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArticleProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Daily Bytes",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.article), text: 'Articles'),
            Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search articles...',
                prefixIcon: Icon(Icons.search),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            provider.searchArticles('');
                          },
                          child: Icon(Icons.clear),
                        )
                        : null,
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                provider.searchArticles(value);
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildArticleList(provider, false),
                _buildArticleList(provider, true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleList(ArticleProvider provider, bool favoritesOnly) {
    final articles =
        favoritesOnly ? provider.favoriteArticles : provider.articles;

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(provider.error),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.fetchArticles(),
              child: Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              favoritesOnly ? Icons.favorite_border : Icons.article_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              favoritesOnly ? 'No favorite articles yet' : 'No articles found',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.fetchArticles(),
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return _buildArticleCard(article, context, provider);
        },
      ),
    );
  }

  Widget _buildArticleCard(
    article,
    BuildContext context,
    ArticleProvider provider,
  ) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailScreen(article: article)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      article.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      provider.isFavorite(article.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color:
                          provider.isFavorite(article.id)
                              ? Colors.red
                              : Colors.grey,
                    ),
                    onPressed: () {
                      provider.toggleFavorite(article);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                article.body,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
