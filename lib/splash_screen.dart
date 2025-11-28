import 'package:flutter/material.dart';
import 'main.dart';
import 'timer_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
   void _goToTimer() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const TimerScreen()),
    );
  }
  @override
  //void initState() {
  //  super.initState();
    // Navigate to timer screen after 3 seconds
 //   Future.delayed(const Duration(seconds: 3), () {
 //     if (mounted) {
//Navigator.of(context).pushReplacement(
 //         MaterialPageRoute(builder: (context) => const TimerScreen()),
 //       );
 //     }
 //   });
 // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Main MilliTimer logo
            const Text(
              'MilliTimer',
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 8),
            // Version text
            Text(
              kAppVersion,
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey[400],
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 20),
            // By Adaminion text
            Text(
              'by Adaminion',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
                fontWeight: FontWeight.w300,
              ),
            ),
const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _goToTimer,
              child: const Text(
                '⚠️ Use the highest screen refresh rate \nbefore recording videos! \n\n Now click me to start MilliTimer!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}