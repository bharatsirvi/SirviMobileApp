import 'package:flutter/material.dart';
import 'package:sirvi_mobile_app/models/userModel.dart';

class UserProvider with ChangeNotifier {
  User _user = User(
      id: "",
      name: "",
      mobile: "",
      password: "",
      dob: "",
      email: "",
      gotra: "",
      father_name: "",
      gender: "",
      profilePic: "");

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setProfilePic(String profilePic) {
    _user.profilePic = profilePic;
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
