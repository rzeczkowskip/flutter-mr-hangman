import 'package:flutter/material.dart';

enum GameResultDialogState { Won, Over }

class GameResultDialog extends StatelessWidget {
  const GameResultDialog(
      {super.key, required this.phrase, required this.result});

  final String phrase;
  final GameResultDialogState result;

  @override
  Widget build(BuildContext context) {
    _GameResultDialogMessages messages = result == GameResultDialogState.Won
        ? _GameResultDialogMessages.won(phrase)
        : _GameResultDialogMessages.over(phrase);

    return AlertDialog(
      title: Text(messages.title),
      content: Text(messages.message),
      actions: <Widget>[
        TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: Icon(messages.buttonIcon),
          label: Text(messages.buttonLabel),
        ),
      ],
    );
  }
}

class _GameResultDialogMessages {
  final String title;
  final String message;

  final IconData buttonIcon;
  final String buttonLabel;

  _GameResultDialogMessages.over(String phrase)
      : title = 'Game over',
        message =
            'You fought bravely but it\'s time to say goodbye. The phrase was: "$phrase"',
        buttonIcon = Icons.sentiment_very_dissatisfied,
        buttonLabel = 'OK';

  _GameResultDialogMessages.won(String phrase)
      : title = 'It\'s a win!',
        message =
            'Nice, you were able to guess it! Your phrase was "$phrase". Let\'s move to the next round...',
        buttonIcon = Icons.sports_martial_arts,
        buttonLabel = 'OK';
}
