class UserModel {
  String? id, name, phoneNumber, language;
  UserModel({this.id, this.name, this.phoneNumber, this.language});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        name: json['name'],
        phoneNumber: json['phoneNumber'],
        language: json['language']);
  }
}
