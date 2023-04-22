import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Paws extends StatelessWidget {
  const Paws({super.key});

  @override
  Widget build(BuildContext context) {
    const mainColor = Color.fromARGB(255, 94, 168, 172);
    const secondaryColor = const Color(0xFFFBF7F4);
    const accentColor = Color.fromARGB(255, 242, 202, 25);

    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.pets,
                size: 100,
                color: accentColor,
              ),
              Icon(
                Icons.pets,
                size: 75,
                color: accentColor,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.pets,
                size: 200,
                color: accentColor,
              ),
              Icon(
                Icons.pets,
                size: 50,
                color: accentColor,
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.pets,
                size: 225,
                color: accentColor,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.pets,
                size: 75,
                color: accentColor,
              ),
              Icon(
                Icons.pets,
                size: 200,
                color: accentColor,
              ),
              Icon(
                Icons.pets,
                size: 150,
                color: accentColor,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.pets,
                size: 100,
                color: accentColor,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.pets,
                size: 100,
                color: accentColor,
              ),
              Icon(
                Icons.pets,
                size: 50,
                color: accentColor,
              ),
              Icon(
                Icons.pets,
                size: 75,
                color: accentColor,
              ),
            ],
          )
        ],
      ),
    );
  }
}
