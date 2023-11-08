import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

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

class LocalPhraseLoader implements GamePhraseLoader {
  List<String> _words = const [];

  @override
  Future<String> load() async {
    if (_words.length == 0) {
      await _initWords();
    }

    _words.shuffle();

    return _words.removeLast();
  }

  Future<void> _initWords() async {
    List<String> _lines = await rootBundle
        .loadString('resources/phrases_pl.txt')
        .then((value) => LineSplitter.split(value).toList());

    if (_lines.length == 0) {
      throw new Exception('No phrases found.');
    }

    _words = _lines;
  }
}
