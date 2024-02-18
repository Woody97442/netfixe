import 'package:flutter/material.dart';
import 'package:netfixe/components/footer.dart';
import 'package:netfixe/components/header.dart';
import 'package:netfixe/components/movie.dart';
import 'package:netfixe/components/toptoolbaritem.dart';
import 'package:netfixe/utils/tool.dart';

class Discover extends StatefulWidget {
  const Discover({super.key});

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  Map<String, dynamic>? listMovies;
  final ScrollController _scrollController = ScrollController();

  late int currentPage = 1;
  late bool thisMovie = true;
  late bool thisTv = false;
  late String currentType = "movie";

  void getDiscover() async {
    final result = await findDiscover(
        ["18", "12"], "fr-FR", false, currentPage, currentType);
    setState(
      () {
        listMovies = result;
      },
    );
  }

  void getGetNextPage() async {
    final result = await findDiscover(
        ["18", "12"], "fr-FR", false, currentPage, currentType);
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
    getDiscover();
    _scrollController.addListener(_scrollListener);
  }

  // Fonction de rappel pour l'événement de défilement
  void _scrollListener() {
    // Vérifiez si vous avez atteint le bas de la liste
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(
        () {
          currentPage++;
        },
      );
      getGetNextPage();
    }
  }

  void changeType(String type) {
    setState(
      () {
        currentType = type;
      },
    );
    getDiscover();
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
                    )
                  ],
                ),
                // const DropDown(),
                const SizedBox(height: 20),
                Text("Découvert ${currentType == "movie" ? "Film" : "Séries"}"),
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
          currentPage: '/discover',
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
