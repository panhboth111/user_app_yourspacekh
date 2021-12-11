class UserModel {
  String? id, name, phoneNumber, language, plateNumber;
  UserModel({this.id, this.name, this.phoneNumber, this.language, this.plateNumber});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        name: json['name'],
        phoneNumber: json['phoneNumber'],
        plateNumber: "",
        language: json['language']);
  }
}
