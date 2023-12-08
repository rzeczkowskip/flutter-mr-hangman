import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key, this.maxWidth});

  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.maxWidth,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _MenuButton(label: 'New Game', route: '/game'),
          _MenuButton(label: 'High Scores', route: '/highScores'),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.label, required this.route});

  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: FilledButton(
        onPressed: () => Navigator.pushNamed(context, route),
        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
        child: Text(label),
      ),
    );
  }
}
