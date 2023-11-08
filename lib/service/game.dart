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
