import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../dog_model.dart';
import 'drag_widget.dart';

class CardsStackWidget extends StatefulWidget {
  final User user;
  const CardsStackWidget({required this.user});

  @override
  State<CardsStackWidget> createState() => _CardsStackWidgetState();
}

class _CardsStackWidgetState extends State<CardsStackWidget> {
  // List<Profile> dragabbleItems = [
  //   const Profile(
  //       name: 'Rohini',
  //       distance: '10 miles away',
  //       imageAsset: 'assets/images/avatar_1.png'),
  //   const Profile(
  //       name: 'Rohini',
  //       distance: '10 miles away',
  //       imageAsset: 'assets/images/avatar_2.png'),
  //   const Profile(
  //       name: 'Rohini',
  //       distance: '10 miles away',
  //       imageAsset: 'assets/images/avatar_3.png'),
  //   const Profile(
  //       name: 'Rohini',
  //       distance: '10 miles away',
  //       imageAsset: 'assets/images/avatar_4.png'),
  //   const Profile(
  //       name: 'Rohini',
  //       distance: '10 miles away',
  //       imageAsset: 'assets/images/avatar_5.png'),
  // ];

  late User _currentUser;
  late Dog _dog;
  late Stream<QuerySnapshot> _myDogsStream;
  late Stream<QuerySnapshot> _allDogsStream;
  late int snapshotLength;

  @override
  void initState() {
    _currentUser = widget.user;
    _myDogsStream = FirebaseFirestore.instance
        .collection('dogs')
        .where('owner', isEqualTo: _currentUser.uid)
        .snapshots();
    _allDogsStream = FirebaseFirestore.instance
        .collection('dogs')
        .where('liked', arrayContains: _currentUser.uid)
        .snapshots();
    super.initState();
  }

  ValueNotifier<Swipe> swipeNotifier = ValueNotifier(Swipe.none);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _myDogsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          print(snapshot.data?.docs[1]);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ValueListenableBuilder(
                  valueListenable: swipeNotifier,
                  builder: (context, swipe, child) => Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: List.generate(snapshot.data?.docs.length as int,
                        (index) {
                      return DragWidget(
                        profile: Dog.fromJson(snapshot.data?.docs[index]),
                        index: index,
                        swipeNotifier: swipeNotifier,
                      );
                    }),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                child: DragTarget<int>(
                  builder: (
                    BuildContext context,
                    List<dynamic> accepted,
                    List<dynamic> rejected,
                  ) {
                    return IgnorePointer(
                      child: Container(
                        height: 700.0,
                        width: 80.0,
                        color: Colors.transparent,
                      ),
                    );
                  },
                  onAccept: (int index) {
                    setState(() {
                      // dragabbleItems.removeAt(index);
                      print('liked!!!');
                    });
                  },
                ),
              ),
              Positioned(
                right: 0,
                child: DragTarget<int>(
                  builder: (
                    BuildContext context,
                    List<dynamic> accepted,
                    List<dynamic> rejected,
                  ) {
                    return IgnorePointer(
                      child: Container(
                        height: 700.0,
                        width: 80.0,
                        color: Colors.transparent,
                      ),
                    );
                  },
                  onAccept: (int index) {
                    setState(() {
                      // dragabbleItems.removeAt(index);
                      print('dis-liked!!!');
                    });
                  },
                ),
              ),
            ],
          );
        });
  }
}
