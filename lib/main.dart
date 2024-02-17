import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:netfixe/pages/discover.dart';
import 'package:netfixe/pages/home.dart';
import 'package:netfixe/pages/movieview.dart';

void main() async {
  await dotenv.load(fileName: "lib/.env");
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NetFixe',
      theme: ThemeData.dark(),
      initialRoute: "/",
      routes: {
        '/': (context) => const Home(),
        '/movie': (context) => const MovieView(),
        '/discover': (context) => const Discover(),
      },
    );
  }
}
