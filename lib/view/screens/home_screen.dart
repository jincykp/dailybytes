import 'package:dailybytes/viewmodel/article_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/detail_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArticleProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Articles")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(labelText: 'Search'),
              onChanged: provider.searchArticles,
            ),
          ),
          Expanded(
            child:
                provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.error.isNotEmpty
                    ? Center(child: Text(provider.error))
                    : ListView.builder(
                      itemCount: provider.articles.length,
                      itemBuilder: (context, index) {
                        final article = provider.articles[index];
                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: ListTile(
                            title: Text(article.title),
                            subtitle: Text(
                              article.body.length > 50
                                  ? '${article.body.substring(0, 50)}...'
                                  : article.body,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => DetailScreen(article: article),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
