import 'package:flutter/material.dart';
import 'dart:math';

typedef KeyboardButtonTapCallback = void Function(String letter);

class GameKeyboard extends StatelessWidget {
  GameKeyboard({
    super.key,
    required this.usedLetters,
    required this.onTap,
  });

  List<String> usedLetters;
  void Function(String letter) onTap;

  int maxKeyboardWidth = 840;

  // using hardcoded rows for now
  // maybe in future we can use different keys per language
  final List<List<String>> _keyboardRows = [
    ['ą', 'ć', 'ę', 'ł', 'ń', 'ó', 'ś', 'ż', 'ź'],
    ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
    ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
    ['z', 'x', 'c', 'v', 'b', 'n', 'm'],
  ];

  double _calculateKeyWidth(double containerWidth) {
    int maxKeysInRow = _keyboardRows.map((row) => row.length).reduce(max);
    double keyWidthMultiplier = 1 / maxKeysInRow;

    return (min(containerWidth, maxKeyboardWidth) * keyWidthMultiplier)
        .floorToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final keyWidth = _calculateKeyWidth(constraints.maxWidth);

      final List<Widget> keyRows = _keyboardRows
          .map((row) => _KeyboardRow(
              characters: row,
              keyWidth: keyWidth,
              onTap: onTap,
              usedLetters: usedLetters))
          .toList();

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: keyRows,
      );
    });
  }
}

class _KeyboardRow extends StatelessWidget {
  const _KeyboardRow(
      {required this.characters,
      required this.keyWidth,
      required this.onTap,
      required this.usedLetters});

  final List<String> characters;
  final double keyWidth;
  final KeyboardButtonTapCallback onTap;
  final List<String> usedLetters;

  @override
  Widget build(BuildContext context) {
    final keys = characters
        .map((char) => _KeyboardButton(
              value: char,
              width: keyWidth,
              onTap: () {
                onTap(char);
              },
              disabled: usedLetters.contains(char),
            ))
        .toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys,
    );
  }
}

class _KeyboardButton extends StatelessWidget {
  const _KeyboardButton(
      {required this.value,
      required this.width,
      this.onTap,
      this.disabled = false});

  final String value;
  final GestureTapCallback? onTap;
  final double width;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
        height: 42,
        width: width,
        padding: const EdgeInsets.all(2),
        child: Material(
          color: disabled ? theme.disabledColor : theme.primaryColor,
          borderRadius: BorderRadius.circular(5),
          child: InkWell(
            onTap: disabled ? null : onTap,
            borderRadius: BorderRadius.circular(5),
            highlightColor: theme.highlightColor,
            child: Container(
                alignment: Alignment.center,
                child: Text(value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ))),
          ),
        ));
  }
}
