import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/article.dart';

class ApiService {
  static const _base = 'https://api.spaceflightnewsapi.net/v4';

  static Future<List<Article>> fetchList(String type, {int limit = 50}) async {
    final res = await http
        .get(Uri.parse('$_base/$type/?limit=$limit'))
        .timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat data (${res.statusCode})');
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final results = json['results'] as List;
    return results
        .map((e) => Article.fromJson(e as Map<String, dynamic>, type))
        .toList();
  }

  static Future<Article> fetchDetail(String type, int id) async {
    final res = await http
        .get(Uri.parse('$_base/$type/$id/'))
        .timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat detail (${res.statusCode})');
    }
    return Article.fromJson(jsonDecode(res.body) as Map<String, dynamic>, type);
  }
}
