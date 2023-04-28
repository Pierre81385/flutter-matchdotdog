import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:matchdotdog/models/owner_model.dart';
import '../models/dog_model.dart';
import '../models/owner_model.dart';

class AllBuddies extends StatefulWidget {
  final Owner owner;
  final Dog dog;

  const AllBuddies({super.key, required this.owner, required this.dog});

  @override
  State<AllBuddies> createState() => _AllBuddiesState();
}

class _AllBuddiesState extends State<AllBuddies> {
  late Owner _currentOwner;
  late Dog _currnetDog;
  late Stream<QuerySnapshot> _allBuddiesStream;
  late int _index;

  @override
  void initState() {
    _currentOwner = widget.owner;
    _currnetDog = widget.dog;
    _index = 0;
    _allBuddiesStream = FirebaseFirestore.instance
        .collection('dogs')
        .where('owner', isNotEqualTo: _currentOwner.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return StreamBuilder<QuerySnapshot>(
      stream: _allBuddiesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        Dog buddy = Dog.fromJson(snapshot.data?.docs[_index]);

        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        buddy.photo,
                        width: width,
                        height: height,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Text(buddy.name),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _index == 0
                            ? SizedBox(height: 10, width: 10)
                            : Container(
                                height: height,
                                width: width * .2,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _index--;
                                    });
                                  },
                                ),
                              ),
                        (_index + 1) == snapshot.data?.docs.length
                            ? SizedBox(height: 10, width: 10)
                            : Container(
                                height: height,
                                width: width * .2,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _index++;
                                    });
                                  },
                                ),
                              ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.person)),
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.pets)),
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.chat)),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
