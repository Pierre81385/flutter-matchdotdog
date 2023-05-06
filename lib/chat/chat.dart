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

import '../models/chat_model.dart';
import '../models/dog_model.dart';
import '../models/owner_model.dart';

class ChatView extends StatefulWidget {
  const ChatView(
      {super.key, required this.dog, required this.owner, required this.buddy});

  final Dog dog;
  final Dog buddy;
  final Owner owner;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late Dog _currentDog;
  late Owner _currentUser;
  late Dog _buddy;
  late Owner _buddyOwner;
  late DocumentSnapshot _docSnap;
  final firestoreInstance = FirebaseFirestore.instance;
  late DocumentReference<Owner> ref;
  bool _isProcessing = false;
  late Stream<QuerySnapshot> _chatStream;

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

    _chatStream = FirebaseFirestore.instance
        .collection('chats')
        .where('dogId', isEqualTo: _currentDog.id)
        .where('buddyId', isEqualTo: _buddy.id)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _isProcessing
              ? CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(_buddy.photo),
                          ),
                          Text(_buddy.name)
                        ],
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: _chatStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("Looking for messages!");
                          }

                          return snapshot.hasData
                              ? Container(
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        physics: const ScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        reverse: true,
                                        shrinkWrap: true,
                                        itemCount: snapshot.data?.docs.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          Chat _chat = Chat.fromJson(
                                              snapshot.data?.docs[index]);
                                          return ListTile(
                                            title: Text(_chat.message),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                )
                              : Expanded(child: Text('Get this chat started!'));
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(child: TextField()),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.send_sharp,
                                  color: Colors.black,
                                ))
                          ],
                        ),
                      )
                    ]),
        ),
      ),
    );
  }
}
