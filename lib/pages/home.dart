import 'package:flutter/material.dart';
import 'package:netfixe/components/header.dart';
import 'package:netfixe/components/toptoolbaritem.dart';
import 'package:netfixe/components/footer.dart';
import 'package:netfixe/components/movie.dart';
import 'package:netfixe/utils/tool.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? decodedResponseBody;
  final TextEditingController _searchController = TextEditingController();

  searchMovie(String value) async {
    final result = await getMovieSearch(value);
    setState(
      () {
        decodedResponseBody = result;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: const Header(
          size: 60,
          activeBack: false,
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
                          child: TopToolBarItem(
                            title: 'Séries',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TopToolBarItem(
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
        bottomNavigationBar: Footer(
          onTap: (String value) => {
            setState(
              () {
                Navigator.pushNamed(
                  context,
                  value,
                );
              },
            ),
          },
          currentPage: '/',
        ),
      ),
    );
  }
}
