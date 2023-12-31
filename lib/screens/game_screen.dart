import 'package:flutter/material.dart';

import '../components/game_hangman_drawing.dart';
import '../components/game_keyboard.dart';
import '../components/game_phrase.dart';
import '../components/game_result_dialog.dart';
import '../components/game_status.dart';
import '../constants.dart';
import '../model/game.dart';
import '../service/game.dart';
import '../service/highscores.dart';

class GameScreen extends StatefulWidget {
  GameScreen({super.key, required this.highscores});

  GamePhraseLoader phraseLoader =
      GameConfig.isDemo ? const DemoGamePhraseLoader() : LocalPhraseLoader();

  final Highscores highscores;

  @override
  State<GameScreen> createState() => _WorldScreenState();
}

class _WorldScreenState extends State<GameScreen> {
  bool _loading = true;
  UniqueKey gameId = UniqueKey();

  GameSession _game = GameSession(phrase: '');

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

  @override
  void initState() {
    updateGameState();
  }

  bool _canLoadNewGame() {
    if (_game.phrase == '') {
      return true;
    }

    return !_game.isOver && _game.isFinished;
  }

  Future<void> loadNewGame() async {
    if (!_canLoadNewGame()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    String phrase = await widget.phraseLoader.load();
    _game = GameSession(
      phrase: phrase,
      onWin: (livesLeft, score) async {
        widget.highscores.addScore(gameId.toString(), score);

        await showDialog(
          context: context,
          builder: (context) => GameResultDialog(
            phrase: _game.phrase,
            result: GameResultDialogState.Won,
          ),
        );

        _game.finish();
        updateGameState();
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
    setState(() {
      _loading = false;
    });
  }

  void updateGameState() {
    setState(() {
      _lives = _game.lives;
      _usedLives = _game.usedLives;
      _phrase = _game.maskedPhrase;
      _usedChars = _game.chars;
    });
  }

  Widget _buildGameScreenMainFrame(bool isLandscape) {
    final GameHangmanDrawing gameHangmanDrawing =
        GameHangmanDrawing(lives: _lives, usedLives: _usedLives);

    final _World world = _World(
      maskedPhrase: _phrase,
      hangmanDrawing: isLandscape ? null : gameHangmanDrawing,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Expanded(
            flex: 0,
            child: _StatusBar(
              lives: _lives,
              usedLives: _usedLives,
            ),
          ),
          Expanded(
            flex: 1,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                if (isLandscape) gameHangmanDrawing,
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: world,
                      ),
                      Expanded(
                        flex: 0,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          child: GameKeyboard(
                            usedLetters: _usedChars,
                            onTap: (letter) {
                              _game.guess(letter);
                            },
                            disabled: _game.isWon || _game.isOver,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: FutureBuilder<void>(
            future: loadNewGame(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _loading &&
                        snapshot.connectionState != ConnectionState.done
                    ? const Center(child: CircularProgressIndicator())
                    : OrientationBuilder(
                        builder:
                            (BuildContext context, Orientation orientation) =>
                                _buildGameScreenMainFrame(
                          orientation == Orientation.landscape,
                        ),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  _StatusBar({required this.lives, required this.usedLives});

  final int lives;
  final int usedLives;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          TextButton.icon(
            // style: TextButton.styleFrom(
            //   backgroundColor: theme.colorScheme.primaryContainer,
            // ),
            onPressed: () {
              Navigator.maybePop(context);
            },
            icon: Image.asset(
              'assets/exit_icon.png',
              height: 20,
              color: Colors.white,
              colorBlendMode: BlendMode.modulate,
            ),
            label: Text(
              'End game',
              style: DefaultTextStyle.of(context).style.apply(heightFactor: .7),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 0,
            child: GameStatus(
              lives: lives,
              usedLives: usedLives,
            ),
          ),
        ],
      ),
    );
  }
}

class _World extends StatelessWidget {
  _World({
    required this.maskedPhrase,
    this.hangmanDrawing,
  });

  final String maskedPhrase;
  final Widget? hangmanDrawing;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final isLandscape = orientation == Orientation.landscape;
        Axis direction = isLandscape ? Axis.horizontal : Axis.vertical;

        final hangmanDrawingContainer = hangmanDrawing == null
            ? null
            : Expanded(
                flex: isLandscape ? 0 : 1,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(20),
                  child: hangmanDrawing,
                ),
              );

        List<Widget> gameBoxes = [
          if (hangmanDrawingContainer != null) hangmanDrawingContainer,
          Expanded(
            flex: isLandscape ? 1 : 0,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 10,
              ),
              child: GamePhrase(phrase: maskedPhrase),
            ),
          ),
        ].toList();

        return Flex(
          direction: direction,
          children: orientation == Orientation.portrait
              ? gameBoxes
              : (gameBoxes.reversed.toList()),
        );
      },
    );
  }
}
