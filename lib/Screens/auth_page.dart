import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stoktrack1/firebase_options.dart';
import '../Services/firebase_service.dart';
import '../models/user_details.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _showMessageDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessageDialog("Error", "Email and password cannot be empty.");
      return;
    }

    try {
      final UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;

      if (user != null) {
        final userDetails = UserDetails(email: user.email ?? '', uid: user.uid);
        await FirebaseService().saveUserData(userDetails);
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/news', arguments: userDetails);
      }
    } catch (e) {
      _showMessageDialog("Login failed", "Please check your credentials.");
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final googleSignIn = GoogleSignIn(
        clientId: DefaultFirebaseOptions.android.appId, // Optional override
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return; // User canceled

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final userDetails = UserDetails(email: user.email ?? '', uid: user.uid);
        await FirebaseService().saveUserData(userDetails);
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/news', arguments: userDetails);
      }
    } catch (e) {
      _showMessageDialog("Google Sign-In failed", e.toString());
    }
  }



  void _showCreateAccountDialog() {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Create Account"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () async {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();
                try {
                  final UserCredential userCredential =
                  await _auth.createUserWithEmailAndPassword(email: email, password: password);
                  final user = userCredential.user;
                  if (user != null) {
                    final userDetails = UserDetails(email: user.email ?? '', uid: user.uid);
                    await FirebaseService().saveUserData(userDetails);
                    if (!mounted) return;
                    Navigator.pop(context); // Close dialog
                    Future.delayed(Duration.zero, () {
                      Navigator.pushReplacementNamed(context, '/news', arguments: userDetails);
                    });
                  }
                } catch (e) {
                  _showMessageDialog("Sign-Up Error", e.toString());
                }
              },
              child: const Text("Create")),
        ],
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Forgot Password"),
        content: TextField(controller: emailController, decoration: const InputDecoration(labelText: "Enter your email")),
        actions: [
          TextButton(
              onPressed: () async {
                final email = emailController.text.trim();
                try {
                  await _auth.sendPasswordResetEmail(email: email);
                  Navigator.pop(context);
                  _showMessageDialog("Check Your Email", "Password reset link sent.");
                } catch (e) {
                  _showMessageDialog("Error", e.toString());
                }
              },
              child: const Text("Reset")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(radius: 40, backgroundColor: Colors.grey, child: Icon(Icons.person, size: 40, color: Colors.white)),
              const SizedBox(height: 30),

              TextField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder())),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text("Log in"),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: _showForgotPasswordDialog, child: const Text("Forgot password?")),
                  TextButton(onPressed: _showCreateAccountDialog, child: const Text("Create Account")),
                ],
              ),

              const Divider(height: 32),
              _buildSocialButton("Google", Icons.g_mobiledata, _handleGoogleSignIn),
              _buildSocialButton("Apple", Icons.apple, () => _showMessageDialog("Info", "Apple Sign-In not yet implemented.")),
              _buildSocialButton("E-mail", Icons.email, _handleLogin),

              const SizedBox(height: 16),
              TextButton(onPressed: () {}, child: const Text("Do you need help?")),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String label, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.black),
          label: Text("Sign in with $label", style: const TextStyle(color: Colors.black)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.black54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }
}
