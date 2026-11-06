// 2026-11-02
import 'package:flutter/material.dart';
import 'splash_screen.dart';

// Keep in sync with `version:` in pubspec.yaml.
const String kAppVersion = '0.2.1+12';

void main() {
  runApp(const MillitimerApp());
}

class MillitimerApp extends StatelessWidget {
  const MillitimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Millitimer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Stack(
        children: [
          ?child,
          // Top-left: the other corners hold the logo, settings button and delay indicator.
          const Positioned(
            left: 8,
            top: 4,
            child: SafeArea(
              child: IgnorePointer(
                child: Text(
                  kAppVersion,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF808080),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
