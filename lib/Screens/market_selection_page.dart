import 'package:flutter/material.dart';
import '../models/stock_info.dart';


class MarketSelectionPage extends StatelessWidget {
  final List<StockInfo> stockList;

  const MarketSelectionPage({super.key, required this.stockList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select a Stock to Add")),
      body: ListView.builder(
        itemCount: stockList.length,
        itemBuilder: (context, index) {
          final stock = stockList[index];
          return ListTile(
            title: Text("${stock.name} (${stock.symbol})"),
            subtitle: Text("Price: ${stock.price?.toStringAsFixed(2) ?? 'N/A'}"),
            trailing: const Icon(Icons.add_circle_outline),
            onTap: () {
              //  symbol ➡ WatchlistPage
              Navigator.pop(context, stock.symbol);
            },
          );
        },
      ),
    );
  }
}
