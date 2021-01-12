import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sphere/providers/app/app_provider.dart';
import 'package:sphere/providers/app/genre.dart';
import 'package:sphere/providers/app/suggestions_data.dart';
import 'package:sphere/widgets/suggestion_card.dart';

class Suggestions extends StatefulWidget {
  @override
  _SuggestionsState createState() => _SuggestionsState();
}

class _SuggestionsState extends State<Suggestions> {
  @override
  Widget build(BuildContext context) {
    AppService appService = Provider.of<AppService>(context);
    List<dynamic> genres = appService.genres;

    return genres != null
        ? renderUI(appService)
        : Container(
            height: 100,
            color: Colors.black26,
          );
  }

  Widget renderUI(AppService appService) {
    AppService appService = Provider.of<AppService>(context);
    List<dynamic> genres = appService.genres;
    SuggestionsData suggestionsData = appService.suggestionsData;
    return Stack(
      children: [
      suggestionsData.result != null ?
      Container(
        margin: EdgeInsets.only(top: 10.0, left: 20.0, bottom: 10.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: suggestionsData.result
                .map((e) => SuggestionCard(
              id: e['id'],
              title: e['title'],
              release: e['release_date'],
              voteAverage: e['vote_average'],
              imgUrl: e['poster_path'],
              genres: Genres.getGenreNames(genres, e['genre_ids']),
            ))
                .toList()),
      ): Container(),
      suggestionsData.isFetchingFailed ?  Container(
        padding: EdgeInsets.all(20.0),
        child: Text('Unable to fetch data, retrying',
            style: TextStyle(color: Colors.blueGrey)),
      ) : Container(),
      !suggestionsData.isFetchingFailed && !suggestionsData.isFetching && suggestionsData.result?.length == 0 ?
      Container(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'Sadly, there are no movies showing at this time',
          style: TextStyle(color: Colors.blueGrey),
        ),
      ): Container()
    ],);
  }
}
