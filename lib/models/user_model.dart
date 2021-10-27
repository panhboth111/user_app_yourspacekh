class UserModel {
  String id, name, phoneNumber, language;
  UserModel(
      {required this.id,
      required this.name,
      required this.phoneNumber,
      required this.language});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        name: json['name'],
        phoneNumber: json['phoneNumber'],
        language: json['language']);
  }
}
