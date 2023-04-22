import 'package:cloud_firestore/cloud_firestore.dart';

class Dog {
  String owner;
  String photo;
  String name;
  int gender;
  double size;
  double activity;
  double age;

  Dog({
    required this.owner,
    required this.photo,
    required this.name,
    required this.gender,
    required this.size,
    required this.activity,
    required this.age,
  });

  Dog.fromJson(QueryDocumentSnapshot<Object?>? json)
      : owner = json!['owner'],
        photo = json['photo'],
        name = json['name'],
        gender = json['gender'],
        size = json['size'],
        activity = json['activity'],
        age = json['age'];

  factory Dog.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Dog(
      owner: data?['owner'],
      photo: data?['photo'],
      name: data?['name'],
      gender: data?['gender'],
      size: data?['size'],
      activity: data?['activity'],
      age: data?['age'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (owner != null) "owner": owner,
      if (photo != null) "photo": photo,
      if (name != null) "name": name,
      if (gender != null) "gender": gender,
      if (size != null) "size": size,
      if (activity != null) "activity": activity,
      if (age != null) "age": age,
    };
  }
  // factory Dog.fromDocument(QueryDocumentSnapshot<Object?>? doc) {
  //   final data = doc?.data()! as Map<String, dynamic>;
  //   return Dog.fromJson(data);
  // }
}
