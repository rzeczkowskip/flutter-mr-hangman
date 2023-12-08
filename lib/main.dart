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
    return MaterialApp(
      title: AppConfig.name,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          backgroundColor: Colors.transparent,
          cardColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        textTheme: Typography.whiteMountainView.apply(fontFamily: 'Sono'),
        // scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
        dialogBackgroundColor: Colors.black.withOpacity(.8),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(title: AppConfig.name),
        '/game': (context) => GameScreen(
              highscores: getIt<Highscores>(),
            ),
        '/highScores': (context) => HighscoresScreen(
              highscores: getIt<Highscores>(),
            ),
      },
      builder: (context, widget) {
        return FutureBuilder(
            future: getIt.allReady(),
            builder: (_, AsyncSnapshot snapshot) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/environment/bg.png'),
                  ),
                ),
                child: snapshot.hasData && widget != null
                    ? widget
                    : Container(color: Colors.red),
              );
            });
      },
    );
  }
}
