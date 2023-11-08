abstract class GamePhraseLoader {
  Future<String> load();
}

class DemoGamePhraseLoader implements GamePhraseLoader {
  const DemoGamePhraseLoader();

  @override
  Future<String> load() {
    return Future.value('demo');
  }
}
