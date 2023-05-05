//need to check for friends
//if friends yes, create a chat for each friend
//if chat selected get all docs and create a list of chats in date/time order
//if message sent update collection with new chat content
//if friends no, then display error to user
//have delete option for chats

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matchdotdog/user/home.dart';

import '../models/dog_model.dart';
import '../models/owner_model.dart';

class Chat extends StatefulWidget {
  const Chat(
      {super.key, required this.dog, required this.owner, required this.buddy});

  final Dog dog;
  final Dog buddy;
  final Owner owner;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late Dog _currentDog;
  late Owner _currentUser;
  late Dog _buddy;
  late Owner _buddyOwner;
  late DocumentSnapshot _docSnap;
  final firestoreInstance = FirebaseFirestore.instance;
  late DocumentReference<Owner> ref;
  bool _isProcessing = false;

  void getBuddyOwner() async {
    ref =
        firestoreInstance.collection("owners").doc(_buddy.owner).withConverter(
              fromFirestore: Owner.fromFirestore,
              toFirestore: (Owner owner, _) => owner.toFirestore(),
            );

    final docSnap = await ref.get();

    _buddyOwner = docSnap.data()!;
    setState(() {
      _isProcessing = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _isProcessing = true;
    //get current dog
    _currentDog = widget.dog;
    //get current user
    _currentUser = widget.owner;
    //get buddy
    _buddy = widget.buddy;
    //get buddy owner
    getBuddyOwner();
  }

  //if no buddies, display message

  //buddy + owner on top
  //dog + user on bottom

  //set message from dog/user

  //display stream of dog/user + buddy/owner exchange
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isProcessing
            ? CircularProgressIndicator()
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(_currentUser.name + ' and ' + _currentDog.name),
                Text('chat with'),
                Text(_buddy.name + ' and ' + _buddyOwner.name),
                IconButton(
                    color: Colors.black,
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) =>
                                HomePage(owner: _currentUser)),
                      );
                    },
                    icon: Icon(Icons.arrow_back_ios))
              ]),
      ),
    );
  }
}
