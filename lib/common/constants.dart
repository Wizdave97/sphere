import 'package:flutter/material.dart';
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
const MOVIE_DB_API_KEY = 'ed40b93de9b663b42c97a23a035a84ad';
const assetBaseUrl = 'https://image.tmdb.org/t/p/w500';
const int kBottomNavColor = 0xffA0142C;
const int kScaffoldBackground = 0xff0B0B0C;

const kMovieTitleTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
    textBaseline: TextBaseline.alphabetic);
const kSectionTitleTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 16.0,
);

const kMovieGenreTextStyle = TextStyle(
    color: Colors.blueGrey,
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
    textBaseline: TextBaseline.alphabetic);
const kSuggestionButtonTextStyle = TextStyle(
  color: Colors.white70,
  fontSize: 14.0,
  fontWeight: FontWeight.bold
);

const kMovieRatingTextStyle = TextStyle(
  color: Colors.yellow,
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
);


