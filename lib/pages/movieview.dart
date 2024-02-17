import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:netfixe/components/footer.dart';
import 'package:netfixe/components/header.dart';
import 'package:netfixe/customs_icons/spinload.dart';

class MovieView extends StatefulWidget {
  const MovieView({super.key});

  @override
  State<MovieView> createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? data;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
          seconds: 1), // Vous pouvez ajuster la durée de l'animation
    )..repeat(); // La méthode repeat() fait tourner l'animation en continu
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    int? movieData = ModalRoute.of(context)!.settings.arguments as int?;
    if (movieData != null) {
      searchImageMovie(movieData.toString());
    }
  }

  void searchImageMovie(String idMovie) async {
    var headersList = {
      'Accept': '*/*',
    };
    var url = Uri.parse(
      'https://api.themoviedb.org/3/movie/$idMovie?api_key=adc2d6cac42701723c111af5cc9f9d51&language=fr-FR',
    );

    var req = http.Request('GET', url);
    req.headers.addAll(headersList);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      setState(
        () {
          data = json.decode(resBody);
        },
      );
    } else {
      print(res.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data != null) {
      String title = data!['title'];
      String imgUrl = data!['poster_path'];
      String desc = data!['overview'];

      return Scaffold(
        backgroundColor: Colors.black,
        appBar: const Header(
          size: 60,
          activeBack: true,
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Hero(
                    tag: title,
                    child: SizedBox(
                      width: double.infinity,
                      child: Image.network(
                        "https://image.tmdb.org/t/p/w600_and_h900_bestv2$imgUrl",
                        fit: BoxFit.fill,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 15,
                      textBaseline: TextBaseline.alphabetic,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Footer(
          onTap: (String value) => {
            setState(
              () {
                Navigator.pushNamed(
                  context,
                  value,
                );
                dispose();
              },
            ),
          },
          currentPage: '/movie',
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RotationTransition(
                turns: _controller,
                child: const Icon(
                  SpinLoad.spin4,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 10),
              const Text("Chargement...."),
            ],
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
