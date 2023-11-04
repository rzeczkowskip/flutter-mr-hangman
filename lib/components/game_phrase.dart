import 'package:flutter/material.dart';

class GamePhrase extends StatelessWidget {
  GamePhrase({ required this.phrase });

  final String phrase;

  @override
  Widget build(BuildContext context) {
    return Text(
      phrase,
      style: TextStyle(
        fontSize: 42,
        letterSpacing: 16,
      ),
    );
  }
}