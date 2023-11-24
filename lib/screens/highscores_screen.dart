import 'dart:math';

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

  Widget _getHighscoresList(BuildContext context, double maxWidth) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: _getHorizontalPaddingToLimitWidth(context, maxWidth),
        vertical: MediaQuery.of(context).size.height * .25,
      ),
      sliver: PagedSliverList.separated(
        pagingController: _pagingController,
        separatorBuilder: (context, index) => const Divider(),
        builderDelegate: PagedChildBuilderDelegate<Highscore>(
          itemBuilder: (context, item, index) => HighscoreListItem(
            highscore: item,
            position: index + 1,
          ),
        ),
      ),
    );
  }

  double _getHorizontalPaddingToLimitWidth(
    BuildContext context,
    double expectedWidth,
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double availableSpaceForPadding = max(screenWidth - 320, 0);

    double padding = availableSpaceForPadding / 2;

    return padding;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Highscores'),
      ),
      body: CustomScrollView(
        slivers: [
          _getHighscoresList(context, 320),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
