//need to check for friends
//if friends yes, create a chat for each friend
//if chat selected get all docs and create a list of chats in date/time order
//if message sent update collection with new chat content
//if friends no, then display error to user
//have delete option for chats

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
