import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

const String kAppVersion = '1.0 beta';

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
    );
  }
}
