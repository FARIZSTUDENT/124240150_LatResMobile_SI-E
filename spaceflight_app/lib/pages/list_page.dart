import 'package:flutter/material.dart';

import '../models/article.dart';
import '../services/api_service.dart';
import '../widgets/article_tile.dart';
import 'detail_page.dart';
import 'favorite_page.dart';

class ListPage extends StatefulWidget {
  final String type;
  final String title;
  const ListPage({super.key, required this.type, required this.title});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late Future<List<Article>> _future;
  String? _selectedSite;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchList(widget.type);
  }

  void _reload() {
    setState(() => _future = ApiService.fetchList(widget.type));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Favorite',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const FavoritePage())),
          ),
        ],
      ),
      body: FutureBuilder<List<Article>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Gagal memuat data. Periksa koneksi internet.'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                      onPressed: _reload, child: const Text('Coba lagi')),
                ],
              ),
            );
          }
          final all = snap.data!;
          final sites = all.map((e) => e.newsSite).toSet().toList()..sort();
          final shown = _selectedSite == null
              ? all
              : all.where((e) => e.newsSite == _selectedSite).toList();

          return Column(
            children: [
              SizedBox(
                height: 56,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  itemCount: sites.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final site = sites[i];
                    return FilterChip(
                      label: Text(site),
                      selected: _selectedSite == site,
                      onSelected: (sel) =>
                          setState(() => _selectedSite = sel ? site : null),
                    );
                  },
                ),
              ),
              Expanded(
                child: shown.isEmpty
                    ? const Center(child: Text('Tidak ada data.'))
                    : ListView.builder(
                        itemCount: shown.length,
                        itemBuilder: (_, i) => ArticleTile(
                          article: shown[i],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DetailPage(initial: shown[i])),
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
