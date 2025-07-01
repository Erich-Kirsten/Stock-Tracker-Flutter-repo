import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/stock_info.dart';
import '../Services/finnhub_service.dart';
import 'market_selection_page.dart';
import 'stock_detail_webview.dart';
import 'auth_page.dart'; // ✅ 导入 AuthPage

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  List<String> watchSymbols = ['AAPL', 'TSLA', 'GOOGL'];
  List<StockInfo> allMarketStocks = [];
  final String _apiKey = 'd1dvr09r01qlt46rnve0d1dvr09r01qlt46rnveg';
  late Future<List<StockQuote>> _quotesFuture;

  @override
  void initState() {
    super.initState();
    _loadQuotes();
    _loadAllMarketStocks();
  }

  void _loadQuotes() {
    setState(() {
      _quotesFuture = _fetchQuotes();
    });
  }

  Future<List<StockQuote>> _fetchQuotes() async {
    List<StockQuote> quotes = [];
    for (String symbol in watchSymbols) {
      final url = Uri.parse('https://finnhub.io/api/v1/quote?symbol=$symbol&token=$_apiKey');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        quotes.add(StockQuote.fromJson(symbol, data));
      }
    }
    return quotes;
  }

  Future<void> _loadAllMarketStocks() async {
    const symbols = {
      "AAPL": "Apple", "TSLA": "Tesla", "AMZN": "Amazon",
      "GOOGL": "Google", "MSFT": "Microsoft", "NVDA": "NVIDIA",
      "META": "Meta", "INTC": "Intel", "CRM": "Salesforce"
    };

    List<StockInfo> result = [];
    for (var entry in symbols.entries) {
      final stock = await FinnhubService.fetchStockQuote(entry.key, entry.value);
      if (stock != null) result.add(stock);
      await Future.delayed(const Duration(milliseconds: 500));
    }

    setState(() {
      allMarketStocks = result;
    });
  }

  void _handleAddStock() async {
    if (allMarketStocks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Loading market data, please wait...")),
      );
      return;
    }

    final selectedSymbol = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => MarketSelectionPage(stockList: allMarketStocks),
      ),
    );

    if (selectedSymbol != null && !watchSymbols.contains(selectedSymbol)) {
      setState(() {
        watchSymbols.add(selectedSymbol);
        _loadQuotes();
      });
    }
  }

  void _confirmDelete(String symbol) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Remove $symbol?"),
        content: const Text("Do you want to remove this stock from the watchlist?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                watchSymbols.remove(symbol);
                _loadQuotes();
              });
              Navigator.pop(context);
            },
            child: const Text("Remove"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text('Watchlist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AuthPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadQuotes,
          ),
        ],
      ),
      body: FutureBuilder<List<StockQuote>>(
        future: _quotesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final quotes = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              final stock = quotes[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StockDetailWebviewPage(stockSymbol: stock.symbol),
                    ),
                  );
                },
                onLongPress: () => _confirmDelete(stock.symbol),
                child: _EnhancedStockCard(stock: stock),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleAddStock,
        icon: const Icon(Icons.add),
        label: const Text("Add Stock"),
      ),
    );
  }
}

class StockQuote {
  final String symbol;
  final double current;
  final double changePercent;
  final double low;
  final double high;
  final int volume;

  StockQuote({
    required this.symbol,
    required this.current,
    required this.changePercent,
    required this.low,
    required this.high,
    required this.volume,
  });

  factory StockQuote.fromJson(String symbol, Map<String, dynamic> json) {
    return StockQuote(
      symbol: symbol,
      current: (json['c'] ?? 0).toDouble(),
      changePercent: (json['dp'] ?? 0).toDouble(),
      low: (json['l'] ?? 0).toDouble(),
      high: (json['h'] ?? 0).toDouble(),
      volume: (json['v'] ?? 0),
    );
  }
}

class _EnhancedStockCard extends StatelessWidget {
  final StockQuote stock;

  const _EnhancedStockCard({required this.stock});

  @override
  Widget build(BuildContext context) {
    final isNegative = stock.changePercent < 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(stock.symbol, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text("\$${stock.current.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isNegative ? Colors.red[100] : Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${stock.changePercent.toStringAsFixed(2)}%",
                  style: TextStyle(
                    color: isNegative ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text("Low: \$${stock.low.toStringAsFixed(2)}"),
              const SizedBox(width: 10),
              Text("High: \$${stock.high.toStringAsFixed(2)}"),
            ],
          ),
          const SizedBox(height: 4),
          Text("Volume: ${stock.volume}"),
        ],
      ),
    );
  }
}
