import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:matchdotdog/dogs/details/my_dogs_details.dart';
import 'package:matchdotdog/user/home.dart';

import '../chat/chat_menu.dart';
import '../chat/chat_menu_contd.dart';
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
  bool _showDetails = false;
  bool _chatPage = false;
  late Dog _chatBuddy;

  @override
  void initState() {
    _currentDog = widget.dog;
    _showDetails = false;
    _currentOwner = widget.owner;
    _chatPage = false;

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
                      child: Column(
                        children: [
                          _showDetails
                              ? IconButton(
                                  color: Colors.black,
                                  onPressed: () {
                                    setState(() {
                                      _showDetails = false;
                                    });
                                  },
                                  icon: Icon(Icons.keyboard_arrow_down))
                              : IconButton(
                                  color: Colors.black,
                                  onPressed: () {
                                    setState(() {
                                      _showDetails = true;
                                    });
                                  },
                                  icon: Icon(Icons.keyboard_arrow_up)),
                          _showDetails
                              ? MyDogsDetails(dog: _currentDog)
                              : SizedBox(),
                          Row(
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
                                  IconButton(
                                    iconSize: 50,
                                    //check if _currentDog has liked this buddy or not
                                    color: Colors.red,
                                    icon: const Icon(Icons.pets_rounded),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              IconButton(
                                  color: Colors.black,
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => _chatPage
                                            ? ChatMenuContd(
                                                owner: _currentOwner,
                                                buddy: _chatBuddy)
                                            : ChatMenu(
                                                owner: _currentOwner,
                                                next: (bool? value) {
                                                  setState(() {
                                                    _chatPage = value!;
                                                  });
                                                },
                                                buddy: (Dog? value) {
                                                  setState(() {
                                                    _chatBuddy = value!;
                                                  });
                                                },
                                              ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.chat)),
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
