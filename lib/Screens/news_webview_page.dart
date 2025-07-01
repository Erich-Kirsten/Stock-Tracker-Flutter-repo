import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebViewPage extends StatefulWidget {
  final String url;

  const NewsWebViewPage({super.key, required this.url});

  @override
  State<NewsWebViewPage> createState() => _NewsWebViewPageState();
}

class _NewsWebViewPageState extends State<NewsWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            print("🟡 Page loading: $url");
            setState(() => _isLoading = true);
          },
          onPageFinished: (url) {
            print("✅ Page loaded: $url");
            setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
            print("❌ Failed to load: ${error.description}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("⚠️ Failed to load: ${error.description}")),
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News Detail"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
