import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weatherapp/view/splash_screen.dart';
import 'package:weatherapp/view/home_weather.dart';
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
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Kalau masih loading Firebase Auth
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          // Kalau sudah login → langsung ke Home
          if (snapshot.hasData) {
            return const HomeWeatherScreen();
          }

          // Kalau belum login → tetap Splash → LoginScreen nanti
          return const SplashScreen();
        },
      ),
    );
  }
}
