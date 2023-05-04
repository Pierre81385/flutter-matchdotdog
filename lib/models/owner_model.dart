import 'package:cloud_firestore/cloud_firestore.dart';

class Owner {
  String uid;
  String name;
  String email;
  String avatar;
  double locationLat;
  double locationLong;
  List<dynamic> dogs;
  //List<dynamic> friends;

  Owner({
    required this.uid,
    required this.name,
    required this.email,
    required this.avatar,
    required this.locationLat,
    required this.locationLong,
    required this.dogs,
    //required this.friends
  });

  Owner.fromJson(QueryDocumentSnapshot<Object?>? json)
      : uid = json!['uid'],
        name = json!['name'],
        email = json!['email'],
        avatar = json!['avatar'],
        locationLat = json!['locationLat'],
        locationLong = json!['locationLong'],
        dogs = json!['dogs']
  //friends = json!['friends']
  ;

  factory Owner.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Owner(
      uid: data?['uid'],
      name: data?['name'],
      email: data?['email'],
      avatar: data?['avatar'],
      locationLat: data?['locationLat'],
      locationLong: data?['locationLong'],
      dogs: [data?['dogs']],
      //friends: [data?['friends']],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) "uid": uid,
      if (name != null) "name": name,
      if (email != null) "email": email,
      if (avatar != null) "avatar": avatar,
      if (locationLat != null) "locationLat": locationLat,
      if (locationLong != null) "locationLong": locationLong,
      if (dogs != null) "dogs": dogs,
      //if (friends != null) "friends": friends,
    };
  }
}
