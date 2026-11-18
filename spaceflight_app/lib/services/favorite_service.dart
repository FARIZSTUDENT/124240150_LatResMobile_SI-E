import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/article.dart';

class FavoriteService extends ChangeNotifier {
  FavoriteService._();
  static final FavoriteService instance = FavoriteService._();

  final List<Article> _items = [];
  String? _username;

  List<Article> get items => List.unmodifiable(_items);

  String get _prefsKey => 'favorites_$_username';

  Future<void> load(String username) async {
    _username = username;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    _items.clear();
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      _items.addAll(
          list.map((e) => Article.fromStored(e as Map<String, dynamic>)));
    }
    notifyListeners();
  }

  bool isFavorite(Article a) => _items.any((e) => e.key == a.key);

  Future<bool> toggle(Article a) async {
    final exists = isFavorite(a);
    if (exists) {
      _items.removeWhere((e) => e.key == a.key);
    } else {
      _items.insert(0, a);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _prefsKey, jsonEncode(_items.map((e) => e.toJson()).toList()));
    return !exists;
  }

  void clear() {
    _items.clear();
    _username = null;
    notifyListeners();
  }
}
