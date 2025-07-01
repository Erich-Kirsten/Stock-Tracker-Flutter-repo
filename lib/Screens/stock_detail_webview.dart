import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StockDetailWebviewPage extends StatelessWidget {
  final String stockSymbol;

  const StockDetailWebviewPage({super.key, required this.stockSymbol});

  @override
  Widget build(BuildContext context) {
    final String url = 'https://www.tradingview.com/symbols/$stockSymbol';

    return Scaffold(
      appBar: AppBar(
        title: Text('$stockSymbol Detail'),
      ),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(url)),
      ),
    );
  }
}
