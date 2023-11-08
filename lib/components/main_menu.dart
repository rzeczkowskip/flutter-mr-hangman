import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      runSpacing: 10,
      children: [
        _MenuButton(label: 'New Game', route: '/game'),
        _MenuButton(label: 'High Scores', route: '/highScores'),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.label, required this.route});

  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
        onPressed: () => Navigator.pushNamed(context, route),
        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
        child: Text(label));
  }
}
