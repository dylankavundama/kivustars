import 'package:flutter/material.dart';
import 'package:kivu/splash.dart';
import 'hone.dart'; // ta page principale

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KIVU STARS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF0A1B3B),
        scaffoldBackgroundColor: const Color(0xFF0A1B3B),
      ),
      home: const SplashScreen(),
    );
  }
}

