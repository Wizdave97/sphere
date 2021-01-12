import 'package:sphere/common/constants.dart';
import 'package:sphere/services/network.dart';

class Genres {

  static Future<dynamic> getGenres() async{
    String url = 'https://api.themoviedb.org/3/genre/movie/list?api_key=$MOVIE_DB_API_KEY&language=en-US';
    dynamic response = await NetworkHelper.fetch(url);
    return response['genres'];
  }
  static List<String> getGenreNames(List<dynamic> genres, List<dynamic> genreIds) {
    if(genres != null) {
      List<String> names = genreIds.map((value) {
        String name;
        genres.forEach((element) {
          if(element['id'] == value) {
            name = element['name'];
          }
        });
        return name;
      }).toList();
      return names;
    }
    return [];
  }

  static String getGenreText(List<String> genres) {
    if (genres.length >= 1 && genres.length <= 2)
      return genres.join(', ');
    else if (genres.length > 2) {
      return '${genres.sublist(0, 2).join(', ')}...';
    }
    return '';
  }
}