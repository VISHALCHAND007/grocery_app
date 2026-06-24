import 'package:flutter/material.dart';
import 'package:shopping_list/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Groceries App',
      theme: ThemeData.dark().copyWith(
        colorScheme: .fromSeed(
          seedColor: const Color.from(
            alpha: 255,
            red: 147,
            green: 229,
            blue: 250,
          ),
          brightness: .dark,
          surface: const Color.fromARGB(255, 42, 51, 59),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
      ),
      home: const HomeScreen(),
    );
  }
}
