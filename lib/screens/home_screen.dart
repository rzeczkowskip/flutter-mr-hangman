import 'package:flutter/material.dart';

import '../components/game_hangman_drawing.dart';
import '../components/main_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: OrientationBuilder(builder: (context, orientation) {
          final isLandscape = orientation == Orientation.landscape;

          return Container(
            padding: EdgeInsets.symmetric(
              vertical: isLandscape ? 20 : 0,
              horizontal: isLandscape ? 0 : 20,
            ),
            alignment: Alignment.center,
            child: Flex(
              direction: orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Spacer(flex: 10),
                Expanded(
                  child: AnimatedHangmanDrawing(
                    speed: 5,
                  ),
                  flex: 50,
                ),
                Spacer(flex: 10),
                Expanded(
                  flex: 30,
                  child: MainMenu(
                    maxWidth: 320,
                  ),
                ),
                Spacer(flex: 10),
              ],
            ),
          );
        }),
      ),
    );
  }
}
