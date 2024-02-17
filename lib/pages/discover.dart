import 'package:flutter/material.dart';
import 'package:netfixe/components/footer.dart';
import 'package:netfixe/components/header.dart';
import 'package:netfixe/components/movie.dart';
import 'package:netfixe/utils/tool.dart';

class Discover extends StatefulWidget {
  const Discover({super.key});

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  Map<String, dynamic>? decodedResponseBody;

  void getTrendingMovie() async {
    final result = await getMovieSearch("", 'trending/movie/day');
    setState(
      () {
        decodedResponseBody = result;
      },
    );
  }

  void getTrendingTv() async {
    final result = await getMovieSearch("", 'trending/tv/day');
    setState(
      () {
        decodedResponseBody = result;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getTrendingMovie();
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                  ],
                ),
                // const DropDown(),
                const SizedBox(height: 20),
                const Text("Nouveauté"),
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
