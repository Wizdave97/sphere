import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  static Future<dynamic> fetch(String url) async {
    try {
      http.Response response = await http.get(url);
      if(response.statusCode == 200 && response.body != null) {
        dynamic decodedData = jsonDecode(response.body);
        return decodedData;
      }
      return null;
    }
    catch(e) {
      return null;
    }
  }

}