import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sphere/common/constants.dart';
import 'package:sphere/models/users.dart';
import 'package:sphere/providers/app/app_provider.dart';
import 'package:sphere/providers/app/genre.dart';
import 'package:sphere/widgets/person_card.dart';
import 'package:sphere/widgets/suggestion_card.dart';

enum SEARCH_TYPE { movies, people }

class SearchScreen extends StatefulWidget {
  final SEARCH_TYPE type;
  SearchScreen({this.type}) : super();
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Stream<dynamic> stream;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppService appService = Provider.of<AppService>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          flexibleSpace: Container(
            padding: EdgeInsets.only(left: 60.0),
            decoration: BoxDecoration(
                color: Colors.black,
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 1.0))),
            child: TextField(
              autofocus: true,
              onSubmitted: (value) {
                setState(() {
                  if (widget.type == SEARCH_TYPE.people) {
                    stream = User.searchUsers(value);
                  } else {
                    appService.search.destroy();
                    stream = appService.search.fetchMoviesStream(value);
                  }
                });
              },
              textAlignVertical: TextAlignVertical.bottom,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  fillColor: Colors.black,
                  hintText: widget.type == SEARCH_TYPE.people
                      ? 'Find friends on sphere'
                      : 'Search movies',
                  hintStyle: TextStyle(color: Colors.grey),
                  focusColor: Colors.white,
                  focusedBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none)),
            ),
          ),
        ),
        backgroundColor: Colors.black,
        body: Container(
          child: StreamBuilder<dynamic>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: Text(
                    'There are no search results',
                    style: kMovieGenreTextStyle.copyWith(
                        fontWeight: FontWeight.normal),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('An error occurred, try again'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: SpinKitCircle(
                  color: Colors.lightBlue,
                  size: 10.0,
                ));
              }
              dynamic docs;
              if (widget.type == SEARCH_TYPE.people) {
                docs = snapshot.data.docs;
              } else {
                docs = snapshot.data;
              }
              if (docs.length <= 0)
                return Center(
                  child: Text(
                    'There are no search results',
                    style: kMovieGenreTextStyle.copyWith(
                        fontWeight: FontWeight.normal),
                  ),
                );
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  if (widget.type == SEARCH_TYPE.movies) {
                    return SuggestionCard(
                      Key(docs[index]['id'].toString()),
                      id: docs[index]['id'],
                      title: docs[index]['title'],
                      release: docs[index]['release_date'],
                      voteAverage: docs[index]['vote_average'],
                      imgUrl: docs[index]['poster_path'],
                      genres: Genres.getGenreNames(
                        appService.genres,
                        docs[index]['genre_ids'],
                      ),
                    );
                  } else {
                    User user = User.fromMap(docs[index].data());
                    return PersonCard(
                      photoURL: user.photoURL,
                      displayName: user.displayName,
                      movieQuote: user.movieQuote,
                      userId: user.userId,
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
