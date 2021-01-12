import 'package:sphere/common/constants.dart';
import 'package:sphere/services/network.dart';

class NowPlayingData {
  int nextPage = 1;
  bool hasNextPage = false;
  bool isFetching = true;
  bool isFetchSuccess = false;
  bool isFetchingFailed = false;
  List<dynamic> result;

  Future<void> fetchNowShowing() async {
    dynamic response = await fetchSilently();
    if (response != null) {
        isFetching = false;
        isFetchSuccess = true;
        isFetchingFailed = false;
        result = response['results'];
        nextPage = nextPage + 1;
        hasNextPage = response['total_pages'] > nextPage;
    } else {
        isFetching = false;
        isFetchingFailed = true;
        isFetchSuccess = false;
    }
  }
  Future<dynamic> fetchSilently() async {
    String url =
        'https://api.themoviedb.org/3/movie/now_playing?api_key=$MOVIE_DB_API_KEY&language=en-US&page=$nextPage';
    dynamic response = await NetworkHelper.fetch(url);
    return response;
  }

  Future<void> fetchMore() async {
    dynamic response = await fetchSilently();
    if(response != null) {
      nextPage = nextPage + 1;
      hasNextPage = response['total_pages'] > nextPage;
      result.insertAll(result.length, response['results'] as List<dynamic>);
    }
  }
}