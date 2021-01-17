import 'package:flutter/material.dart';
import 'package:sphere/components/now_playing.dart';
import 'package:sphere/components/suggestions.dart';
import 'package:sphere/widgets/genre_selectors.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                NowPlaying(),
              ],
            ),
          ),
          GenreSelectors(),
          SliverList(
            delegate: SliverChildListDelegate(
              [

                Suggestions(),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
