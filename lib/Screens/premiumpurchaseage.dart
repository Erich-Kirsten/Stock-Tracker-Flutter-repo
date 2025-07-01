import 'package:flutter/material.dart';
import 'package:stoktrack1/Screens/purchase_confirmation_page.dart';

class PremiumPurchasePage extends StatelessWidget {
  const PremiumPurchasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Membership'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0E0E0), Color(0xFFFAFAFA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PlanCard(
                icon: Icons.verified,
                iconColor: Colors.orange,
                title: 'Monthly Plan',
                price: '\$9.99 / month',
                features: const [
                  'Cancel anytime',
                  'Real-time Alerts',
                  'Basic Forecasts',
                ],
                buttonColor: Colors.orange,
              ),
              const SizedBox(height: 16),
              _PlanCard(
                icon: Icons.star,
                iconColor: Colors.green,
                title: 'Yearly Plan',
                price: '\$79.99 / year',
                features: const [
                  'Save 33% yearly',
                  'Priority Updates',
                  'All Monthly Benefits',
                ],
                buttonColor: Colors.green,
              ),
              const SizedBox(height: 16),
              _PlanCard(
                icon: Icons.workspace_premium,
                iconColor: Colors.redAccent,
                title: 'Lifetime Access',
                price: '\$149.99 one-time',
                features: const [
                  'One-time payment',
                  'All premium features forever',
                  'Exclusive badge',
                ],
                buttonColor: Colors.redAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String price;
  final List<String> features;
  final Color buttonColor;

  const _PlanCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.price,
    required this.features,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
              const Spacer(),
              Text(price,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  )),
            ],
          ),
          const SizedBox(height: 12),
          ...features.map((feature) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.5),
            child: Row(
              children: [
                const Icon(Icons.check_circle, size: 16, color: Colors.green),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    feature,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 14),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PurchaseConfirmationPage(
                      planName: title,
                      price: price,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Buy Now'),
            ),
          ),
        ],
      ),
    );
  }
}
