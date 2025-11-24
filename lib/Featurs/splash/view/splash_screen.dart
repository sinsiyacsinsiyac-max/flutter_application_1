import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Featurs/auth/view/login_screen.dart';
import 'package:flutter_application_1/Featurs/firebase_serviece/firebase.dart';
import 'package:flutter_application_1/Featurs/admin/home/home_screen.dart';
import 'package:flutter_application_1/Featurs/college/college_dashboard.dart';
import 'package:flutter_application_1/Featurs/home/view/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    _checkCurrentUser();
    super.initState();
  }

  Future<void> _checkCurrentUser() async {
    // Wait for 3 seconds for splash screen
    await Future.delayed(const Duration(seconds: 3));

    // Check if user is already logged in
    final currentUser = _authService.currentUser;
    
    if (currentUser != null) {
      // User is logged in, check their role and navigate accordingly
      try {
        final role = await _authService.getUserRole(currentUser.uid);
        _navigateBasedOnRole(role);
      } catch (e) {
        // If there's an error getting role, go to login
        _navigateToLogin();
      }
    } else {
      // No user is logged in, go to login screen
      _navigateToLogin();
    }
  }

  void _navigateBasedOnRole(String? role) {
    switch (role) {
      case 'admin':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
          (route) => false,
        );
        break;
      case 'teacher':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const CollegeHomeScreen()),
          (route) => false,
        );
        break;
      case 'user':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ChatbotHomePage()),
          (route) => false,
        );
        break;
      default:
        // If role is null or unknown, go to login
        _navigateToLogin();
        break;
    }
  }

  void _navigateToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade700,
              Colors.blue.shade500,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Image.asset('assets/images/logo.png',height: 30,width: 30
              ,)
            ),
            const SizedBox(height: 30),
            
            // App Name
            const Text(
              'College Assistant',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            
            // Tagline
            Text(
              'Smart Campus Management',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 50),
            
            // Loading Indicator
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            
            // Loading Text
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}