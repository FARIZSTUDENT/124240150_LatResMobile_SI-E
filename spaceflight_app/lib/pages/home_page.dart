import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/favorite_service.dart';
import 'list_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    FavoriteService.instance.load(widget.username);
  }

  Future<void> _logout() async {
    await AuthService.logout();
    FavoriteService.instance.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hai, ${widget.username}!'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _MenuCard(
            icon: Icons.newspaper,
            title: 'News',
            desc:
                'Get an overview of the latest SpaceFlight news, from various sources! Easily link your users to the right websites.',
            onTap: () => _open('articles', 'News'),
          ),
          _MenuCard(
            icon: Icons.article_outlined,
            title: 'Blog',
            desc:
                'Blogs often provide a more detailed overview of launches and missions. A must-have for the serious spaceflight enthusiast.',
            onTap: () => _open('blogs', 'Blog'),
          ),
          _MenuCard(
            icon: Icons.bar_chart,
            title: 'Reports',
            desc:
                'Space stations and other missions often publish their data. With SNAPI, you can include it in your app.',
            onTap: () => _open('reports', 'Reports'),
          ),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: _logout,
              child: const Text('Log Out'),
            ),
          ),
        ],
      ),
    );
  }

  void _open(String type, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ListPage(type: type, title: title)),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.purple, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(desc,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
