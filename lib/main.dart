import 'package:flutter/material.dart';
import 'package:naviindus/services/api_service.dart';
import 'package:naviindus/services/select_notifier.dart';
import 'package:naviindus/views/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ApiService(),
        ),
        ChangeNotifierProvider(
          create: (context) => SelectedNotifier(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Naviindus',
        home: SplashScreen(),
      ),
    );
  }
}
