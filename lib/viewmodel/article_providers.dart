import 'package:dailybytes/model/article_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ArticleProvider with ChangeNotifier {
  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  Set<int> _favoriteIds = {};
  bool _isLoading = false;
  String _error = '';

  List<Article> get articles => _filteredArticles;
  List<Article> get favoriteArticles =>
      _filteredArticles
          .where((article) => _favoriteIds.contains(article.id))
          .toList();
  bool get isLoading => _isLoading;
  String get error => _error;

  ArticleProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = prefs.getStringList('favorites') ?? [];
      _favoriteIds = favorites.map((id) => int.parse(id)).toSet();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = _favoriteIds.map((id) => id.toString()).toList();
      await prefs.setStringList('favorites', favorites);
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  bool isFavorite(int id) {
    return _favoriteIds.contains(id);
  }

  void toggleFavorite(Article article) {
    if (_favoriteIds.contains(article.id)) {
      _favoriteIds.remove(article.id);
    } else {
      _favoriteIds.add(article.id);
    }
    _saveFavorites();
    notifyListeners();
  }

  Future<void> fetchArticles() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        _articles = data.map((json) => Article.fromJson(json)).toList();
        _filteredArticles = _articles;
      } else {
        _error = 'Failed to load articles (Status: ${response.statusCode})';
      }
    } catch (e) {
      _error = 'Network error: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }

  void searchArticles(String query) {
    if (query.isEmpty) {
      _filteredArticles = _articles;
    } else {
      _filteredArticles =
          _articles.where((article) {
            return article.title.toLowerCase().contains(query.toLowerCase()) ||
                article.body.toLowerCase().contains(query.toLowerCase());
          }).toList();
    }
    notifyListeners();
  }
}
