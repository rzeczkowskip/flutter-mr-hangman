import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.name,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(title: AppConfig.name),
        '/game': (context) => HomeScreen(title: 'Game'),
        '/highScores': (context) => HomeScreen(title: 'High Scores'),
      },
    );
  }
}
