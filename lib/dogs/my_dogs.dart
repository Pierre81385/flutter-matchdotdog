import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matchdotdog/dogs/all_buddies.dart';
import 'package:matchdotdog/dogs/dog_details.dart';
import 'package:matchdotdog/dogs/register_my_dog.dart';
import 'package:matchdotdog/models/dog_model.dart';

import '../models/owner_model.dart';

class MyDogs extends StatefulWidget {
  const MyDogs({super.key, required this.owner});

  final Owner owner;

  @override
  State<MyDogs> createState() => _MyDogsState();
}

class _MyDogsState extends State<MyDogs> {
  late Owner _currentOwner;
  late Stream<QuerySnapshot> _myDogsStream;

  @override
  void initState() {
    _currentOwner = widget.owner;
    _myDogsStream = FirebaseFirestore.instance
        .collection('dogs')
        .where('owner', isEqualTo: _currentOwner.uid)
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _myDogsStream,
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
          if (snapshot2.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot2.connectionState == ConnectionState.waiting) {
            return const Text("Looking for dogs!");
          }

          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/dogs.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                ListView.builder(
                  physics: const ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot2.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    Dog _dog = Dog.fromJson(snapshot2.data?.docs[index]);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
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
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          onLongPress: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => DogDetails(
                                      dog: _dog, owner: _currentOwner)
                                  //MyDogsRedirect(user: user)
                                  ),
                            );
                          },
                          leading: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(_dog.photo),
                          ),
                          title: Text(_dog.name),
                          subtitle: Text(
                              (_dog.buddies.length.toString() as String) +
                                  " friends"),
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => AllBuddies(
                                        dog: _dog, owner: _currentOwner)
                                    //MyDogsRedirect(user: user)
                                    ),
                              );
                            },
                            icon: Icon(Icons.pets),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  width: deviceWidth * .33,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => RegisterMyDog(
                                  owner: _currentOwner,
                                  referrer: 'mydogs',
                                )
                            //MyDogsRedirect(user: user)
                            ),
                      );
                    },
                    child: Icon(Icons.add),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
