import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'trade_page.dart';




class BuyPage extends StatefulWidget {
  final String symbol;
  const BuyPage({super.key, required this.symbol});

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedMethod = 'Google Pay';
  double? _currentPrice;
  double? _changePercent;
  bool _agreed = false;
  double _balance = 5000.00;
  double _feeRate = 0.01;

  final List<Map<String, String>> _paymentMethods = [
    {'label': 'Google Pay', 'icon': 'assets/icons/google_pay.png'},
    {'label': 'Bank Transfer', 'icon': 'assets/icons/bank.png'},
    {'label': 'Crypto Wallet', 'icon': 'assets/icons/crypto.png'},
  ];

  @override
  void initState() {
    super.initState();
    _loadQuote();
  }

  void _loadQuote() async {
    const apiKey = '';
    final url = Uri.parse('');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _currentPrice = data['c']?.toDouble();
        final double open = data['o']?.toDouble() ?? 0;
        _changePercent = open != 0 ? ((_currentPrice! - open) / open) * 100 : 0;
      });
    }
  }

  void _confirmPurchase() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || !_agreed || _currentPrice == null) return;

    final qty = amount / _currentPrice!;
    final totalCost = amount + (amount * _feeRate);

    // Add to holding manager
    HoldingManager.addHolding(Holding(
      symbol: widget.symbol,
      quantity: qty,
      totalAmount: totalCost,
      method: _selectedMethod,
    ));

    // Add to purchase history
    PurchaseHistoryManager.add(Purchase(
      symbol: widget.symbol,
      amount: amount,
      quantity: qty,
      method: _selectedMethod,
      time: DateTime.now(),
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Purchased \$${amount.toStringAsFixed(2)} of ${widget.symbol} via $_selectedMethod"),
      ),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    double amountValue = double.tryParse(_amountController.text) ?? 0;
    double fee = amountValue * _feeRate;
    double totalCost = amountValue + fee;
    double estimatedQty = (_currentPrice != null && _currentPrice! > 0)
        ? amountValue / _currentPrice!
        : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Stock'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: ListTile(
                  title: Text(widget.symbol,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Current Price: \$${_currentPrice?.toStringAsFixed(2) ?? '--'}"),
                  trailing: Text(
                    _changePercent != null ? "${_changePercent!.toStringAsFixed(2)}%" : "--",
                    style: TextStyle(
                      color: (_changePercent ?? 0) < 0 ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text("Available Balance: \$${_balance.toStringAsFixed(2)}",
                  style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Amount (USD)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 8),
              if (_currentPrice != null && amountValue > 0)
                Text("Estimated Quantity: ${estimatedQty.toStringAsFixed(3)} shares",
                    style: const TextStyle(color: Colors.black87)),
              const SizedBox(height: 8),
              Text("Transaction Fee (1%): \$${fee.toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Text("Total Cost: \$${totalCost.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 20),
              const Text("Payment Method", style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  value: _selectedMethod,
                  isExpanded: true,
                  underline: const SizedBox(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMethod = value!;
                    });
                  },
                  items: _paymentMethods
                      .map((method) => DropdownMenuItem<String>(
                    value: method['label'],
                    child: Row(
                      children: [
                        if (method['icon'] != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: Image.asset(
                                method['icon']!,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Icon(Icons.payment, size: 20),
                              ),
                            ),
                          ),
                        Text(method['label']!),
                      ],
                    ),
                  ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),
              CheckboxListTile(
                value: _agreed,
                onChanged: (value) {
                  setState(() {
                    _agreed = value!;
                  });
                },
                title: const Text("I agree to the terms and conditions."),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _agreed ? _confirmPurchase : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Confirm Purchase"),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Buying \$${_amountController.text} of ${widget.symbol} via $_selectedMethod",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }
}
