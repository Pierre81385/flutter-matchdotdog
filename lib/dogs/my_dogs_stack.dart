import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:matchdotdog/ui/main_background.dart';

import 'cardStack_widget.dart';

class MyDogsSwipeCards extends StatefulWidget {
  final User user;

  const MyDogsSwipeCards({required this.user});

  @override
  State<MyDogsSwipeCards> createState() => _MyDogsSwipeCardsState();
}

class _MyDogsSwipeCardsState extends State<MyDogsSwipeCards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [MainBackground(), CardsStackWidget(user: widget.user)]),
    );
  }
}
