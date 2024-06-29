import 'package:flutter/material.dart';
import 'package:naviindus/utils/dynamic_sizing.dart';
import 'package:naviindus/views/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(
        seconds: 2,
      ),
    ).then((value) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: R.maxHeight(context),
        width: R.maxWidth(context),
        child: Image.asset(
          "assets/splash.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
