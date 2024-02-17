import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

getMovieSearch(String value, String root, int page) async {
  var headersList = {
    'Accept': '*/*',
  };

  // var constructedUrl = {
  //   'base_url': dotenv.env["BASE_URL"],
  //   'root': root,
  //   'api_key': dotenv.env["API_KEY"],
  //   'query': value,
  //   'language': 'fr-FR',
  //   'include_adult': 'false',
  //   'region': 'FR',
  //   'sort_by': 'popularity.desc',
  //   'page': '1'
  // };

  var url = Uri.parse(
    '${dotenv.env["BASE_URL"]}$root?api_key=${dotenv.env["API_KEY"]}&query=$value&language=fr-FR&page=$page',
  );

  var req = http.Request('GET', url);
  req.headers.addAll(headersList);

  var res = await req.send();
  final response = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    return json.decode(response);
  } else {
    return [];
  }
}

getVideoWithId(String language, String id) async {
  var headersList = {
    'Accept': '*/*',
  };

  var url = Uri.parse(
    '${dotenv.env["BASE_URL"]}movie/$id/videos?api_key=${dotenv.env["API_KEY"]}&language=$language',
  );

  var req = http.Request('GET', url);
  req.headers.addAll(headersList);

  var res = await req.send();
  final response = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    return json.decode(response);
  } else {
    return [];
  }
}
