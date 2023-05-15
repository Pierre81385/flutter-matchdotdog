import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:matchdotdog/user/home.dart';

import '../dogs/dog_details.dart';
import '../models/dog_model.dart';
import '../models/owner_model.dart';
import 'chat.dart';

class ChatMenuContd extends StatefulWidget {
  const ChatMenuContd({super.key, required this.owner, required this.buddy});

  final Owner owner;
  final Dog buddy;

  @override
  State<ChatMenuContd> createState() => _ChatMenuContdState();
}

class _ChatMenuContdState extends State<ChatMenuContd> {
  late Owner _currentOwner;
  late Dog _currentBuddy;
  late Stream<QuerySnapshot> _myDogsStream;

  @override
  void initState() {
    _currentOwner = widget.owner;
    _currentBuddy = widget.buddy;
    _myDogsStream = FirebaseFirestore.instance
        .collection('dogs')
        .where('owner', isEqualTo: _currentOwner.uid)
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _myDogsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Get this chat started!");
        }

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Text('Choose a dog to chat as...'),
                ListView.builder(
                  physics: const ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  reverse: false,
                  shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    Dog _dog = Dog.fromJson(snapshot.data?.docs[index]);

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
                                    builder: (context) => ChatView(
                                          dog: _dog,
                                          owner: _currentOwner,
                                          buddy: _currentBuddy,
                                          referrer: 'chatMenu',
                                        )),
                              );
                            },
                            icon: Icon(Icons.chat),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                              owner: _currentOwner, referrer: 'chatViewContd')),
                    );
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
