import 'dart:math';

import 'package:flutter/material.dart';

typedef KeyboardButtonTapCallback = void Function(String letter);

class GameKeyboard extends StatelessWidget {
  GameKeyboard({
    super.key,
    required this.usedLetters,
    required this.onTap,
    this.disabled = false,
  });

  List<String> usedLetters;
  void Function(String letter) onTap;
  final bool disabled;

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

  List<Widget> _buildKeyboardRowsList(double keyWidth) {
    return _keyboardRows
        .map((row) => _KeyboardRow(
              characters: row,
              keyWidth: keyWidth,
              onTap: onTap,
              usedLetters: usedLetters,
              disabled: disabled,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildKeyboardRowsList(
                  _calculateKeyWidth(constraints.maxWidth)),
            ));
  }
}

class _KeyboardRow extends StatelessWidget {
  const _KeyboardRow({
    required this.characters,
    required this.keyWidth,
    required this.onTap,
    required this.usedLetters,
    this.disabled = false,
  });

  final List<String> characters;
  final double keyWidth;
  final KeyboardButtonTapCallback onTap;
  final List<String> usedLetters;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final keys = characters
        .map((char) => _KeyboardButton(
              value: char,
              width: keyWidth,
              onTap: () {
                onTap(char);
              },
              disabled: disabled || usedLetters.contains(char),
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
      child: Opacity(
        opacity: disabled ? .7 : 1,
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
        ),
      ),
    );
  }
}
