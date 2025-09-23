import 'package:flutter/material.dart';
import 'screens/timer_screen.dart';

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
      home: const TimerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
