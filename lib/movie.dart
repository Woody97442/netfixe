import 'package:flutter/material.dart';

class Movie extends StatelessWidget {
  final Map<String, dynamic>? dataMovie;
  const Movie({super.key, this.dataMovie});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      width: 100,
      height: 150,
      child: Text(dataMovie?['title']),
    );
  }
}
