import 'package:flutter/material.dart';

import '../models/article.dart';

class ArticleTile extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;
  final Widget? trailing;

  const ArticleTile({
    super.key,
    required this.article,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      color: const Color(0xFFF7E8F9),
      child: ListTile(
        onTap: onTap,
        leading: _Thumb(url: article.imageUrl),
        title:
            Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(article.newsSite),
        trailing: trailing,
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  final String url;
  const _Thumb({required this.url});

  Widget _fallback() => const SizedBox(
        width: 90,
        height: 60,
        child: Icon(Icons.broken_image_outlined),
      );

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _fallback();
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.network(
        url,
        width: 90,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
        loadingBuilder: (context, child, progress) => progress == null
            ? child
            : const SizedBox(
                width: 90,
                height: 60,
                child: Center(
                    child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))),
              ),
      ),
    );
  }
}
