import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/medal.dart';
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
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMd().format(highscore.date);
    final formattedTime = DateFormat.Hm().format(highscore.date);

    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          Text("$formattedDate $formattedTime"),
          const Spacer(flex: 1),
          if (position < 4) Medal(position: position),
          const SizedBox(width: 5),
          Text(highscore.score.toString()),
        ],
      ),
    );
  }
}
