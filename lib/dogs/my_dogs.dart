import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
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

          return Column(
            children: [
              ListView.builder(
                physics: const ScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot2.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage(snapshot2.data?.docs[index]['photo']),
                    ),
                    title: Text(snapshot2.data?.docs[index]['name']),
                    subtitle: Text((snapshot2
                            .data?.docs[index]['buddies'].length
                            .toString() as String) +
                        " friends"),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
