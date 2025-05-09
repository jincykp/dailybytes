import 'package:dailybytes/model/article_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArticleProvider with ChangeNotifier {
  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  bool _isLoading = false;
  String _error = '';

  List<Article> get articles => _filteredArticles;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchArticles() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        _articles = data.map((json) => Article.fromJson(json)).toList();
        _filteredArticles = _articles;
        _error = '';
      } else {
        _error = 'Failed to load articles';
      }
    } catch (e) {
      _error = 'Something went wrong: $e';
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
