import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/pagination.dart';
import '../model/score.dart';

class HighscoresData {
  HighscoresData(this.pagination, this.highscores);

  final List<Highscore> highscores;
  final Pagination pagination;
}

class PodiumHighscoresData {
  PodiumHighscoresData(List<Highscore> podiumScores)
      : podiumScores = podiumScores {
    if (podiumScores.length > 3) {
      throw Exception(
        'Too many scores for podium (${podiumScores.length}). Max is 3.',
      );
    }
  }

  final List<Highscore> podiumScores;
}

// I thought about using repository and some db context or uow but
// project's supposed to be simple
class Highscores {
  static int itemsPerPage = 10;
  static String storageKey = 'highscores';

  Highscores(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  bool _loaded = false;

  List<Highscore> _scores = [];

  Future<HighscoresData> getScores(int page) {
    _loadDatabaseScores();

    Pagination pagination = Pagination(page, itemsPerPage, _scores.length);

    if (page > pagination.totalPages) {
      throw Exception(
        'Page "$page" is higher than total pages count ${pagination
            .totalPages}.',
      );
    }

    int startCursor = (page - 1) * itemsPerPage;
    int endCursor = startCursor + itemsPerPage;

    return Future(() =>
        HighscoresData(
          pagination,
          _scores.sublist(startCursor, min(endCursor, _scores.length)),
        ));
  }

  void _loadDatabaseScores() {
    if (_loaded) {
      return;
    }

    List<String> rawItems = sharedPreferences.getStringList(storageKey) ?? [];
    List<Highscore> scores = rawItems.map((data) {
      final map = jsonDecode(data) as Map<String, dynamic>;
      return Highscore.fromJson(map);
    }).toList();

    _sortScores(scores);

    _scores = scores;
    _loaded = true;
  }

  void _sortScores(List<Highscore> scores) {
    scores.sort((a, b) {
      // compare b to a, so we get higher score higher
      final int isDifferentScore = b.score.compareTo(a.score);

      return isDifferentScore ?? a.date.compareTo(b.date);
    });
  }

  Future<void> addScore(int score) {
    _loadDatabaseScores();

    _scores.add(Highscore(DateTime.now(), score));
    _sortScores(_scores);

    sharedPreferences.setStringList(
      storageKey,
      _scores.map((data) => jsonEncode(data)).toList(),
    );

    return Future(() {});
  }
}
