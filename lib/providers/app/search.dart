import 'package:http/http.dart' as http;
import 'package:sphere/common/constants.dart';
import 'dart:convert';

class Search {
  bool _hasNextPage = false;
  int _nextPage = 1;
  bool _shouldDelay = false;
  List<dynamic> _result = [];

  Future<void> fetchSilently(String query) async {
    final  url = 'https://api.themoviedb.org/3/search/movie?api_key='
        '$MOVIE_DB_API_KEY&language=en-US&page=$_nextPage&include_adult=false&query=$query';
    http.Response response = await http.get(url);
    if(response.body != null && response.statusCode == 200) {
      dynamic decodedJson = jsonDecode(response.body);
      _hasNextPage = decodedJson['total_pages'] >= (_nextPage + 1);
      _nextPage++;
      _result.insertAll(_result.length, decodedJson['results']);
    }
    else return;
  }
  Future<void> createInterval() async {
      await Future.delayed(Duration(milliseconds: 500));
  }
  Stream<dynamic> fetchMoviesStream(String query) async* {
      await fetchSilently(query);
      yield _result;
    _hasNextPage = false;
    _nextPage = 1;
    _result = [];
    while(true) {
      await createInterval();
      await fetchSilently(query);
      yield _result;
      if(!_hasNextPage) break;
    }
  }

  get hasNextPage => hasNextPage;
  void destroy() {
    _result = [];
  }
}