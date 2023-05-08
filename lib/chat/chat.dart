//need to check for friends
//if friends yes, create a chat for each friend
//if chat selected get all docs and create a list of chats in date/time order
//if message sent update collection with new chat content
//if friends no, then display error to user
//have delete option for chats

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matchdotdog/dogs/all_buddies.dart';
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
  final _messageFormKey = GlobalKey<FormState>();

  final _messageTextController = TextEditingController();
  final _messageFocus = FocusNode();
  bool _isProcessing = false;
  bool _isSending = false;
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
    _isSending = false;
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
    setState(() {
      _isSending = false;
    });
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  color: Colors.black,
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => AllBuddies(
                                              owner: _currentUser,
                                              dog: _currentDog)),
                                    );
                                  },
                                  icon: Icon(Icons.arrow_back_ios_new)),
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(_buddy.photo),
                              ),
                              IconButton(
                                  color: Colors.black,
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomePage(owner: _currentUser)),
                                    );
                                  },
                                  icon: Icon(Icons.person)),
                            ],
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
                            return const Text("Get this chat started!");
                          }

                          return Container(
                            child: Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
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
                                        leading: _chat.sender == _buddy.owner
                                            ? CircleAvatar(
                                                radius: 50,
                                                backgroundImage:
                                                    NetworkImage(_buddy.photo),
                                              )
                                            : null,
                                        trailing: _chat.sender ==
                                                _currentUser.uid
                                            ? CircleAvatar(
                                                radius: 50,
                                                backgroundImage: NetworkImage(
                                                    _currentDog.photo),
                                              )
                                            : null,
                                        title: Text(
                                          _chat.message,
                                          textAlign:
                                              _chat.sender == _currentUser.uid
                                                  ? TextAlign.end
                                                  : TextAlign.start,
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Form(
                                key: _messageFormKey,
                                child: TextFormField(
                                  controller: _messageTextController,
                                  focusNode: _messageFocus,
                                  decoration: InputDecoration(
                                    labelText: 'Message...',
                                    fillColor: Colors.white,
                                    icon: Icon(Icons.message),
                                  ),
                                ),
                              ),
                            ),
                            _isSending
                                ? CircularProgressIndicator()
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isSending = true;
                                      });
                                      String id = firestoreInstance
                                          .collection("chats")
                                          .doc()
                                          .id;

                                      firestoreInstance
                                          .collection("chats")
                                          .doc(id)
                                          .set({
                                        "id": id,
                                        "dogId": _currentDog.id,
                                        "buddyId": _buddy.id,
                                        "sender": _currentUser.uid,
                                        "timestamp": Timestamp.now(),
                                        "message": _messageTextController.text,
                                        "attachment": ""
                                      });

                                      _messageTextController.text = "";
                                    },
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
