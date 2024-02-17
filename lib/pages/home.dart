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
  final ScrollController _scrollController = ScrollController();

  late int currentPage = 1;

  searchMovie(String value) async {
    final result = await getMovieSearch(value, 'search/movie', currentPage);
    setState(
      () {
        decodedResponseBody = result;
      },
    );
  }

  getDiscoverMovie() async {
    final result = await getMovieSearch("", 'discover/movie', currentPage);
    setState(
      () {
        decodedResponseBody = result;
      },
    );
  }

  void getGetNextPage(int page) async {
    final result = await getMovieSearch("", 'discover/movie', page);
    setState(
      () {
        if (decodedResponseBody == null) {
          // Si decodedResponseBody est null, initialisez-le avec les résultats de la nouvelle page
          decodedResponseBody = result;
        } else {
          // Ajoutez les résultats de la nouvelle page à la suite de decodedResponseBody
          decodedResponseBody!['results'] = [
            ...(decodedResponseBody!['results'] as List<dynamic>),
            ...(result['results'] as List<dynamic>),
          ];
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getDiscoverMovie();
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
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.39,
                    crossAxisSpacing: 15,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: decodedResponseBody?['results'].length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    if (decodedResponseBody!['results'].length > index &&
                        decodedResponseBody!['results'][index]['poster_path'] !=
                            null) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.pushNamed(
                              context,
                              '/movie',
                              arguments: decodedResponseBody!['results'][index]
                                  ["id"],
                            );
                          });
                        },
                        child: Movie(
                          dataMovie: decodedResponseBody!['results'][index],
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
