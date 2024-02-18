import 'package:flutter/material.dart';
import 'package:netfixe/components/header.dart';
import 'package:netfixe/components/toptoolbaritem.dart';
import 'package:netfixe/components/footer.dart';
import 'package:netfixe/components/movie.dart';
import 'package:netfixe/utils/tool.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Map<String, dynamic>? listMovies;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late int currentPage = 1;
  late String currentSearch = "";
  late bool thisMovie = true;
  late bool thisTv = false;
  late String currentType = "movie";

  search(String search) async {
    final result =
        await findAllMovies(search, 'fr-FR', false, currentPage, currentType);

    setState(
      () {
        listMovies = result;
        currentSearch = search;
      },
    );
  }

  void getGetNextPage(int page, String search) async {
    final result =
        await findAllMovies(search, 'fr-FR', false, currentPage, currentType);
    setState(
      () {
        if (listMovies == null) {
          // Si listMovies est null, initialisez-le avec les résultats de la nouvelle page
          listMovies = result;
        } else {
          // Ajoutez les résultats de la nouvelle page à la suite de listMovies
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
      getGetNextPage(currentPage, currentSearch);
    }
  }

  void changeType(String type) {
    setState(
      () {
        currentType = type;
        currentPage = 1;
      },
    );
    search(currentSearch);
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
                            onSubmitted: (value) => search(value),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => search(_searchController.text),
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
                const SizedBox(height: 20),
                Text(currentType == "movie" ? "Film" : "Séries"),
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
                        listMovies!['results'][index] != null &&
                        listMovies!['results'][index]["poster_path"] != "") {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.pushNamed(
                              context,
                              '/movie',
                              arguments: {
                                'idMovie': listMovies!['results'][index]['id'],
                                'type': currentType
                              },
                            );
                          });
                        },
                        child: Movie(
                          dataMovie: listMovies!['results'][index],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
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
          currentPage: '/search',
        ),
      ),
    );
  }
}
