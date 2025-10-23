
import 'package:flutter/material.dart';
import 'package:kivu/style.dart';
import 'hone.dart'; // ta page principale
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Animation du logo
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    // Redirection vers la page principale après 3 secondes
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TopCongoAppScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEEA00),
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ton logo (assure-toi de l’ajouter dans /assets)
              Image.asset(
                'assets/icon.png',
                width: 190,
                height: 180,
              ),
              // const SizedBox(height: 20),
              // const Text(
              //   'KIVU STARS',
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 26,
              //     fontWeight: FontWeight.bold,
              //     letterSpacing: 2,
              //   ),
              // ),
              // const SizedBox(height: 30),
              // const CircularProgressIndicator(
              //   color: Colors.white,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
