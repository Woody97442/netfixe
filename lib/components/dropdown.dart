import 'package:flutter/material.dart';

const List<String> list = <String>[
  "Action",
  "Aventure",
  "Animation",
  "Comédie",
  "Crime",
  "Documentaire",
  "Drame",
  "Familial",
  "Fantastique",
  "Histoire",
  "Horreur",
  "Musique",
  "Mystère",
  "Romance",
  "Science-Fiction",
  "Téléfilm",
  "Thriller",
  "Guerre",
  "Western"
];

class DropDown extends StatefulWidget {
  const DropDown({super.key});

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      initialSelection: list.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
