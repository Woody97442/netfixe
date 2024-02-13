import 'package:flutter/material.dart';
import 'package:netfixe/home.dart';
import 'package:netfixe/movieview.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple BMI Calculator',
      theme: ThemeData.dark(),
      initialRoute: "/",
      routes: {
        '/': (context) => const Home(),
        '/movie': (context) => const MovieView(),
      },
    );
  }
}
