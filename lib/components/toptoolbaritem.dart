import 'package:flutter/material.dart';

class TopToolBarItem extends StatelessWidget {
  final String title;
  final Icon? icon;
  final bool isActive;

  const TopToolBarItem({
    super.key,
    required this.title,
    this.icon,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: isActive
              ? Colors.white
              : const Color.fromARGB(120, 255, 255, 255),
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
            style: TextStyle(
              color: isActive
                  ? Colors.white
                  : const Color.fromARGB(120, 255, 255, 255),
            ),
          ),
          if (icon != null) icon!,
        ],
      ),
    );
  }
}
