import 'package:cloud_firestore/cloud_firestore.dart';

class Owner {
  String name;
  String email;
  String avatar;
  String address;
  List<String> dogs;
  List<String> friends;

  Owner(
      {required this.name,
      required this.email,
      required this.avatar,
      required this.address,
      required this.dogs,
      required this.friends});

  Owner.fromJson(QueryDocumentSnapshot<Object?>? json)
      : name = json!['name'],
        email = json!['email'],
        avatar = json!['avatar'],
        address = json!['address'],
        dogs = json!['dogs'],
        friends = json!['friends'];
}
