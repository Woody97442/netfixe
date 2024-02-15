import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:netfixe/movie.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? decodedResponseBody;
  final TextEditingController _searchController = TextEditingController();

  void searchMovie(String value) async {
    var headersList = {
      'Accept': '*/*',
    };
    var url = Uri.parse(
      'https://api.themoviedb.org/3/search/movie?api_key=adc2d6cac42701723c111af5cc9f9d51&query=$value&language=fr-FR',
    );

    var req = http.Request('GET', url);
    req.headers.addAll(headersList);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      setState(
        () {
          decodedResponseBody = json.decode(resBody);
        },
      );
    } else {
      print(res.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            AssetImage("assets/img/netflix.png"),
            color: Colors.red,
            size: 24,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ToolBarItem(
                            title: 'Séries',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ToolBarItem(
                            title: 'Film',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 130,
                          height: 35,
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Recherche',
                            ),
                            onSubmitted: (value) => searchMovie(value),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => searchMovie(_searchController.text),
                          child: const Icon(
                            Icons.search,
                            color: Color.fromARGB(120, 255, 255, 255),
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // const DropDown(),
                const SizedBox(height: 20),
                const Text("Film"),
                const SizedBox(height: 10),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 0.39,
                  crossAxisSpacing: 15,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    if (decodedResponseBody != null)
                      for (int i = 0;
                          i < decodedResponseBody!['results'].length;
                          i++)
                        if (decodedResponseBody!['results'].length > i)
                          GestureDetector(
                            onTap: () {
                              setState(
                                () {
                                  Navigator.pushNamed(
                                    context,
                                    '/movie',
                                    arguments: decodedResponseBody!['results']
                                        [i]["id"],
                                  );
                                },
                              );
                            },
                            child: Movie(
                              dataMovie: decodedResponseBody!['results'][i],
                            ),
                          ),
                  ],
                ),
              ],
            ),
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
                        'Découvrir',
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
      ),
    );
  }
}

class ToolBarItem extends StatelessWidget {
  final String title;
  final Icon? icon;

  const ToolBarItem({
    super.key,
    required this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: const Color.fromARGB(120, 255, 255, 255),
          width: 1.0,
          style: BorderStyle.solid,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color.fromARGB(120, 255, 255, 255),
            ),
          ),
          if (icon != null) icon!,
        ],
      ),
    );
  }
}
