import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:matchdotdog/auth/login.dart';

class MainBackground extends StatefulWidget {
  const MainBackground({super.key});

  @override
  State<MainBackground> createState() => _MainBackgroundState();
}

class _MainBackgroundState extends State<MainBackground> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.0),
          gradient: const LinearGradient(
            colors: [Colors.amber, Colors.pink],
            stops: [0.0, 1.0],
          ),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(children: [
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 7,
                  sigmaY: 7,
                ),
                child: Container(
                  height: 480,
                  width: 340,
                ),
              ),
              Container(
                height: 480,
                width: 340,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.25),
                      )
                    ],
                    border: Border.all(
                        color: Colors.white.withOpacity(0.2), width: 1.0),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.5),
                        Colors.white.withOpacity(0.2)
                      ],
                      stops: [0.0, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.pets_outlined,
                        size: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                          width: 270,
                          child: Text(
                            "Login",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          )),
                      const SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
