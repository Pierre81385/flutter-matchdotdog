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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      _currentDog.photo,
                      width: width,
                      height: height,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(24),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withOpacity(0.5),
                        //     spreadRadius: 5,
                        //     blurRadius: 7,
                        //     offset:
                        //         Offset(0, 3), // changes position of shadow
                        //   ),
                        // ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              color: Colors.black,
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => HomePage(
                                            owner: _currentOwner,
                                            referrer: 'allBuddies',
                                          )),
                                );
                              },
                              icon: Icon(Icons.arrow_back_ios_new)),
                          Column(
                            children: [
                              Text(
                                _currentDog.name,
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
