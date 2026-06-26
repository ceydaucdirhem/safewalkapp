import 'package:flutter/material.dart';
import 'screens/splash.dart';

void main() {
  runApp(SafeWalkApp());
}

class SafeWalkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Safe Walk',
      theme: ThemeData.dark(),
      home: SplashScreen(),
    );
  }
}
