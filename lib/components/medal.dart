import 'package:flutter/material.dart';

class Medal extends StatelessWidget {
  const Medal({required this.position, this.height = 32});

  final int position;
  final double? height;

  Color _medalColor(int position) {
    switch (position) {
      case 1:
        return Colors.yellow;
      case 2:
        return Colors.grey.shade300;
      case 3:
        return Colors.brown.shade400;
      default:
        throw new Exception('Unsupported medal position ${position}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (position > 3) {
      return SizedBox.shrink();
    }

    return Image.asset(
      'assets/flag.png',
      colorBlendMode: BlendMode.modulate,
      color: _medalColor(position),
      height: height,
    );
  }
}
