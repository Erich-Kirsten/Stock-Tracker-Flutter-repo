import 'package:flutter/material.dart';
import '../models/user_details.dart';
import 'news_page.dart';
import 'news_snapshot_page.dart';
import 'watchlist_page.dart';
import 'trade_page.dart';
import 'premium_page.dart';
import 'market_page.dart';

class NavigationController extends StatefulWidget {
  const NavigationController({super.key});

  @override
  State<NavigationController> createState() => _NavigationControllerState();
}

class _NavigationControllerState extends State<NavigationController> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as UserDetails;

    final List<Widget> _pages = [
      NewsPage(user: user),
      MarketPage(),
      WatchlistPage(),
      const TradePage(),
      const PremiumPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.article), label: "News"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Market"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: "Watchlist"),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: "Trade"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Premium"),
        ],
      ),
    );
  }
}
