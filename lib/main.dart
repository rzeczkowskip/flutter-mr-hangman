import 'package:flutter/material.dart';

import 'config/di.dart';
import 'constants.dart';
import 'screens/game_screen.dart';
import 'screens/highscores_screen.dart';
import 'screens/home_screen.dart';
import 'service/highscores.dart';

void main() async {
  registerServices(getIt);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final highscores = getIt<Highscores>();

    return MaterialApp(
      title: AppConfig.name,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(title: AppConfig.name),
        '/game': (context) => GameScreen(highscores: highscores),
        '/highScores': (context) => HighscoresScreen(highscores: highscores),
      },
      builder: (context, widget) {
        return FutureBuilder(
            future: getIt.allReady(),
            builder: (_, AsyncSnapshot snapshot) {
              if (snapshot.hasData && widget != null) {
                return widget;
              } else {
                return Container(color: Colors.red);
              }
            });
      },
    );
  }
}
