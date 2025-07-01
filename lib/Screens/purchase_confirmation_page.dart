import 'package:flutter/material.dart';

class PurchaseConfirmationPage extends StatefulWidget {
  final String planName;
  final String price;

  const PurchaseConfirmationPage({
    super.key,
    required this.planName,
    required this.price,
  });

  @override
  State<PurchaseConfirmationPage> createState() =>
      _PurchaseConfirmationPageState();
}

class _PurchaseConfirmationPageState extends State<PurchaseConfirmationPage> {
  String selectedPayment = 'Credit Card';
  bool agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Your Purchase"),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧾 会员方案卡片美化
            Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.verified, color: Colors.orange, size: 36),
                    const SizedBox(height: 10),
                    Text(widget.planName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(widget.price,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
            const Text("Choose Payment Method",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            ...["Credit Card", "PayPal", "Apple Pay", "Google Pay"]
                .map((method) => RadioListTile(
              title: Text(method),
              value: method,
              groupValue: selectedPayment,
              onChanged: (value) {
                setState(() {
                  selectedPayment = value!;
                });
              },
            )),

            const SizedBox(height: 16),
            const Text("Purchase Notes",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 4),
            const Text(
              "• One-time payment. No auto-renewal.\n"
                  "• Non-refundable after purchase.\n"
                  "• All features activated instantly after payment.",
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: agreedToTerms,
                  onChanged: (value) {
                    setState(() {
                      agreedToTerms = value!;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    "I agree to the purchase terms.",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Center(
              child: ElevatedButton.icon(
                onPressed: agreedToTerms
                    ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Processing payment...")),
                  );
                }
                    : null,
                icon: const Icon(Icons.lock),
                label: const Text("Confirm & Pay"),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  agreedToTerms ? Colors.black : Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            const Center(
              child: Text("Secure payment protected",
                  style: TextStyle(color: Colors.green)),
            ),
          ],
        ),
      ),
    );
  }
}
