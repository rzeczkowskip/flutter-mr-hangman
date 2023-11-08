import 'package:flutter/material.dart';

import '../components/game_hangman_drawing.dart';
import '../components/game_keyboard.dart';
import '../components/game_phrase.dart';
import '../components/game_result_dialog.dart';
import '../components/game_status.dart';
import '../model/game.dart';
import '../service/game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  final GamePhraseLoader phraseLoader = const DemoGamePhraseLoader();

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameSession _game;

  late int _lives;
  late int _usedLives;
  late String _phrase;
  List<String> _usedChars = [];

  void _exitToHome() {
    Navigator.popUntil(context, (route) => route.settings.name == '/');
  }

  Future<bool> _onWillPop() async {
    if (_game.isOver) {
      _exitToHome();
      return false;
    }

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
                onPressed: _exitToHome,
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  void initState() {
    loadNewGame();
  }

  void loadNewGame() {
    _game = GameSession(
      phrase: widget.phraseLoader.load(),
      onWin: (livesLeft) async {
        await showDialog(
          context: context,
          builder: (context) => GameResultDialog(
              phrase: _game.phrase, result: GameResultDialogState.Won),
        );

        loadNewGame();
      },
      onGuess: (guessedChar, isValidGuess, livesToSpare, phraseAfterGuess) {
        updateGameState();
      },
      onGameOver: () {
        showDialog(
          context: context,
          builder: (context) => GameResultDialog(
            phrase: _game.phrase,
            result: GameResultDialogState.Over,
          ),
        );
      },
    );

    updateGameState();
  }

  void updateGameState() {
    setState(() {
      _lives = _game.lives;
      _usedLives = _game.usedLives;
      _phrase = _game.maskedPhrase;
      _usedChars = _game.chars;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: SafeArea(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Expanded(
                  flex: 0,
                  child: Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 0,
                          child: GameStatus(
                            lives: _lives,
                            usedLives: _usedLives,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            backgroundColor: theme.colorScheme.primaryContainer,
                          ),
                          onPressed: () {
                            Navigator.maybePop(context);
                          },
                          icon: Image.asset(
                            'assets/exit_icon.png',
                            height: 20,
                            color: theme.colorScheme.primary,
                            colorBlendMode: BlendMode.modulate,
                          ),
                          label: const Text('End game'),
                        ),
                      ],
                    ),
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
                          child: GamePhrase(phrase: _phrase),
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
                    usedLetters: _usedChars,
                    onTap: (letter) {
                      _game.guess(letter);
                    },
                  ),
                )
              ],
            ),
          )),
        ));
  }
}
