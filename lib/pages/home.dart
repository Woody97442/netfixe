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
  Map<String, dynamic>? listMovies;
  final ScrollController _scrollController = ScrollController();

  late int currentPage = 1;
  late bool thisMovie = true;
  late bool thisTv = false;
  late String currentType = "movie";

  getTrending() async {
    final result = await findTrending("day", currentPage, "fr-FR", currentType);
    setState(
      () {
        listMovies = result;
      },
    );
  }

  void getGetNextPage(int page) async {
    final result = await findTrending("day", page, "fr-FR", currentType);
    setState(
      () {
        if (listMovies == null) {
          listMovies = result;
        } else {
          listMovies!['results'] = [
            ...(listMovies!['results'] as List<dynamic>),
            ...(result['results'] as List<dynamic>),
          ];
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getTrending();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // Fonction de rappel pour l'événement de défilement
  void _scrollListener() {
    // Vérifiez si vous avez atteint le bas de la liste
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Exécutez votre fonction ici lorsque vous arrivez en bas de la liste
      setState(
        () {
          currentPage++;
        },
      );
      getGetNextPage(currentPage);
    }
  }

  void changeType(String type) {
    setState(
      () {
        currentType = type;
      },
    );
    getTrending();
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
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () => {
                              setState(
                                () {
                                  thisMovie = !thisMovie;
                                  if (thisTv) {
                                    thisTv = !thisTv;
                                  }
                                  changeType("movie");
                                },
                              ),
                            },
                            child: TopToolBarItem(
                              title: 'Film',
                              isActive: thisMovie,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () => {
                              setState(
                                () {
                                  thisTv = !thisTv;
                                  if (thisMovie) {
                                    thisMovie = !thisMovie;
                                  }
                                  changeType("tv");
                                },
                              ),
                            },
                            child: TopToolBarItem(
                              title: 'Séries',
                              isActive: thisTv,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Tendances ${currentType == "movie" ? "Film" : "Séries"}",
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.39,
                    crossAxisSpacing: 15,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listMovies?['results'].length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    if (listMovies!['results'].length > index &&
                        listMovies!['results'][index]['poster_path'] != null) {
                      return GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              Navigator.pushNamed(
                                context,
                                '/movie',
                                arguments: {
                                  'idMovie': listMovies!['results'][index]
                                      ['id'],
                                  'type': currentType
                                },
                              );
                            },
                          );
                        },
                        child: Movie(
                          dataMovie: listMovies!['results'][index],
                        ),
                      );
                    } else {
                      return const SizedBox
                          .shrink(); // Si vous ne souhaitez rien afficher
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Footer(
          onTap: (String value) => {
            setState(() {
              Navigator.pushNamed(context, value);
            })
          },
          currentPage: '/',
        ),
      ),
    );
  }
}
