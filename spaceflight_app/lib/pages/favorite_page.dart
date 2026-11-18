import 'package:flutter/material.dart';

import '../services/favorite_service.dart';
import '../widgets/article_tile.dart';
import 'detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite')),
      body: ListenableBuilder(
        listenable: FavoriteService.instance,
        builder: (context, _) {
          final items = FavoriteService.instance.items;
          if (items.isEmpty) {
            return const Center(child: Text('Belum ada favorite.'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final a = items[i];
              return ArticleTile(
                article: a,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => DetailPage(initial: a))),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () => FavoriteService.instance.toggle(a),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
