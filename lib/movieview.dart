import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieView extends StatefulWidget {
  const MovieView({super.key});

  @override
  State<MovieView> createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {
  Map<String, dynamic>? data;

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
        appBar: AppBar(
          title: const Text(
            'NETFIXE',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.red,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(0, 0, 0, 0.2),
          leading: const ImageIcon(
            AssetImage("img/netflix.png"),
            color: Colors.red,
            size: 24,
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Hero(
                tag: title,
                child: SizedBox(
                  width: double.infinity,
                  height: 400,
                  child: Image.network(
                    "https://image.tmdb.org/t/p/w185$imgUrl",
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
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  // handleClick(context);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(15.0),
                height: 80,
                color: Colors.black,
                child: const Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 24,
                      ),
                      Text(
                        'Accueil',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  // handleClick(context);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(15.0),
                height: 80,
                color: Colors.black,
                child: const Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.movie_creation_outlined,
                        color: Color.fromARGB(100, 255, 255, 255),
                        size: 24,
                      ),
                      Text(
                        'Tout nouveau',
                        style: TextStyle(
                          color: Color.fromARGB(100, 255, 255, 255),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  // handleClick(context);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(15.0),
                height: 80,
                color: Colors.black,
                child: const Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.arrow_circle_down_outlined,
                        color: Color.fromARGB(100, 255, 255, 255),
                        size: 24,
                      ),
                      Text(
                        'Téléchargements',
                        style: TextStyle(
                          color: Color.fromARGB(100, 255, 255, 255),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Gérez le cas où les données sont nulles, par exemple, en affichant un message d'erreur ou en redirigeant l'utilisateur.
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text("Chargement...."),
        ),
      );
    }
  }
}
