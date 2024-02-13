import 'package:flutter/material.dart';

class MovieView extends StatefulWidget {
  const MovieView({super.key});

  @override
  State<MovieView> createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 13, 34),
      appBar: AppBar(
        title: const Text('BMI CALCULATOR'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 10, 13, 34),
        elevation: 1.0,
        leading: const Icon(Icons.menu_rounded),
      ),
      body: const Padding(
        padding: EdgeInsets.all(25.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Your Result",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        // onTap: () => handleClick(context),
        child: Container(
          padding: const EdgeInsets.all(15.0),
          height: 70,
          color: const Color.fromARGB(255, 235, 21, 85),
          child: const Center(
            child: Text(
              'RE-CALCULATE YOUR BMI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
