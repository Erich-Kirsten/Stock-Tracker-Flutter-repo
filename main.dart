import 'package:flutter/material.dart';
import 'Screens/auth_page.dart';
import 'Screens/navigation_controller.dart';
import 'Screens/news_page.dart';
import 'models/user_details.dart';
import 'Screens/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockTrack App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),         
        '/login': (context) => const AuthPage(),
        '/news': (context) {
          // final args = ModalRoute.of(context)!.settings.arguments as UserDetails;
          return NavigationController();
        },
      },
    );
  }
}
