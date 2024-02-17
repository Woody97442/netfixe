import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

getMovieSearch(String value) async {
  var headersList = {
    'Accept': '*/*',
  };
  var url = Uri.parse(
    '${dotenv.env["BASE_URL"]}search/movie?api_key=${dotenv.env["API_KEY"]}&query=$value&language=fr-FR',
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
