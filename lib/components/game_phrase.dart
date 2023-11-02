import 'package:flutter/material.dart';

class GamePhrase extends StatefulWidget {
  GamePhrase({
    super.key,
    required this.phrase,
    required this.usedLetters,
  });

  List<String> usedLetters;
  String phrase;

  @override
  State<GamePhrase> createState() => _GamePhraseState();
}

class _GamePhraseState extends State<GamePhrase> {
  String _maskedPhrase() {
    final String allowedChars = ' ' + widget.usedLetters.join();
    final RegExp allowedCharsRegexp = RegExp(r'(?:[^\w\d]|[^' + allowedChars + '])');
    
    print({allowedChars, allowedCharsRegexp});

    return widget.phrase.replaceAll(allowedCharsRegexp, '_');
  }

  @override
  Widget build(BuildContext context) {
    print({widget.phrase, widget.usedLetters, _maskedPhrase()});
    return Text(
      _maskedPhrase(),
      style: TextStyle(
        fontSize: 42,
        letterSpacing: 16,
      ),
    );
  }
}