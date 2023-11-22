import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../components/highscore_list_item.dart';
import '../model/score.dart';
import '../service/highscores.dart';

class HighscoresScreen extends StatefulWidget {
  HighscoresScreen({super.key, required this.highscores});

  final Highscores highscores;

  @override
  State<HighscoresScreen> createState() => _HighscoresScreenState();
}

class _HighscoresScreenState extends State<HighscoresScreen> {
  final PagingController<int, Highscore> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int page) async {
    try {
      HighscoresData data = await widget.highscores.getScores(page);

      if (!data.pagination.hasNext) {
        _pagingController.appendLastPage(data.highscores);
        return Future(() {});
      }

      _pagingController.appendPage(data.highscores, page + 1);
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Highscores'),
      ),
      body: PagedListView(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Highscore>(
          itemBuilder: (context, item, index) => HighscoreListItem(
            highscore: item,
            position: index + 1,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
