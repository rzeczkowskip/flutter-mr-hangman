enum GameState { New, Active, Guessed, Over }

typedef GameOverCallback = void Function();
typedef GameGuessCallback = void Function(String guessedChar, bool isValidGuess, int livesToSpare, String phraseAfterGuess);
typedef GameWonCallback = void Function(int livesToSpare);

class GameSession {
  GameSession({
    required this.phrase,
    required this.lives,
    this.onGuess,
    this.onGameOver,
    this.onWin,
  });

  final String phrase;
  final int lives;

  int _failedGuesses = 0;

  final List<String> _usedChars = [];

  final GameOverCallback? onGameOver;
  final GameGuessCallback? onGuess;
  final GameWonCallback? onWin;

  bool get isOver => _failedGuesses >= lives;
  bool get isWon => maskedPhrase == phrase;

  String get maskedPhrase {
    final String allowedChars = ' ${_usedChars.join()}';
    final RegExp allowedCharsRegexp = RegExp(r'(?:[^\w\d]|[^' + allowedChars + '])');

    return phrase.replaceAll(allowedCharsRegexp, '_');
  }

  int get livesLeft => lives - _failedGuesses;

  List<String> get chars => _usedChars;

  bool guess(String c) {
    if (isOver) {
      return false;
    }

    bool isValidGuess = phrase.contains(c);

    if (!_usedChars.contains(c)) {
      _usedChars.add(c);
    }

    if (!isValidGuess) {
      _failedGuesses += 1;
    }

    _guessCallback(isValidGuess, c);

    return isValidGuess;
  }

  _guessCallback(bool isValidGuess, String guessedChar) {
    onGuess?.call(guessedChar, isValidGuess, livesLeft, maskedPhrase);

    if (isOver) {
      onGameOver?.call();
      return;
    }

    if (isWon) {
      onWin?.call(livesLeft);
    }
  }
}

abstract class GamePhraseLoader {
  String load();
}

class DemoGamePhraseLoader implements GamePhraseLoader {
  const DemoGamePhraseLoader();

  @override
  String load() {
    return 'demo phrase to guess';
  }
}
