import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sphere/common/constants.dart';
import 'package:sphere/providers/app/app_provider.dart';
import 'package:sphere/providers/app/genre.dart';
import 'package:sphere/screens/movie_screen.dart';

import 'add_thoughts_list.dart';


class MovieCard extends StatelessWidget {
  final int id;
  final String url;
  final String title;
  final List<String> genres;

  MovieCard({this.title, this.url, this.genres, this.id}) : super();
  @override
  Widget build(BuildContext context) {

    AppService appService = Provider.of<AppService>(context);
    return GestureDetector(
      onLongPress: () {
        appService.fetchMovie(id);
        showModalBottomSheet(
          isScrollControlled: true,
            context: context,
            builder: (context) => AddThoughtsList(movieId: id,)
        );
      },
      onTap: () {
        appService.fetchMovie(id);
        appService.fetchMovieCredits(id);
        appService.fetchMoviePosters(id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieScreen(
              movieId: id,
            ),
          ),
        );
      },
      child: Container(
        width: 150.0,
        height: 320.0,
        margin: EdgeInsets.only(right: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 150.0,
              height: 250.0,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  image: url != null ? DecorationImage(
                      image: NetworkImage('$assetBaseUrl$url'),
                      fit: BoxFit.cover) :  null,
                  borderRadius: BorderRadius.circular(20.0)),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              title,
              style: kMovieTitleTextStyle,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 2.0,
            ),
            Text(
              Genres.getGenreText(genres),
              style: kMovieGenreTextStyle,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            )
          ],
        ),
      ),
    );
  }

}
