import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../model/score.dart';

class HighscoresTable extends StatelessWidget {
  HighscoresTable({required this.scores});

  final List<Highscore> scores;

  TableRow _getTableHeader() {
    List<TableCell> columns = ['', 'Position', 'Score']
        .map((label) => TableCell(
              child: Text(label),
            ))
        .toList();

    return TableRow(
      children: columns,
    );
  }

  List<TableRow> _getScoreRows() {
    return scores
        .mapIndexed(
          (index, score) =>
              _getScoreEntryRow(index + 1, score.score, score.date),
        )
        .toList();
  }

  TableRow _getScoreEntryRow(int position, int score, DateTime date) {
    List<TableCell> columns = [
      TableCell(child: Text(_formatDate(date))),
      TableCell(child: Text(position.toString())),
      TableCell(child: Text(score.toString())),
    ];

    return TableRow(
      children: columns,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    List<TableRow> rows = _getScoreRows();
    rows.insert(0, _getTableHeader());

    return Table(
      children: rows,
    );
  }
}
