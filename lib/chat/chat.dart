//need to check for friends
//if friends yes, create a chat for each friend
//if chat selected get all docs and create a list of chats in date/time order
//if message sent update collection with new chat content
//if friends no, then display error to user
//have delete option for chats

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    //get current dog
    _currentDog = widget.dog;
    print(_currentDog);
    //get current user
    _currentUser = widget.owner;
    print(_currentUser);
    //get buddy
    _buddy = widget.buddy;
    print(_buddy);
    //get buddy owner
    _buddyOwner = Owner.fromJson(FirebaseFirestore.instance
        .collection('owners')
        .doc(_buddy.owner)
        .get() as QueryDocumentSnapshot<Object?>?);
    print(_buddyOwner);
  }

  //if no buddies, display message

  //buddy + owner on top
  //dog + user on bottom

  //set message from dog/user

  //display stream of dog/user + buddy/owner exchange
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
