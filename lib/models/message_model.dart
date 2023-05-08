import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  String code;
  List<dynamic> dogs;
  String sender;
  Timestamp time;
  String message;
  String attachment;

  Message({
    required this.id,
    required this.code,
    required this.dogs,
    required this.sender,
    required this.time,
    required this.message,
    required this.attachment,
  });

  Message.fromJson(QueryDocumentSnapshot<Object?>? json)
      : id = json!['id'],
        code = json!['code'],
        dogs = json!['dogs'],
        sender = json!['sender'],
        time = json!['time'],
        message = json!['message'],
        attachment = json!['attachment'];

  factory Message.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Message(
        id: data?['id'],
        code: data?['code'],
        dogs: data?['dogs'],
        sender: data?['sender'],
        time: data?['time'],
        message: data?['message'],
        attachment: data?['attachment']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (dogs != null) 'dogs': dogs,
      if (sender != null) 'sender': sender,
      if (time != null) 'time': time,
      if (message != null) 'message': message,
      if (attachment != null) 'attachment': attachment
    };
  }
}
