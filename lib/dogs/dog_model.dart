import 'dart:ffi';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@JsonSerializable()
class Dog {
  String owner;
  String photo;
  String name;
  int gender;
  double size;
  double activity;
  double age;
  double lat;
  double long;
  List<dynamic> liked;

  Dog(
      {required this.owner,
      required this.photo,
      required this.name,
      required this.gender,
      required this.size,
      required this.activity,
      required this.age,
      required this.lat,
      required this.long,
      required this.liked});

  Dog.fromJson(QueryDocumentSnapshot<Object?>? json)
      : owner = json!['owner'],
        photo = json['image'],
        name = json['name'],
        gender = json['gender'],
        size = json['size'],
        activity = json['activity'],
        age = json['age'],
        lat = json['lat'],
        long = json['long'],
        liked = json['liked'];

  // factory Dog.fromDocument(QueryDocumentSnapshot<Object?>? doc) {
  //   final data = doc?.data()! as Map<String, dynamic>;
  //   return Dog.fromJson(data);
  // }
  sizeConverter(size) {
    //method to convert size double to size string value
  }

  activityConverter(activity) {
    //method to convert activity double to activity string value
  }
}
