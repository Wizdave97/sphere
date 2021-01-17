import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sphere/providers/app/app_provider.dart';
import 'package:sphere/providers/app/genre.dart';
import 'package:sphere/widgets/suggestion_card.dart';

class SuggestionsScreen extends StatefulWidget {
  final String genre;
  SuggestionsScreen({this.genre}) : super();
  @override
  _SuggestionsScreenState createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  bool fetchingMore = false;
  ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    AppService appService = Provider.of<AppService>(context, listen: false);
    if (!_scrollController.hasListeners) {
      _scrollController.addListener(() {
        ScrollPosition position = _scrollController.position;
        double percentScrolled =
            (_scrollController.offset / position.maxScrollExtent) * 100;
        if (percentScrolled.toInt() > 40 &&
            appService.suggestionsData.hasNextPage) {
          if (!fetchingMore && appService.suggestionsData.result != null) {
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.genre),
        backgroundColor: Colors.black,
      ),
      body: Consumer<AppService>(
        builder: (context, appService, child) {
          List<dynamic> moreSuggestions =
              appService.suggestionsData.moreSuggestions;
          List<dynamic> genres = appService.genres;
          if (moreSuggestions != null) {
            return ListView.builder(
                controller: _scrollController,
                itemCount: moreSuggestions.length,
                itemBuilder: (context, index) {
                  return SuggestionCard(
                    Key(moreSuggestions[index]['id'].toString()),
                    id: moreSuggestions[index]['id'],
                    title: moreSuggestions[index]['title'],
                    release: moreSuggestions[index]['release_date'],
                    voteAverage: moreSuggestions[index]['vote_average'],
                    imgUrl: moreSuggestions[index]['poster_path'],
                    genres: Genres.getGenreNames(
                        genres, moreSuggestions[index]['genre_ids']),
                  );
                });
          }
          return Center(
            child: Text('There are no movie suggestions'),
          );
        },
      ),
    );
  }
  @override
  void deactivate() {
    // TODO: implement deactivate
    _scrollController.dispose();
    super.deactivate();
  }
}
