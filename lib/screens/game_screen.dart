import 'package:flutter/material.dart';

import '../components/game_hangman_drawing.dart';
import '../components/game_keyboard.dart';
import '../components/game_phrase.dart';
import '../components/game_status.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _lives = 11;
  int _usedLives = 0;

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure you want to end the game?'),
            content: const Text(
                'You will loose all progress and current score will be save to high scores.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: SafeArea(
              child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Expanded(
                  flex: 0,
                  child: Container(
                    height: 20,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: GameStatus(
                      lives: _lives,
                      usedLives: _usedLives,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    icon: BackButtonIcon(),
                    label: Text('End game'),
                  ),
                ),
                Expanded(
                  child: OrientationBuilder(builder: (context, orientation) {
                    Axis direction = orientation == Orientation.portrait
                        ? Axis.vertical
                        : Axis.horizontal;

                    List<Widget> gameBoxes = [
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(20),
                          child: GameHangmanDrawing(
                              lives: _lives, usedLives: _usedLives),
                        ),
                      ),
                      Expanded(
                        flex: 0,
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(
                            vertical: 30,
                            horizontal: 10,
                          ),
                          child:
                              const GamePhrase(phrase: 'demo p__a_e to g____'),
                        ),
                      ),
                    ].toList();

                    return Flex(
                      direction: direction,
                      children: orientation == Orientation.portrait
                          ? gameBoxes
                          : (gameBoxes.reversed.toList()),
                    );
                  }),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: GameKeyboard(
                    usedLetters: const [],
                    onTap: (letter) {
                      setState(() {
                        _usedLives += 1;
                      });
                    },
                  ),
                )
              ],
            ),
          )),
        ));
  }
}
