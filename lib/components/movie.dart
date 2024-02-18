import 'package:flutter/material.dart';

class Movie extends StatelessWidget {
  final Map<String, dynamic>? dataMovie;
  const Movie({super.key, this.dataMovie});

  gendeMovie(int idGenre) {
    List<Map<String, Object>> listGenre = [
      {"id": 28, "name": "Action"},
      {"id": 12, "name": "Aventure"},
      {"id": 16, "name": "Animation"},
      {"id": 35, "name": "Comédie"},
      {"id": 80, "name": "Crime"},
      {"id": 99, "name": "Documentaire"},
      {"id": 18, "name": "Drame"},
      {"id": 10751, "name": "Familial"},
      {"id": 14, "name": "Fantastique"},
      {"id": 36, "name": "Histoire"},
      {"id": 27, "name": "Horreur"},
      {"id": 10402, "name": "Musique"},
      {"id": 9648, "name": "Mystère"},
      {"id": 10749, "name": "Romance"},
      {"id": 878, "name": "Science-Fiction"},
      {"id": 10770, "name": "Téléfilm"},
      {"id": 53, "name": "Thriller"},
      {"id": 10752, "name": "Guerre"},
      {"id": 37, "name": "Western"}
    ];

    if (idGenre > 0) {
      for (var i = 0; i < listGenre.length; i++) {
        if (listGenre[i]["id"] == idGenre) {
          return listGenre[i]['name'];
        }
      }
    }
  }

  String convertToFrenchDate(String? englishDate) {
    if (englishDate == null || englishDate.isEmpty) {
      return "N/A";
    }

    // Convertir la date anglaise en objet DateTime
    DateTime dateTime = DateTime.parse(englishDate);

    // Formater la date en format français
    String formattedDate =
        "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (dataMovie?['poster_path'] != null)
            ? Image.network(
                "https://image.tmdb.org/t/p/w600_and_h900_bestv2${dataMovie?['poster_path']}",
                fit: BoxFit.cover,
                alignment: Alignment.center,
                height: 300,
              )
            : Container(
                color: const Color.fromARGB(10, 255, 255, 255),
                height: 300,
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  dataMovie?['title'],
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
        const SizedBox(height: 15),
        Text("Note : ${dataMovie?['vote_average'].toString()}"),
        Wrap(
          children: [
            const Text("Genre : "),
            if (dataMovie!['genre_ids'] != 0)
              for (var i = 0; i < 2; i++)
                if (dataMovie!['genre_ids'].length > i)
                  Text(
                    "${gendeMovie(dataMovie!['genre_ids'][i])} ",
                    style: const TextStyle(fontSize: 10),
                  ),
          ],
        ),
        Text(
          "Date : ${convertToFrenchDate(dataMovie?['release_date'])}",
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }
}
