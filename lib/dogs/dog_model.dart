class Dog {
  String owner;
  String photo;
  String name;
  String description;
  int gender;
  double size;
  double activity;
  double age;

  Dog(
      {required this.owner,
      required this.photo,
      required this.name,
      required this.description,
      required this.gender,
      required this.size,
      required this.activity,
      required this.age});

  sizeConverter(size) {
    //method to convert size double to size string value
  }

  activityConverter(activity) {
    //method to convert activity double to activity string value
  }
}
