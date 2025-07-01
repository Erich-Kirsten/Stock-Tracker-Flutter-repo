import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../firebase_options.dart';
import '../../models/user_details.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});


  @override
  State<SplashPage> createState() => _SplashPageState();
}


class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }


  Future<void> _initApp() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );


    final user = FirebaseAuth.instance.currentUser;
    await Future.delayed(const Duration(seconds: 1)); // Optional delay


    if (!mounted) return;


    if (user != null) {
      Navigator.pushReplacementNamed(
        context,
        '/news',
        arguments: UserDetails(
          email: user.email ?? '',
          uid: user.uid,
        ),
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}


