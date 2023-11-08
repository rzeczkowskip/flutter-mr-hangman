class AppConfig {
  static const name = 'Mr Hangman';
}

class GameConfig {
  static const lives = 7;
  static const isDemo = String.fromEnvironment('GAME_DEMO_PHRASES') == '1';
}
