import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sphere/common/constants.dart';
import 'package:sphere/providers/app/app_provider.dart';
import 'package:sphere/providers/app/movie_data.dart';
import 'package:sphere/widgets/FlatLoadingPanel.dart';
import 'package:sphere/widgets/cast.dart';
import 'package:sphere/widgets/error_panel.dart';

class MovieScreen extends StatefulWidget {
  final int movieId;
  MovieScreen({this.movieId}) : super();
  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    animationController.forward();
    animationController.addListener(() {
      setState(() {});
    });
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse(from: 1.0);
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward(from: 0.0);
      }
    });
  }

  @override
  void didChangeDependencies() {
    AppService appService = Provider.of<AppService>(context);
    Movie movie = appService.movies[widget.movieId];
    if (!movie.fetchingMovie && !movie.fetchingCredits) {
      try {
        animationController.dispose();
      } catch (e) {}
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    try {
      animationController.dispose();
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          Consumer<AppService>(builder: (context, appService, child) {
            Movie movie = appService.movies[widget.movieId];
            return SliverAppBar(
              title: Text(!movie.fetchingMovie && movie.movie != null
                  ? movie.movie['title']
                  : 'Movie'),
              expandedHeight: 300.0,
              backgroundColor: Colors.black12,
              flexibleSpace: FlexibleSpaceBar(
                background: renderAppbar(movie),
              ),
            );
          }),
          Consumer<AppService>(builder: (context, appService, child) {
            Movie movie = appService.movies[widget.movieId];
            return SliverList(
                delegate: SliverChildListDelegate([
              renderMovieDetails(movie),
              renderMovieCredits(movie),
              renderMoviePlot(movie),
              renderMoviePosters(movie)
            ]));
          })
        ],
      ),
    );
  }

  Widget renderAppbar(Movie movie) {
    if (movie.fetchingMovie && movie.movie == null) {
      return LoadingPanel(
        animationController: animationController,
        height: null,
      );
    } else if (!movie.fetchingMovie &&
        !movie.fetchingMovieFailed &&
        movie.movie != null) {
      return Image.network(
        '$assetBaseUrl${movie.movie['backdrop_path']}',
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: SpinKitChasingDots(
              color: Colors.white,
              size: 20.0,
            ),
          );
        },
        errorBuilder:
            (BuildContext context, Object exception, StackTrace stackTrace) {
          return Center(
              child: Text(
            ' Oops error loading image😢',
            style: TextStyle(color: Colors.white60),
          ));
        },
      );
    } else {
      return ErrorPanel();
    }
  }

  Widget renderMovieDetails(Movie movie) {
    if (movie.fetchingMovie && movie.movie == null) {
      return LoadingPanel(
        animationController: animationController,
        height: 150.0,
      );
    } else if (!movie.fetchingMovie &&
        !movie.fetchingMovieFailed &&
        movie.movie != null) {
      return MovieDetails(movie: movie);
    } else {
      return ErrorPanel();
    }
  }

  Widget renderMoviePlot(Movie movie) {
    if (movie.fetchingMovie && movie.movie == null) {
      return LoadingPanel(
        animationController: animationController,
        height: 200.0,
      );
    } else if (!movie.fetchingMovie &&
        !movie.fetchingMovieFailed &&
        movie.movie != null) {
      return MoviePlot(movie: movie);
    } else {
      return ErrorPanel();
    }
  }

  Widget renderMovieCredits(Movie movie) {
    if (movie.fetchingCredits && movie.credits == null) {
      return LoadingPanel(
        animationController: animationController,
        height: 250.0,
      );
    } else if (!movie.fetchingCredits &&
        !movie.fetchingCreditsFailed &&
        movie.credits != null) {
      return MovieCast(movie: movie);
    } else {
      return ErrorPanel();
    }
  }

  Widget renderMoviePosters(Movie movie) {
    if (movie.images == null) {
      return Container(
        height: 250.0,
        color: Colors.grey,
      );
    } else {
      return MoviePosters(movie: movie);
    }
  }
}

class MoviePlot extends StatelessWidget {
  final Movie movie;
  const MoviePlot({
    Key key,
    this.movie
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10.0),
            child: Text(
              'Plot',
              style: kMovieTitleTextStyle,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            height: 150,
            margin: EdgeInsets.only(left: 10.0),
            child: Text(
              movie.movie['overview'],
              maxLines: 3,
              textWidthBasis: TextWidthBasis.parent,
              overflow: TextOverflow.ellipsis,
              style: kMovieGenreTextStyle.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0),
            ),
          )
        ],
      ),
    );
  }
}

class MovieCast extends StatelessWidget {
  final Movie movie;
  const MovieCast({
    Key key,
    this.movie
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10.0),
            child: Text(
              'Cast',
              style: kMovieTitleTextStyle,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: movie.credits
                  .map((credit) => Cast(
                        credit: credit,
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}

class MoviePosters extends StatelessWidget {
  final Movie movie;
  const MoviePosters({
    Key key,
    this.movie
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: movie.images.length > 0
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Screenshots',
                    style: kMovieTitleTextStyle,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: movie.images
                        .map((image) => Container(
                              height: 200,
                              margin:
                                  EdgeInsets.only(left: 10.0, right: 10.0),
                              color: Colors.grey,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          '$assetBaseUrl${image['file_path']}'))),
                            ))
                        .toList(),
                  ),
                )
              ],
            )
          : Center(
              child: Text(
                'There are no screenshots at this time',
                style: TextStyle(color: Colors.white70),
                softWrap: true,
                textWidthBasis: TextWidthBasis.parent,
              ),
            ),
    );
  }
}

class MovieDetails extends StatelessWidget {
  final Movie movie;
  const MovieDetails({
    Key key,
    this.movie
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            movie.movie['title'],
            style: kMovieTitleTextStyle,
            maxLines: 2,
            textAlign: TextAlign.center,
            textWidthBasis: TextWidthBasis.parent,
          ),
          Text(movie.movie['release_date'],
              style: kMovieGenreTextStyle.copyWith(
                  fontWeight: FontWeight.normal)),
          Text(
            '${movie.movie['vote_average']} / 10',
            style: kMovieRatingTextStyle,
          ),
          Wrap(
            spacing: 2.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center,
            children: (movie.movie['genres'] as List<dynamic>)
                .map((genre) => Container(
                      padding: EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xff2F2F30),
                      ),
                      constraints:
                          BoxConstraints.tightFor(width: 80.0, height: 30.0),
                      margin: EdgeInsets.only(left: 4.0, right: 4.0),
                      child: Center(
                        child: Text(genre['name'],
                            style: kSuggestionButtonTextStyle),
                      ),
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}
