import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final Function onTap;
  final String currentPage;
  const Footer({super.key, required this.onTap, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Accueil button
        GestureDetector(
          onTap: () => onTap("/"),
          child: BottomToolbarButton(
            icon: Icons.home,
            text: 'Accueil',
            color: currentPage == "/"
                ? Colors.white
                : const Color.fromARGB(100, 255, 255, 255),
          ),
        ),
        // Découvert button
        GestureDetector(
          onTap: () => onTap('/discover'),
          child: BottomToolbarButton(
            icon: Icons.movie_creation_outlined,
            text: 'Découvrir',
            color: currentPage == "/discover"
                ? Colors.white
                : const Color.fromARGB(100, 255, 255, 255),
          ),
        ),
        // Search button
        GestureDetector(
          onTap: () => onTap('/search'),
          child: BottomToolbarButton(
            icon: Icons.search_rounded,
            text: 'Recherche',
            color: currentPage == "/search"
                ? Colors.white
                : const Color.fromARGB(100, 255, 255, 255),
          ),
        ),
      ],
    );
  }
}

class BottomToolbarButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const BottomToolbarButton({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      height: 80,
      color: Colors.black,
      child: Center(
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
