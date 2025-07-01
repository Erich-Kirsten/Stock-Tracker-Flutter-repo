import 'package:flutter/material.dart';
import 'location_helper.dart';
import '../Services/finnhub_service.dart';
import '../models/stock_info.dart';
import 'stock_detail_webview.dart';
import 'auth_page.dart'; // AuthPage 的导入

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  int selectedCategoryIndex = 0;
  String _country = 'Loading...';
  double _latitude = 0.0;
  double _longitude = 0.0;

  final List<String> categories = [
    "Top Techs",
    "Crypto Markets",
    "U.S. Stocks",
    "Local Market",
  ];

  List<StockInfo> _usStocks = [];
  List<StockInfo> _topTechs = [];
  List<StockInfo> _cryptoMarkets = [];
  List<StockInfo> _localMarketStocks = [];
  bool _loadingStocks = true;

  @override
  void initState() {
    super.initState();
    _getLocationData();
    _loadStocks();
  }

  Future<void> _getLocationData() async {
    final data = await LocationHelper.getLocationData();
    setState(() {
      _country = data.country;
      _latitude = data.latitude;
      _longitude = data.longitude;
    });
  }

  Future<void> _loadStocks() async {
    setState(() => _loadingStocks = true);

    final usSymbols = {
      "AAPL": "Apple",
      "TSLA": "Tesla",
      "AMZN": "Amazon",
      "GOOGL": "Google",
      "MSFT": "Microsoft"
    };

    final topTechsSymbols = {
      "NVDA": "NVIDIA",
      "META": "Meta",
      "INTC": "Intel",
      "CRM": "Salesforce",
      "ADBE": "Adobe"
    };

    final cryptoSymbols = {
      "BINANCE:BTCUSDT": "Bitcoin",
      "BINANCE:ETHUSDT": "Ethereum",
      "BINANCE:SOLUSDT": "Solana",
      "BINANCE:BNBUSDT": "BNB",
      "BINANCE:XRPUSDT": "XRP"
    };

    List<StockInfo> usList = [];
    List<StockInfo> techList = [];
    List<StockInfo> cryptoList = [];

    for (var entry in usSymbols.entries) {
      final info = await FinnhubService.fetchStockQuote(entry.key, entry.value);
      if (info != null) usList.add(info);
      await Future.delayed(const Duration(milliseconds: 900));
    }

    for (var entry in topTechsSymbols.entries) {
      final info = await FinnhubService.fetchStockQuote(entry.key, entry.value);
      if (info != null) techList.add(info);
      await Future.delayed(const Duration(milliseconds: 900));
    }

    for (var entry in cryptoSymbols.entries) {
      final info = await FinnhubService.fetchStockQuote(entry.key, entry.value);
      if (info != null) cryptoList.add(info);
      await Future.delayed(const Duration(milliseconds: 900));
    }

    setState(() {
      _usStocks = usList;
      _topTechs = techList;
      _cryptoMarkets = cryptoList;
      _loadingStocks = false;
    });
  }

  Future<void> _loadLocalMarketStocks() async {
    setState(() => _loadingStocks = true);

    final countrySymbols = {
      "United States": {
        "WMT": "Walmart",
        "KO": "Coca-Cola"
      },
      "Germany": {
        "BMW.DE": "BMW",
        "VOW3.DE": "Volkswagen",
        "DAI.DE": "Mercedes-Benz",
        "SAP.DE": "SAP",
        "BAS.DE": "BASF",
        "DBK.DE": "Deutsche Bank",
        "LIN.DE": "Linde",
        "ADS.DE": "Adidas"
      },
      "Japan": {
        "7203.T": "Toyota",
        "6758.T": "Sony"
      },
      "China": {
        "BABA": "Alibaba",
        "TCEHY": "Tencent"
      }
    };

    final selectedSymbols = countrySymbols[_country] ?? {
      "AAPL": "Apple",
      "MSFT": "Microsoft"
    };

    List<StockInfo> localList = [];

    for (var entry in selectedSymbols.entries) {
      final info = await FinnhubService.fetchStockQuote(entry.key, entry.value);
      if (info != null) localList.add(info);
      await Future.delayed(const Duration(milliseconds: 900));
    }

    setState(() {
      _localMarketStocks = localList;
      _loadingStocks = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.arrow_back),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AuthPage()),
                      );
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _country == 'Loading...'
                  ? const Center(child: Padding(
                  padding: EdgeInsets.all(8), child: CircularProgressIndicator()))
                  : Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Detected Location",
                                style: TextStyle(fontSize: 13, color: Colors.grey)),
                            Text(_country,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text("Latitude: $_latitude",
                                style: const TextStyle(fontSize: 13, color: Colors.grey)),
                            Text("Longitude: $_longitude",
                                style: const TextStyle(fontSize: 13, color: Colors.grey)),
                          ],
                        ),
                      ),
                      const Icon(Icons.check_circle, color: Colors.green),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(categories.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(categories[i]),
                        selected: selectedCategoryIndex == i,
                        onSelected: (_) {
                          setState(() {
                            selectedCategoryIndex = i;
                          });
                          if (i == 3) {
                            _loadLocalMarketStocks();
                          }
                        },
                        selectedColor: Colors.black,
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          color: selectedCategoryIndex == i
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              if (_loadingStocks)
                const Center(child: CircularProgressIndicator())
              else if (selectedCategoryIndex == 0) ...[
                _sectionTitle("Top Techs"),
                _buildStockList(_topTechs),
              ] else if (selectedCategoryIndex == 1) ...[
                _sectionTitle("Crypto Markets"),
                _buildStockList(_cryptoMarkets),
              ] else if (selectedCategoryIndex == 2) ...[
                _sectionTitle("U.S. Stocks Highlights"),
                _buildStockList(_usStocks),
              ] else if (selectedCategoryIndex == 3) ...[
                _sectionTitle("Local Market: $_country"),
                _buildStockList(_localMarketStocks),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        TextButton(onPressed: () {}, child: const Text("More")),
      ],
    );
  }

  Widget _buildStockList(List<StockInfo> stocks) {
    return Column(
      children: stocks.map((stock) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StockDetailWebviewPage(stockSymbol: stock.symbol),
            ),
          );
        },
        child: _DetailedIndexBox(
          "${stock.name} (${stock.symbol})",
          stock.price?.toStringAsFixed(2) ?? 'N/A',
          stock.changePercent != null
              ? "${stock.changePercent!.toStringAsFixed(2)}%"
              : 'N/A',
          stock.isUp,
          stock.changeValue?.toStringAsFixed(2) ?? '',
          stock.low?.toStringAsFixed(2) ?? '',
          stock.high?.toStringAsFixed(2) ?? '',
          stock.volume ?? '',
        ),
      )).toList(),
    );
  }
}

class _DetailedIndexBox extends StatelessWidget {
  final String name, value, change, changeValue, low, high, volume;
  final bool isUp;

  const _DetailedIndexBox(this.name, this.value, this.change, this.isUp,
      this.changeValue, this.low, this.high, this.volume);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            children: [
              Flexible(
                  child: Text(value, style: const TextStyle(fontSize: 18))),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  change,
                  style: TextStyle(
                    color: isUp ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text("($changeValue pts)",
                    style: const TextStyle(color: Colors.grey)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Low: $low",
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text("High: $high",
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text("Vol: $volume",
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }
}
