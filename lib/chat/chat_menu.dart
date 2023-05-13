import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:matchdotdog/chat/chat.dart';
import 'package:matchdotdog/chat/chat_menu_contd.dart';

import '../dogs/dog_details.dart';
import '../models/dog_model.dart';
import '../models/owner_model.dart';

class ChatMenu extends StatefulWidget {
  const ChatMenu({super.key, required this.owner});

  final Owner owner;

  @override
  State<ChatMenu> createState() => _ChatMenuState();
}

class _ChatMenuState extends State<ChatMenu> {
  late Owner _currentOwner;
  late Dog _chatAs;
  late Stream<QuerySnapshot> _chatStream;

  @override
  void initState() {
    _currentOwner = widget.owner;
    _chatStream = FirebaseFirestore.instance
        .collection('dogs')
        .where('owner', isNotEqualTo: _currentOwner.uid)
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Get this chat started!");
        }

        return Column(
          children: [
            ListView.builder(
              physics: const ScrollPhysics(),
              scrollDirection: Axis.vertical,
              reverse: false,
              shrinkWrap: true,
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (BuildContext context, int index) {
                Dog _chatBuddy = Dog.fromJson(snapshot.data?.docs[index]);

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
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListTile(
                      onLongPress: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => DogDetails(
                                  dog: _chatBuddy, owner: _currentOwner)
                              //MyDogsRedirect(user: user)
                              ),
                        );
                      },
                      leading: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(_chatBuddy.photo),
                      ),
                      title: Text(_chatBuddy.name),
                      subtitle: Text(
                          (_chatBuddy.buddies.length.toString() as String) +
                              " friends"),
                      trailing: IconButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => ChatMenuContd(
                                    owner: _currentOwner, buddy: _chatBuddy)),
                          );
                        },
                        icon: Icon(Icons.chat),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
