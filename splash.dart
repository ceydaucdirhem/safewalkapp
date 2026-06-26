import 'package:flutter/material.dart';
import 'voice_input.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => VoiceInputScreen()),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "SafeWalk",
            style: TextStyle(
              color: Colors.yellow,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}