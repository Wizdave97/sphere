import 'package:sphere/common/constants.dart';
import 'package:sphere/services/network.dart';

class SuggestionsData {
  int selectedGenreId;
  int nextPage = 1;
  bool hasNextPage = false;
  bool isFetching = false;
  bool isFetchSuccess = false;
  bool isFetchingFailed = false;
  List<dynamic> result;
  List<dynamic> moreSuggestions = [];

  Future<void> fetchMovies() async {
      isFetching = true;
    dynamic response = await fetchSilently();
    if (response != null) {
        isFetching = false;
        isFetchSuccess = true;
        isFetchingFailed = false;
        result = response['results'];
        moreSuggestions = response['results'];
        nextPage = response['total_pages'] > nextPage ? nextPage + 1 : nextPage;
        hasNextPage = response['total_pages'] > nextPage;
    } else {
        isFetching = false;
        isFetchingFailed = true;
        isFetchSuccess = false;
    }
  }

  Future<dynamic> fetchSilently() async {
    String url =
        'https://api.themoviedb.org/3/discover/movie?api_key=$MOVIE_DB_API_KEY'
        '&language=en-US&sort_by=popularity.desc&include_adult=true'
        '&include_video=false&page=$nextPage&with_genres=$selectedGenreId';
    dynamic response = await NetworkHelper.fetch(url);
    return response;
  }

  set setSelectedGenreId  (int id) => selectedGenreId = id;

  Future<void> fetchMore() async {
    dynamic response = await fetchSilently();
    if(response != null) {
      nextPage = nextPage + 1;
      hasNextPage = response['total_pages'] > nextPage;
      moreSuggestions.insertAll(moreSuggestions.length, response['results'] as List<dynamic>);
    }
  }

}