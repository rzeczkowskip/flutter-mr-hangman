class Highscore {
  Highscore(this.date, this.score);

  final DateTime date;
  final int score;

  Highscore.fromJson(Map<String, dynamic> data)
      : date = DateTime.parse(data['date']),
        score = data['score'];

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'score': score,
      };
}
