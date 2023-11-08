import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class GameHangmanDrawing extends StatefulWidget {
  const GameHangmanDrawing({
    super.key,
    required this.lives,
    required this.usedLives,
  });

  final int lives;
  final int usedLives;

  @override
  State<GameHangmanDrawing> createState() => _GameHangmanDrawingState();
}

class _GameHangmanDrawingState extends State<GameHangmanDrawing> {
  static const List<String> _assetPaths = [
    'assets/gallow.png',
    'assets/head.png',
    'assets/body.png',
    'assets/hand_left.png',
    'assets/hand_right.png',
    'assets/leg_left.png',
    'assets/leg_right.png',
    'assets/face.png',
  ];

  static const double visibleOpacity = 1;

  final int _opacitiesCount = _assetPaths.length;

  late List<Image> _images;
  late List<double> _opacities;

  late double _opacityStep;

  @override
  void initState() {
    _opacityStep = _opacitiesCount / widget.lives;
    recalculateAndUpdateOpacities();
  }

  void recalculateAndUpdateOpacities() {
    setState(() {
      if (widget.usedLives == 0) {
        _opacities = List.filled(_opacitiesCount, 0);
        return;
      }

      if (widget.usedLives >= widget.lives) {
        _opacities = List.filled(_opacitiesCount, visibleOpacity);
        return;
      }

      int used = widget.usedLives;
      double computed = (widget.usedLives * _opacityStep);

      _opacities = List.generate(
        _opacitiesCount - 1,
        (index) => computed >= index ? visibleOpacity : 0,
      );

      _opacities.add(0);
    });
  }

  @override
  void didUpdateWidget(_) {
    recalculateAndUpdateOpacities();
  }

  AnimatedOpacity buildAnimatedImage(double opacity, Image image) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: Duration(milliseconds: 200),
      child: image,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primary;

    List<AnimatedOpacity> images = _assetPaths
        .mapIndexed(
          (index, imagePath) => buildAnimatedImage(
              _opacities[index],
              Image.asset(
                imagePath,
                color: primaryColor,
              )),
        )
        .toList();

    return Stack(children: images);
  }
}
