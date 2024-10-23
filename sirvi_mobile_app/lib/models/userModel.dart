// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String id;
  final String name;
  final String mobile;
  final String? password;
  final String? email;
  final String? dob;
  final String? gotra;
  final String? father_name;
  final String? gender;
  String? profilePic;

  User(
      {required this.id,
      required this.name,
      required this.mobile,
      required this.password,
      required this.dob,
      required this.email,
      required this.gotra,
      required this.father_name,
      required this.gender,
      required this.profilePic});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'mobile': mobile,
      'password': password,
      'email': email,
      'dob': dob,
      'gotra': gotra,
      'father_name': father_name,
      'gender': gender,
      'profilePic': profilePic,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        id: map['_id'] as String,
        name: map['name'] as String,
        mobile: map['mobile'] as String,
        password: map['password'] != null ? map['password'] as String : "",
        email: map['email'] != null ? map['email'] as String : "",
        dob: map['dob'] != null ? map['dob'] as String : "",
        gotra: map['gotra'] != null ? map['gotra'] as String : "",
        father_name:
            map['father_name'] != null ? map['father_name'] as String : "",
        gender: map['gender'] != null ? map['gender'] as String : "",
        profilePic: "");
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
