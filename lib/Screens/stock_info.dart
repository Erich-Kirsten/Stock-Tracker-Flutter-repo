class StockInfo {
  final String symbol;
  final String name;
  final double? price;
  final double? changePercent;
  final double? changeValue;
  final double? low;
  final double? high;
  final String? volume;
  final bool isUp;

  StockInfo({
    required this.symbol,
    required this.name,
    required this.price,
    required this.changePercent,
    required this.changeValue,
    required this.low,
    required this.high,
    required this.volume,
    required this.isUp,
  });


  factory StockInfo.fromJson({
    required String symbol,
    required String name,
    required Map<String, dynamic> json,
  }) {
    final double current = (json['c'] ?? 0).toDouble();
    final double previous = (json['pc'] ?? 0).toDouble();
    final double change = current - previous;
    final double percent = previous != 0 ? (change / previous) * 100 : 0;

    return StockInfo(
      symbol: symbol,
      name: name,
      price: current,
      changePercent: percent,
      changeValue: change,
      low: (json['l'] ?? 0).toDouble(),
      high: (json['h'] ?? 0).toDouble(),
      volume: json['v']?.toString(),
      isUp: change >= 0,
    );
  }
}
