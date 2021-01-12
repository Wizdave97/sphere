import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:sphere/providers/app/app_provider.dart';
import 'package:sphere/providers/app/suggestions_data.dart';
import 'package:sphere/widgets/suggestion_button.dart';

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent)
  {
    return new SizedBox.expand(child: child);
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class GenreSelectors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppService appService = Provider.of<AppService>(context);
    List<dynamic> genres = appService.genres;
    SuggestionsData suggestionsData = appService.suggestionsData;

    return SliverPersistentHeader(
      pinned: true,
        delegate: _SliverAppBarDelegate(
        minHeight: 60,
          maxHeight: 60,
          child: Container(
            color: Colors.black,
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Stack(
              children: [
                ListView(
                children: genres != null ? genres
                    .map((genre) => GestureDetector(
                  onTap: () {
                    appService.setGenreId(genre['id']);
                  },
                  child: SuggestionButton(
                    title: genre['name'],
                    selected:
                    suggestionsData.selectedGenreId == genre['id'],
                  ),
                ))
                    .toList() : [Container(height: 60.0,)],
                scrollDirection: Axis.horizontal,
              ),
                if (appService.suggestionsData.isFetching) Container(child: Center(child: SpinKitCubeGrid(size: 20.0, color: Colors.lightBlue,))) else Container()
              ],
            ),
          )
    ));
  }
}
