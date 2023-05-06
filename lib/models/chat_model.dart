import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String id;
  String dogId;
  String buddyId;
  String sender;
  Double timestamp;
  String message;
  String attachment;

  Chat({
    required this.id,
    required this.dogId,
    required this.buddyId,
    required this.sender,
    required this.timestamp,
    required this.message,
    required this.attachment,
  });

  Chat.fromJson(QueryDocumentSnapshot<Object?>? json)
      : id = json!['id'],
        dogId = json!['dogId'],
        buddyId = json!['buddyId'],
        sender = json!['sender'],
        timestamp = json!['timestamp'],
        message = json!['message'],
        attachment = json!['attachment'];

  factory Chat.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Chat(
        id: data?['id'],
        dogId: data?['dogId'],
        buddyId: data?['buddyId'],
        sender: data?['sender'],
        timestamp: data?['timestamp'],
        message: data?['message'],
        attachment: data?['attachment']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) 'id': id,
      if (dogId != null) 'dogId': dogId,
      if (buddyId != null) 'buddyId': buddyId,
      if (sender != null) 'sender': sender,
      if (timestamp != null) 'timestamp': timestamp,
      if (message != null) 'message': message,
      if (attachment != null) 'attachment': attachment
    };
  }
}
