import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Global variables
var headersList = {'Accept': '*/*'};

// Internal Functions

buildURL(Map<String, Object?> elementsUrl) {
  String url = "";
  elementsUrl.forEach(
    (key, value) {
      if (key == "query") {
        value = value as List;
        for (var i = 0; i < value.length; i++) {
          url = url + value[i];
        }
      } else {
        url = url + value.toString();
      }
    },
  );
  print("URL : $url");
  return url;
}

fetchFunction(Map<String, Object?> elementsUrl) async {
  var url = Uri.parse(buildURL(elementsUrl));

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

// External Functions (Functions from TMDB API)

findAllMovies(String searchMovie, String language, bool adult, int page,
    String type) async {
  var elementsUrl = {
    'base_url': dotenv.env["BASE_URL"],
    'root': dotenv.env["SEARCH"]?.replaceAll("type", type),
    'api_key': "?api_key=${dotenv.env["API_KEY"]}",
    'query': [
      "&query=$searchMovie",
      "&language=$language",
      "&include_adult=${adult.toString()}",
      "&page=${page.toString()}",
    ],
  };

  return await fetchFunction(elementsUrl);
}

getVideoWithId(String id, String language, String type) async {
  var elementsUrl = {
    'base_url': dotenv.env["BASE_URL"],
    'root': dotenv.env["MOVIE_VIDEO"]
        ?.replaceAll('idmovie', id)
        .replaceAll('type', type),
    'api_key': "?api_key=${dotenv.env["API_KEY"]}",
    'language': "&language=$language",
  };

  return await fetchFunction(elementsUrl);
}

findDiscover(List<String> genre, String language, bool adult, int page,
    String type) async {
  var elementsUrl = {
    'base_url': dotenv.env["BASE_URL"],
    'root': dotenv.env["DISCOVER"]?.replaceAll('type', type),
    'api_key': "?api_key=${dotenv.env["API_KEY"]}",
    'query': [
      "&sort_by=popularity.desc",
      "&with_genres=${genre.join(',')}",
      "&language=$language",
      "&include_adult=${adult.toString()}",
      "&page=${page.toString()}",
    ],
  };

  return await fetchFunction(elementsUrl);
}

findTrending(String time, int page, String language, String type) async {
  var elementsUrl = {
    'base_url': dotenv.env["BASE_URL"],
    'root': "${dotenv.env["TRENDING"]}$type/$time",
    'api_key': "?api_key=${dotenv.env["API_KEY"]}",
    'query': [
      "&language=$language",
      "&page=${page.toString()}",
    ],
  };

  return await fetchFunction(elementsUrl);
}

findDetail(String idMovie, String language, String type) async {
  var elementsUrl = {
    'base_url': dotenv.env["BASE_URL"],
    'root': "${dotenv.env["DETAIL_WITH_ID"]?.replaceAll("type", type)}$idMovie",
    'api_key': "?api_key=${dotenv.env["API_KEY"]}",
    'language': "&language=$language",
  };

  return await fetchFunction(elementsUrl);
}

// Other Functions