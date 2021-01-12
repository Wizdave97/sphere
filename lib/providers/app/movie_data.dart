import 'package:sphere/common/constants.dart';
import 'package:sphere/services/network.dart';

class Movie {
  bool fetchingMovie = true;
  bool fetchingCredits = true;
  bool fetchingMovieFailed = false;
  bool fetchingCreditsFailed = false;
  dynamic movie;
  List<dynamic> credits;
  List<dynamic> images;

  Future<void> fetchMovie(int id) async {
    String url = 'https://api.themoviedb.org/3/movie/$id?api_key=$MOVIE_DB_API_KEY&language=en-US';
    dynamic response = await NetworkHelper.fetch(url);
    fetchingMovie = false;
    if(response != null) {
      movie = response;
      fetchingMovieFailed = false;
      return;
    }
    fetchingMovieFailed = true;
  }

  Future<void> fetchCredits(int id) async {
    String url = 'https://api.themoviedb.org/3/movie/$id/credits?api_key=$MOVIE_DB_API_KEY&language=en-US';
    dynamic response = await NetworkHelper.fetch(url);
    fetchingCredits = false;
    if(response != null) {
      credits = response['cast'];
      fetchingCreditsFailed = false;
      return;
    }
    fetchingCreditsFailed = true;
  }

  Future<void> fetchImages(int id) async {
    String url = 'https://api.themoviedb.org/3/movie/$id/images?api_key=$MOVIE_DB_API_KEY&language=en-US';
    dynamic response = await NetworkHelper.fetch(url);
    if(response != null) {
      images = response['posters'];
    }
  }

}