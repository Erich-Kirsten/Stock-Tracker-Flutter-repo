import '../models/news_article.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../models/user_details.dart';
import 'news_webview_page.dart';

class NewsPage extends StatefulWidget {
  final UserDetails user;
  const NewsPage({super.key, required this.user});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int selectedCategoryIndex = 0;
  bool _isLoading = true;
  List<NewsArticle> _articles = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> categories = [
    {"label": "General", "value": "general"},
    {"label": "Forex", "value": "forex"},
    {"label": "Crypto", "value": "crypto"},
    {"label": "Mergers", "value": "merger"},
  ];

  final String _apiKey = '';

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    setState(() {
      _isLoading = true;
    });

    final category = categories[selectedCategoryIndex]["value"] ?? "general";
    final url = Uri.parse('https://finnhub.io/api/v1/news?category=$category&token=$_apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final today = DateTime.now();
        final seenTitles = <String>{};

        final List<NewsArticle> articles = data
            .map((item) => NewsArticle.fromJson(item))
            .where((a) {
          final isToday = a.date.year == today.year &&
              a.date.month == today.month &&
              a.date.day == today.day;
          final notSeen = !seenTitles.contains(a.title);
          if (notSeen) seenTitles.add(a.title);
          return isToday && notSeen;
        })
            .take(50)
            .toList();

        setState(() {
          _articles = articles;
          _isLoading = false;
        });
      } else {
        throw Exception("API failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("⚠️ Fetch news error: $e");
      setState(() {
        _articles = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredArticles = _articles.where((article) {
      final query = _searchQuery.toLowerCase();
      return article.title.toLowerCase().contains(query) ||
          article.summary.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildSearchBar(),
              const SizedBox(height: 12),
              _buildCategoryChips(),
              const SizedBox(height: 12),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildNewsList(filteredArticles),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            "Welcome, ${widget.user.email}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const Icon(Icons.more_vert),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search news...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        fillColor: Colors.white,
        filled: true,
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
    );
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(categories.length, (index) {
          final isSelected = selectedCategoryIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(categories[index]["label"]!),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  selectedCategoryIndex = index;
                  _searchController.clear();
                  _searchQuery = '';
                });
                _fetchArticles();
              },
              selectedColor: Colors.black,
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNewsList(List<NewsArticle> articles) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final news = articles[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsWebViewPage(url: news.url),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        news.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        news.summary,
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${news.source} · ${DateFormat('yyyy-MM-dd').format(news.date)}",
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                news.imageUrl.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 90,
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Image.network(
                        news.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                        const Center(child: Icon(Icons.broken_image)),
                      ),
                    ),
                  ),
                )
                    : Container(
                  width: 70,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Center(child: Text("No Img")),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
