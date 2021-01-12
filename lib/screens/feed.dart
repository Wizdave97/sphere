import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sphere/components/now_playing.dart';
import 'package:sphere/components/suggestions.dart';
import 'package:sphere/providers/app/app_provider.dart';
import 'package:sphere/widgets/genre_selectors.dart';
class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with ChangeNotifier {
  bool fetchingMore = false;
  ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    AppService appService = Provider.of<AppService>(context);
    if(!_scrollController.hasListeners) {
      _scrollController.addListener(() {
        ScrollPosition position = _scrollController.position;
        double percentScrolled = (_scrollController.offset / position.maxScrollExtent) * 100;
        if(percentScrolled.toInt() > 60 && appService.suggestionsData.hasNextPage) {
          if(!fetchingMore && appService.suggestionsData.result != null) {
            setState(() {
              fetchingMore = true;
              appService.getMoreSuggestions().then((value) => setState(() {
                fetchingMore = false;
              }));
            });
          }

        }
      });
    }
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        controller: _scrollController,
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
              [Suggestions(), if (fetchingMore) Container(child: SpinKitCubeGrid(size: 10.0, color: Colors.white70,)) else Container()],
            ),
          ),
        ],
      ),
    );
  }
}



