import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/stock_info.dart';
import '../Services/finnhub_service.dart';
import 'market_selection_page.dart';
import 'buy_page.dart';
import 'watchlist_page.dart' show StockQuote;

class TradePage extends StatefulWidget {
  const TradePage({super.key});

  @override
  State<TradePage> createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  List<StockInfo> allMarketStocks = [];
  final String _apiKey = '';

  @override
  void initState() {
    super.initState();
    _loadAllMarketStocks();
  }

  Future<void> _loadAllMarketStocks() async {
    const symbols = {
      "AAPL": "Apple",
      "TSLA": "Tesla",
      "AMZN": "Amazon",
      "GOOGL": "Google",
      "MSFT": "Microsoft",
      "NVDA": "NVIDIA",
      "META": "Meta",
      "INTC": "Intel",
      "CRM": "Salesforce"
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

  void _addHolding() async {
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

    if (selectedSymbol != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BuyPage(symbol: selectedSymbol),
        ),
      ).then((result) {
        if (result == true) {
          setState(() {});
        }
      });
    }
  }

  void _goToBuyPage(String symbol) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BuyPage(symbol: symbol),
      ),
    ).then((result) {
      if (result == true) {
        setState(() {});
      }
    });
  }

  void _showHistory() {
    final history = PurchaseHistoryManager.getAll();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Purchase History"),
        content: SizedBox(
          width: double.maxFinite,
          child: history.isEmpty
              ? const Text("No purchase history yet.")
              : ListView.builder(
            shrinkWrap: true,
            itemCount: history.length,
            itemBuilder: (context, index) {
              final h = history[index];
              return ListTile(
                leading: const Icon(Icons.shopping_cart_checkout),
                title: Text("${h.symbol} - \$${h.amount.toStringAsFixed(2)}"),
                subtitle: Text(
                  "${h.quantity.toStringAsFixed(2)} shares • ${h.method}\n${h.time.toLocal().toString().split('.')[0]}",
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final holdings = HoldingManager.getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trade Center'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('Your Holdings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: holdings.isEmpty
                ? const Center(child: Text("No holdings yet."))
                : ListView.builder(
              itemCount: holdings.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final h = holdings[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading:
                    const Icon(Icons.account_balance_wallet_outlined),
                    title: Text(h.symbol),
                    subtitle: Text(
                        "Qty: ${h.quantity.toStringAsFixed(3)} • \$${h.totalAmount.toStringAsFixed(2)}"),
                    trailing: Text(h.method,
                        style: const TextStyle(color: Colors.grey)),
                    onTap: () => _goToBuyPage(h.symbol),
                    onLongPress: () => _confirmDelete(h.symbol),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton(
              heroTag: 'history',
              onPressed: _showHistory,
              child: const Icon(Icons.history),
              tooltip: "View Purchase History",
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton.extended(
              heroTag: 'add',
              onPressed: _addHolding,
              label: const Text("Add Stock"),
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String symbol) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Remove $symbol?"),
        content: const Text("Do you want to remove this stock from holdings?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                HoldingManager.remove(symbol);
              });
              Navigator.pop(context);
            },
            child: const Text("Remove"),
          )
        ],
      ),
    );
  }
}

class Holding {
  final String symbol;
  final double quantity;
  final double totalAmount;
  final String method;

  Holding({required this.symbol, required this.quantity, required this.totalAmount, required this.method});
}

class HoldingManager {
  static final List<Holding> _holdings = [];

  static void addHolding(Holding h) {
    final index = _holdings.indexWhere((e) => e.symbol == h.symbol);
    if (index >= 0) {
      final existing = _holdings[index];
      _holdings[index] = Holding(
        symbol: h.symbol,
        quantity: existing.quantity + h.quantity,
        totalAmount: existing.totalAmount + h.totalAmount,
        method: h.method,
      );
    } else {
      _holdings.add(h);
    }
  }

  static List<Holding> getAll() => _holdings;

  static void remove(String symbol) {
    _holdings.removeWhere((h) => h.symbol == symbol);
  }

  static bool contains(String symbol) {
    return _holdings.any((h) => h.symbol == symbol);
  }
}

class Purchase {
  final String symbol;
  final double amount;
  final double quantity;
  final String method;
  final DateTime time;

  Purchase({required this.symbol, required this.amount, required this.quantity, required this.method, required this.time});
}

class PurchaseHistoryManager {
  static final List<Purchase> _history = [];

  static void add(Purchase p) => _history.add(p);
  static List<Purchase> getAll() => _history.reversed.toList();
}
