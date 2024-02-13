import 'package:flutter/material.dart';

class Movie extends StatelessWidget {
  final Map<String, dynamic>? dataMovie;
  const Movie({super.key, this.dataMovie});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      "https://image.tmdb.org/t/p/w185${dataMovie?['poster_path']}",
      fit: BoxFit.cover,
      height: 200,
      width: 150,
    );
  }
}
