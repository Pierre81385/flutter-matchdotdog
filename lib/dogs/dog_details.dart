import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:matchdotdog/user/home.dart';

import '../models/dog_model.dart';
import '../models/owner_model.dart';
import 'my_dogs.dart';

class DogDetails extends StatefulWidget {
  const DogDetails({super.key, required this.dog, required this.owner});

  final Dog dog;
  final Owner owner;

  @override
  State<DogDetails> createState() => _DogDetailsState();
}

class _DogDetailsState extends State<DogDetails> {
  late Dog _currentDog;
  late Owner _currentOwner;

  @override
  void initState() {
    _currentDog = widget.dog;
    _currentOwner = widget.owner;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text(_currentDog.name)),
          Center(
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            owner: _currentOwner,
                            referrer: 'details',
                          )
                      //MyDogsRedirect(user: user)
                      ),
                );
              },
              child: Icon(Icons.arrow_back_ios),
            ),
          ),
        ],
      ),
    );
  }
}
