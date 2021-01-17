import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sphere/providers/app/app_provider.dart';
import 'package:sphere/providers/app/genre.dart';
import 'package:sphere/providers/app/now_playing_data.dart';
import 'package:sphere/widgets/movie_card.dart';
import 'package:sphere/common/constants.dart';

class NowPlaying extends StatefulWidget {
  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  ScrollController _scrollController;
  bool fetchingMore = false;
  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppService appService = Provider.of<AppService>(context, listen: false);
    if (appService.nowPlayingData.result == null) {
      appService.getNowPlaying();
    }
    if (!_scrollController.hasListeners) {
      _scrollController.addListener(() {
        ScrollPosition position = _scrollController.position;
        double percentScrolled =
            (_scrollController.offset / position.maxScrollExtent) * 100;
        if (percentScrolled.toInt() > 60 &&
            appService.nowPlayingData.hasNextPage) {
          if (!fetchingMore) {
            setState(() {
              fetchingMore = true;
              appService.getMoreNowPlaying().then((value) => setState(() {
                    fetchingMore = false;
                  }));
            });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10.0, left: 20.0, bottom: 10.0),
          height: 20.0,
          child: Text(
            'Now Showing',
            style: kSectionTitleTextStyle,
          ),
        ),
        Container(
            height: 320.0,
            child: Consumer<AppService>(
              builder: (context, appService, child) {
                return render(appService);
              },
            )),
      ],
    );
  }

  Widget render(AppService appService) {
    NowPlayingData nowPlayingData = appService.nowPlayingData;
    if (nowPlayingData.isFetching) {
      return SpinKitFadingCube(
        color: Colors.white70,
        size: 20.0,
      );
    } else if (nowPlayingData.isFetchingFailed) {
      return Center(
        child: Text('Unable to fetch data, retrying',
            style: TextStyle(color: Colors.blueGrey)),
      );
    } else if (nowPlayingData.isFetchSuccess && nowPlayingData.result != null) {
      return ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return MovieCard(
              id: nowPlayingData.result[index]['id'],
              title: nowPlayingData.result[index]['title'],
              url: nowPlayingData.result[index]['poster_path'],
              genres: Genres.getGenreNames(appService.genres,
                  nowPlayingData.result[index]['genre_ids']));
        },
        itemCount: nowPlayingData.result.length,
      );
    }
    return Center(
      child: Text(
        'Sadly, there are no movies showing at this time',
        style: TextStyle(color: Colors.blueGrey),
      ),
    );
  }
}
