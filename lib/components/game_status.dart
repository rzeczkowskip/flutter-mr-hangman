import 'dart:math';

import 'package:flutter/material.dart';

typedef KeyboardButtonTapCallback = void Function(String letter);

class GameStatus extends StatelessWidget {
  const GameStatus({
    super.key,
    required this.lives,
    required this.usedLives,
  });

  final int lives;
  final int usedLives;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Lives(lives: lives, usedLives: usedLives),
      ],
    );
  }
}

class _Lives extends StatefulWidget {
  const _Lives({
    required this.lives,
    required this.usedLives,
  });

  static const int maxHearts = 7;
  static const double heartSize = 20;

  final int lives;
  final int usedLives;

  @override
  State<_Lives> createState() => _LivesState();
}

class _LivesState extends State<_Lives> {
  late final Image _heartImage;
  late final Image _moreHealthImage;

  @override
  void initState() {
    _heartImage = Image.asset(
      'assets/heart.png',
      width: _Lives.heartSize,
      height: _Lives.heartSize,
      fit: BoxFit.contain,
    );

    _moreHealthImage = Image.asset(
      'assets/more_health.png',
      width: _Lives.heartSize,
      height: _Lives.heartSize,
      fit: BoxFit.contain,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int livesToSpare = max(widget.lives - widget.usedLives, 0);
    bool hasMoreHealth = livesToSpare > _Lives.maxHearts;

    int heartsCount = hasMoreHealth ? _Lives.maxHearts : livesToSpare;

    List<Widget> hpImages =
        List.filled(heartsCount, _heartImage, growable: true);
    if (hasMoreHealth) {
      hpImages.add(_moreHealthImage);
    }

    return Wrap(
      spacing: 1,
      children: hpImages,
    );
  }
}
