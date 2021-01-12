import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sphere/common/constants.dart';
import 'package:sphere/providers/app/app_provider.dart';
import 'package:sphere/providers/app/genre.dart';
import 'package:sphere/screens/movie_screen.dart';
import 'package:sphere/widgets/add_thoughts_list.dart';

class SuggestionCard extends StatelessWidget {
  @required
  final int id;
  final String title;
  final String release;
  final dynamic voteAverage;
  final String imgUrl;
  final List<String> genres;

  SuggestionCard(
      {this.id,
      this.title,
      this.release,
      this.voteAverage,
      this.imgUrl,
      this.genres});
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
        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
        height: 120.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: double.infinity,
              width: 120.0,
              decoration: BoxDecoration(
                  color: Color(0xff2F2F30),
                  borderRadius: BorderRadius.circular(10.0),
                  image: imgUrl != null
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage('$assetBaseUrl$imgUrl'))
                      : null),
              clipBehavior: Clip.hardEdge,
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Flexible(
                        child: Text(
                      title,
                      style: kMovieTitleTextStyle,
                      overflow: TextOverflow.ellipsis,
                    )),
                    SizedBox(
                      width: 2.0,
                    ),
                    Text(
                      '($release)',
                      style: kMovieGenreTextStyle.copyWith(
                          fontWeight: FontWeight.normal, fontSize: 14),
                    )
                  ]),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    '$voteAverage / 10',
                    style: kMovieRatingTextStyle,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    Genres.getGenreText(genres),
                    style: kMovieGenreTextStyle,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


}
