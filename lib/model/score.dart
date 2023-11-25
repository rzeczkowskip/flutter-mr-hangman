class Highscore {
  Highscore(this.gameId, this.date, this.score);

  final String gameId;
  final DateTime date;
  final int score;

  Highscore.fromJson(Map<String, dynamic> data)
      : gameId = data['gameId'],
        date = DateTime.parse(data['date']),
        score = data['score'];

  Map<String, dynamic> toJson() => {
        'gameId': gameId,
        'date': date.toIso8601String(),
        'score': score,
      };
}
