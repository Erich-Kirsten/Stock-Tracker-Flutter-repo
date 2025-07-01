import 'package:flutter/material.dart';//没用了这个页面不用管

class NewsSnapshotPage extends StatelessWidget {
  const NewsSnapshotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock Market - News Snapshot"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "📈 Today's Market Highlights",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "🔹 Tesla (TSLA) surged 4.2% amid AI partnership rumors.\n"
                  "🔹 Apple (AAPL) dipped 1.1% following supply chain concerns.\n"
                  "🔹 Bitcoin rose above \$70,000 for the first time.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}