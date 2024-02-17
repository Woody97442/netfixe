import 'package:flutter/material.dart';
import 'package:netfixe/components/footer.dart';
import 'package:netfixe/components/header.dart';
import 'package:netfixe/components/iframeyoutubevideo.dart';
import 'package:netfixe/customs_icons/spinload.dart';
import 'package:netfixe/utils/tool.dart';

class MovieView extends StatefulWidget {
  const MovieView({super.key});

  @override
  State<MovieView> createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? dataMovie;
  Map<String, dynamic>? dataVideo;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    int? idMovie = ModalRoute.of(context)!.settings.arguments as int?;
    if (idMovie != null) {
      getDetailMovie(idMovie.toString());
      getVideo(idMovie.toString());
    }
  }

  void getDetailMovie(String idMovie) async {
    final result = await getMovieSearch("", "movie/$idMovie");
    setState(
      () {
        dataMovie = result;
      },
    );
  }

  void getVideo(String idMovie) async {
    final result = await getVideoWithId("fr-FR", idMovie);
    setState(
      () {
        dataVideo = result;
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (dataMovie != null) {
      String title = dataMovie!['title'];
      String imgUrl = dataMovie!['poster_path'];
      String desc = dataMovie!['overview'];

      // Vérifier si dataVideo est disponible
      String videoUrl = '';
      String videoTitle = '';
      if (dataVideo != null && dataVideo!['results'].isNotEmpty) {
        videoUrl = dataVideo!['results'][0]['key'];
        videoTitle = dataVideo!['results'][0]['name'];
      }

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
                  ),
                  const SizedBox(height: 50),
                  // Afficher la partie vidéo uniquement si videoUrl est disponible
                  videoUrl.isNotEmpty
                      ? Column(
                          children: [
                            Text(
                              videoTitle,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            IframeYoutubeVideo(keyMovie: videoUrl),
                          ],
                        )
                      : Container(),
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
}
