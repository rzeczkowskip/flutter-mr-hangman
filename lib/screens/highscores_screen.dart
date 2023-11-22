import 'package:flutter/material.dart';

import '../components/highscores_table.dart';
import '../model/score.dart';
import '../service/highscores.dart';

class HighscoresScreen extends StatefulWidget {
  HighscoresScreen({super.key, required this.highscores});

  final Highscores highscores;

  @override
  State<HighscoresScreen> createState() => _HighscoresScreenState();
}

class _HighscoresScreenState extends State<HighscoresScreen> {
  final List<Highscore> _scores = [];
  bool _hasNextPage = true;
  int _page = 0;

  late Highscores highscores;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNextPage();
    });
  }

  Future<void> _loadNextPage() async {
    if (!_hasNextPage) {
      return;
    }

    final int targetPage = _page + 1;

    HighscoresData data = await widget.highscores.getScores(_page + 1);

    setState(() {
      _hasNextPage = data.pagination.hasNext;
      _page = targetPage;
      _scores.addAll(data.highscores);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text('Highscores'),
      ),
      body: SingleChildScrollView(
        child: HighscoresTable(scores: _scores),
      ),
    );
  }
}
