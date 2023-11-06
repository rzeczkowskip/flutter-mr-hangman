import 'package:flutter/material.dart';

class GamePhrase extends StatelessWidget {
  const GamePhrase({super.key, required this.phrase});

  static const double _fontSize = 18;
  static const double _letterSpacing = _fontSize * .3;

  final String phrase;

  @override
  Widget build(BuildContext context) {
    return Text(
      phrase,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: _fontSize,
        letterSpacing: _letterSpacing,
      ),
    );
  }
}
