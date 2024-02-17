import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final double size;
  final bool activeBack;
  const Header({
    super.key,
    required this.size,
    required this.activeBack,
  });

  @override
  Size get preferredSize => Size.fromHeight(size);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'NETFIXE',
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Colors.red,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0.2),
      leading: const ImageIcon(
        AssetImage("assets/img/netflix.png"),
        color: Colors.red,
        size: 24,
      ),
      actions: <Widget>[
        if (activeBack)
          IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}
