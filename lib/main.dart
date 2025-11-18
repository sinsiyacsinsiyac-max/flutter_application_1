import 'package:flutter/material.dart';
import 'package:flutter_application_1/Featurs/splash/view/splash_screen.dart';

void main() {
  runApp(Myapp());

}
class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
    title:'CAMPUS IQ', 
    debugShowCheckedModeBanner: false, 
    home: SplashScreen(),
    );
  }
}