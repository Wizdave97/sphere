import 'package:flutter/material.dart';
import 'package:sphere/providers/app/genre.dart';
import 'package:sphere/providers/app/movie_data.dart';
import 'package:sphere/providers/app/now_playing_data.dart';
import 'package:sphere/providers/app/search.dart';
import 'package:sphere/providers/app/suggestions_data.dart';

class AppService extends ChangeNotifier {
  List<dynamic> genres;
  NowPlayingData nowPlayingData = NowPlayingData();
  SuggestionsData suggestionsData = SuggestionsData();
  Search search = Search();
  Map<int, Movie> movies = {};


  AppService() {
    fetchGenres();
  }

  String getGenreName() {
    String genre;
    genres.forEach((element) {if(element['id'] == suggestionsData.selectedGenreId) genre = element['name'];});
    return genre;
  }
  Future<void> fetchGenres() async {
    genres = await Genres.getGenres();
    if(genres != null) {
      setGenreId(genres[0]['id']);
    }
    notifyListeners();
  }

  Future<void> getNowPlaying() async {
    await nowPlayingData.fetchNowShowing();
    notifyListeners();
  }
  Future<void> getMoreNowPlaying() async {
    await nowPlayingData.fetchMore();
    notifyListeners();
  }
  Future<void> getSuggestions() async {
    await suggestionsData.fetchMovies();
    notifyListeners();
  }

  Future<void> getMoreSuggestions() async {
    await suggestionsData.fetchMore();
    notifyListeners();
  }

  void setGenreId(int id) {
    suggestionsData.setSelectedGenreId = id;
    suggestionsData.nextPage = 1;
    suggestionsData.hasNextPage = false;
    suggestionsData.isFetching = false;
    suggestionsData.isFetchingFailed = false;
    notifyListeners();
    getSuggestions();
  }

  void createMovieSlot(int id) {
    if(movies.length >= 100) {
      final keys = movies.keys.take(2);
      keys.forEach((element) => movies.remove(element));
    }
    if(movies[id] == null)
      movies[id] = Movie();
  }
  Future<void> fetchMovie(int id) async {
    createMovieSlot(id);
    await movies[id].fetchMovie(id);
    notifyListeners();
  }
  Future<void> fetchMovieCredits(int id) async {
    createMovieSlot(id);
    await movies[id].fetchCredits(id);
    notifyListeners();
  }

  Future<void> fetchMoviePosters(int id) async {
    createMovieSlot(id);
    await movies[id].fetchImages(id);
    notifyListeners();
  }

}
