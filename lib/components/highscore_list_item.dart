import 'package:flutter/material.dart';

import '../model/score.dart';

class HighscoreListItem extends StatelessWidget {
  const HighscoreListItem({
    required this.position,
    required this.highscore,
    Key? key,
  }) : super(key: key);

  final Highscore highscore;
  final int position;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: CircleAvatar(
          radius: 20,
          child: Text(position.toString()),
        ),
        title: Text(highscore.score.toString()),
      );
}
