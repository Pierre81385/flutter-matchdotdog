import 'package:flutter/material.dart';
import 'package:matchdotdog/ui/paws.dart';

class MainBackground extends StatelessWidget {
  const MainBackground({super.key});

  get mainColor => null;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.0),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor
          ],
          stops: [0.0, 1.0],
        ),
      ),
      child: Paws(),
    );
  }
}
