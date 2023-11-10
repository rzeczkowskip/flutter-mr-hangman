import 'package:flutter/material.dart';

import '../components/highscores_table.dart';
import '../model/score.dart';

class HighscoresScreen extends StatefulWidget {
  HighscoresScreen({super.key});

  @override
  State<HighscoresScreen> createState() => _HighscoresScreenState();
}

class _HighscoresScreenState extends State<HighscoresScreen> {
  @override
  Widget build(BuildContext context) {
    final scores = List.generate(
      99,
      (index) => Highscore(date: DateTime.now(), score: 99 - index),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Highscores'),
      ),
      body: SingleChildScrollView(
        child: HighscoresTable(scores: scores),
      ),
    );
  }
}
