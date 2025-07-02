import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weatherapp/utils/colors_util.dart';
import 'package:weatherapp/view/homeWeater.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeWeatherScreen(),));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [FirstColors, LastColor],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', width: 150, height: 150),
            SizedBox(height: 10),
            Text(
              'GO CHECK YOUR\n WEATHER NOW',
              style: TextStyle(color: FirstColors,fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
