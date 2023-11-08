import 'package:flutter/material.dart';

class GameOverDialog extends StatelessWidget {
  GameOverDialog({required this.phrase});

  final String phrase;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Game over'),
      content: Text(
        'You fought bravely but it\'s time to say goodbye. The phrase was: "${phrase}"',
      ),
      actions: <Widget>[
        TextButton.icon(
          onPressed: () => Navigator.pop(),
          icon: Icon(Icons.sentiment_very_dissatisfied),
          label: Text('OK'),
        ),
      ],
    );
  }
}
