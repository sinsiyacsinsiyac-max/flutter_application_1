import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Featurs/auth/view/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context) => LoginScreen(), ), (route) => false,);  
    },);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue,Colors.white,Colors.white,],begin: AlignmentGeometry.topCenter,end: AlignmentGeometry.bottomCenter)),
      child:Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo.png',height:400,width:400,),
        ]
      ),
      ),
    );
  }
}
