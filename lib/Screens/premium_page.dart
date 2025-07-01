import 'package:flutter/material.dart';
import 'package:stoktrack1/Screens/premiumpurchaseage.dart';
import 'package:stoktrack1/Screens/auth_page.dart'; // ✅ Added AuthPage import

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 🎨 Silver gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0E0E0), Color(0xFFBDBDBD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔍 Search bar
                Row(
                  children: [
                    const Icon(Icons.menu, color: Colors.black),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: const TextStyle(color: Colors.black54),
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.95),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
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
                        backgroundColor: Colors.orange,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 👤 User activation card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.account_circle, size: 40),
                      const SizedBox(width: 12),
                      const Expanded(child: Text("User ID")),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PremiumPurchasePage(), // Navigate to purchase page
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Activate now"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 📊 Market Insights
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Market Insights", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextButton(onPressed: () {}, child: const Text("More")),
                  ],
                ),
                const SizedBox(height: 4),
                const Text("Providing selected investment guidelines"),
                const SizedBox(height: 16),

                const _FeatureCardGrid(),

                const SizedBox(height: 24),

                // 🧠 Smart Decision Helper
                const Text("Smart Decision Helper", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text("Even newbies can understand AI stock picking"),

                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: const [
                    _LevelButton("Shanghai-Shenzhen Level-2"),
                    _LevelButton("Hong Kong Level-2"),
                    _LevelButton("Golden Trade Picks"),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 🧱 Feature card grid (with icons)
class _FeatureCardGrid extends StatelessWidget {
  const _FeatureCardGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _FeatureCard("Stock Picker", "Track institutional moves.\nFind hot stocks.", Icons.trending_up),
        _FeatureCard("Flash Alerts", "Fast-format signals in real time.", Icons.flash_on),
        _FeatureCard("Limit-Up Forecast", "Capture limit-up early.", Icons.show_chart),
        _FeatureCard("Midday Bull Radar", "Real-time big signal alerts.", Icons.radar),
      ],
    );
  }
}

// 📦 Single feature card (with icon + shadow + compact layout)
class _FeatureCard extends StatelessWidget {
  final String title, desc;
  final IconData icon;
  const _FeatureCard(this.title, this.desc, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: Icon(icon, color: Colors.black87),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(desc,
                    style: const TextStyle(fontSize: 11, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 🎖️ Level feature buttons
class _LevelButton extends StatelessWidget {
  final String label;
  const _LevelButton(this.label);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      child: Text(label),
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
