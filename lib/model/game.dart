import '../constants.dart';

enum GameState { New, Active, Guessed, Over }

typedef GameOverCallback = void Function();
typedef GameGuessCallback = void Function(String guessedChar, bool isValidGuess,
    int livesToSpare, String phraseAfterGuess);
typedef GameWonCallback = void Function(int livesToSpare, int score);

class GameSession {
  GameSession({
    required this.phrase,
    this.lives = GameConfig.lives,
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

  bool _finished = false;

  bool get isOver => _failedGuesses >= lives;

  bool get isWon => maskedPhrase == phrase;

  bool get isFinished => _finished || isOver;

  String get maskedPhrase => _maskPhrase(_usedChars.join());

  int get livesLeft => lives - _failedGuesses;

  int get usedLives => _failedGuesses;

  List<String> get chars => _usedChars;

  bool guess(String c) {
    if (isFinished) {
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

  void _guessCallback(bool isValidGuess, String guessedChar) {
    onGuess?.call(guessedChar, isValidGuess, livesLeft, maskedPhrase);

    if (isOver) {
      onGameOver?.call();
      return;
    }

    if (isWon) {
      final score = _maskPhrase('').allMatches('_').length;
      onWin?.call(livesLeft, score);
    }
  }

  void finish() {
    _finished = true;
  }

  String _maskPhrase(String allowedChars) {
    final RegExp allowedCharsRegexp = RegExp(
      r'(?:[^0-9 ' + allowedChars + '])',
    );

    return phrase.replaceAll(allowedCharsRegexp, '_');
  }
}
