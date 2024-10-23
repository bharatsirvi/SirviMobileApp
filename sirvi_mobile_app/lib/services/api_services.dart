import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sirvi_mobile_app/Screen/loginScreen.dart';
import 'package:sirvi_mobile_app/Screen/mainScreen.dart';
import 'package:sirvi_mobile_app/models/gotraModel.dart';
import 'package:sirvi_mobile_app/models/myStudent.dart';
import 'package:sirvi_mobile_app/models/userModel.dart';
import 'package:sirvi_mobile_app/provider/gotra_provider.dart';
import 'package:sirvi_mobile_app/provider/my_business_provider.dart';
import 'package:sirvi_mobile_app/provider/my_students_provider.dart';
import 'package:sirvi_mobile_app/provider/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sirvi_mobile_app/utills/slideAnimation.dart';

class ApiService {
  // static const String baseUrl = 'http://192.168.221.138:8080';
  static const String baseUrl = 'http://192.168.188.138:8080';

  static Future<bool> signupUser({
    required BuildContext context,
    required String name,
    required String mobile,
    required String password,
  }) async {
    try {
      User user = User(
          id: "",
          name: name,
          mobile: mobile,
          password: password,
          dob: "",
          email: "",
          gotra: "",
          father_name: "",
          gender: "",
          profilePic: "");
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: user.toJson(),
      );
      if (response.statusCode == 201) {
        print("User registered successfully ${response.body}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        print("Mobile No already exists");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red[900],
            content: const Text(
              "Mobile Number Already Exists ! Please Try Again.",
              style: TextStyle(color: Colors.white),
            )));
      }
      return true;
    } catch (e) {
      print(
          'Error registering user--------------------------------------------------------------------------..........................>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.......>.............>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[900],
          content: const Text(
            "REGISTRATION FAILED ! Please Try Again.",
            style: TextStyle(color: Colors.white),
          )));
      return false;
    }
  }

  static Future<bool> loginUser({
    required BuildContext context,
    required String mobile,
    required String password,
  }) async {
    final scaffold = ScaffoldMessenger.of(context);

    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      final navigator = Navigator.of(context);
      User user = User(
          id: "",
          name: "",
          mobile: mobile,
          password: password,
          dob: "",
          email: "",
          gotra: "",
          father_name: "",
          gender: "",
          profilePic: "");
      print(user.toJson());
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: user.toJson(),
      );
      if (response.statusCode == 200) {
        print(
            "User logged in successfully --------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${response.body}");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(
            'auth_token', jsonDecode(response.body)['token'].toString());
        prefs.setString(
            'userId', jsonDecode(response.body)['userId'].toString());

        var res = jsonDecode(response.body);
        res['gotra'] = res['gotra_id']?["name"];
        res = jsonEncode(res);
        userProvider.setUser(res);
        await fetchProfilePic(context, jsonDecode(res)['userId'].toString());

        print(
            "User provider --------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${userProvider.user.toJson()}");
        navigator.pushAndRemoveUntil(
          createSlideRoute(MainScreen()),
          (route) => false,
        );
      } else {
        print(
            "Invalid Credentials---------------------------------------------->>>>>>>>>>>>>>>>>>>> ${jsonDecode(response.body)['message']}");
        final msg = jsonDecode(response.body)['message'];
        scaffold.showSnackBar(SnackBar(
            backgroundColor: Colors.red[900],
            content: Text(
              msg,
              style: const TextStyle(color: Colors.white),
            )));
      }
      return true;
    } catch (e) {
      print("error;;;;;;;;;;; ${e.toString()}");
      scaffold.showSnackBar(SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(
            "LOGIN FAILED ! Please Try Again ${e.toString()}",
            style: const TextStyle(color: Colors.white),
          )));
      return false;
    }
  }

  static Future<bool> tokenValidation(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      if (token == null || token == "") {
        return false;
      }
      var tokenRes = await http.get(
        Uri.parse('$baseUrl/auth/tokenValidation'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        },
      );
      var response = jsonDecode(tokenRes.body);
      return response;
    } catch (err) {
      print("token validation failed $err");
      return false;
    }
  }

  static void getAllGotras(BuildContext context) async {
    try {
      var gotrasProvider = Provider.of<GotrasProvider>(context, listen: false);
      final response = await http.get(
        Uri.parse('$baseUrl/gotra'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print("statuscode ${response.statusCode}");
      if (response.statusCode == 201) {
        List<dynamic> data = json.decode(response.body);

        List<Gotra> gotras =
            data.map((gotra) => Gotra.fromJson(gotra)).toList();

        gotrasProvider.setGotras(gotras);
      } else {
        throw Exception('Failed to load gotras');
      }
    } catch (error) {
      print('Error fetching gotras: $error');
    }
  }

  static Future<bool> saveUser(
      {required BuildContext context,
      required String name,
      required String mobile,
      required String dob,
      required String email,
      required String gotra,
      required String father_name,
      required String gender,
      required File? proflieImage}) async {
    final scaffold = ScaffoldMessenger.of(context);
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    // String? token = prefs.getString('auth_token');
    // User user = userProvider.user;

    if (proflieImage != null) {
      await saveProfileImage(context: context, profileImage: proflieImage);
    }
    try {
      var newDate = dob == ""
          ? null
          : "${DateFormat('dd/MM/yyyy').parse(dob).toIso8601String()}Z";
      print("newDate  $newDate");
      Map<String, dynamic> payload = {
        'name': name,
        'father_name': father_name,
        'dob': newDate,
        'mobile': mobile,
        'email': email,
        'gotra': {"value": gotra, "label": gotra},
        'gender': gender
      };
      print("payload ----------------------------- $payload");
      var response = await http.put(
        Uri.parse('${baseUrl}/user/${userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        ///just adding gotra in response beacause it contain only gotra_id //
        var res = jsonDecode(response.body);
        print("dob on fatch : ${res["dob"]}");
        res['gotra'] = gotra;

        res = jsonEncode(res);
        print('user provider ${res}');
        userProvider.setUser(res);

        print('user provider ${userProvider.user.toJson()}');
        await fetchProfilePic(context, userId!);

        print("user Provider ${userProvider.user.toJson()}");
        scaffold.showSnackBar(const SnackBar(
            backgroundColor: Color.fromARGB(255, 0, 90, 46),
            content: Text(
              "save sucess !",
              style: TextStyle(color: Colors.white),
            )));
      }
      return true;
    } catch (err) {
      scaffold.showSnackBar(SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(
            "save failed ! Please Try Again ${err.toString()}",
            style: const TextStyle(color: Colors.white),
          )));
      print("geddd $err");
      return false;
    }
  }

  static Future<void> saveProfileImage({
    required BuildContext context,
    required File profileImage,
  }) async {
    // var userProvider = Provider.of<UserProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    final bytes = await profileImage.readAsBytes();
    final base64Image = base64Encode(bytes);

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/user/$userId/profile_pic'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"profile_pic": base64Image}),
      );

      if (response.statusCode == 200) {
        print("image response : ${jsonDecode(response.body)}");
        print("image path : ${profileImage.path}");
      } else {
        throw Exception("Failed to update profile picture");
      }
    } catch (error) {
      print("An error occurred: $error");
    }
  }

  static Future<bool> getUser(BuildContext context) async {
    final scaffold = ScaffoldMessenger.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? token = prefs.getString('auth_token');
    print("userId $userId");
    print("token $token");
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    if (token == null) {
      return false;
    }
    try {
      var response = await http.get(
        Uri.parse('${baseUrl}/user/${userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        },
      );

      print("getapiresponse ${response}");
      if (response.statusCode == 200) {
        print("getapiresponse ${response.body}");
        userProvider.setUser(response.body);
        await fetchProfilePic(context, userId!);
        print("user Provider ${userProvider.user.toJson()}");
        return true;
      } else {
        scaffold.showSnackBar(const SnackBar(
            backgroundColor: Color.fromARGB(255, 90, 0, 0),
            content: Text(
              "token authorization failed",
              style: TextStyle(color: Colors.white),
            )));
        return false;
      }
    } catch (err) {
      scaffold.showSnackBar(SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(
            "failed ! Please Try Again ${err.toString()}",
            style: const TextStyle(color: Colors.white),
          )));

      return false;
    }
  }

  static Future<void> fetchProfilePic(
      BuildContext context, String userId) async {
    Uint8List? blob;
    String? base64Image;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await http.get(
      Uri.parse('$baseUrl/user/$userId/profile_pic'),
      headers: <String, String>{"Response-Type": "blob"},
    ).then((res) => {
          if (res.statusCode == 200)
            {
              if (res.body.toString() != "false")
                {
                  blob = res.bodyBytes,
                  base64Image = base64Encode(blob!),
                  userProvider.setProfilePic(base64Image!)
                }
            }
        });
  }

  static Future<bool> addStudent({
    required BuildContext context,
    required String name,
    required String fatherName,
    required String dob,
    required String mobile,
    required String email,
    required String studyAt,
    required String studyPlace,
    required String village,
    required String gotra,
    required String medium,
    required String studyLevel,
    required String gender,
    required String? studyType,
    required String? currentClass,
    required String? collegeYear,
  }) async {
    var myStudentsProvider =
        Provider.of<MyStudentProvider>(context, listen: false);
    final scaffold = ScaffoldMessenger.of(context);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      String? token = prefs.getString('auth_token');
      String newDate =
          "${DateFormat('dd/MM/yyyy').parse(dob).toIso8601String()}Z";
      Map<String, dynamic> payload = {
        "name": name,
        "father_name": fatherName,
        "dob": newDate,
        "mobile": mobile,
        "email": email,
        "studyAt": studyAt,
        "study_place": studyPlace,
        "village": village,
        "gender": gender,
        "addedBy": userId!,
        "curr_class": currentClass,
        "college_year": collegeYear,
        "study_type": studyType,
        "gotra": {"value": gotra, "label": gotra},
        "medium": medium,
        "study_level": studyLevel
      };
      print("student data : ${jsonEncode(payload)}");
      final response = await http.post(
        Uri.parse('$baseUrl/student'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
        body: jsonEncode(payload),
      );
      if (response.statusCode == 201) {
        var res = jsonDecode(response.body);
        res['gotra'] = res['gotra_id']?["name"];
        res = jsonEncode(res);
        myStudentsProvider.addStudent(res);
        return true;
      } else {
        print("Failed to Add student ${(response.body)}");
        return false;
      }
    } catch (err) {
      print("error;;;;;;;;;;;--------------- ${err}");
      scaffold.showSnackBar(SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(
            "Failed ADD STUDENT ! Please Try Again ${err.toString()}",
            style: const TextStyle(color: Colors.white),
          )));
      return false;
    }
  }

  static Future<bool> getMyStudents(BuildContext context) async {
    final scaffold = ScaffoldMessenger.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? token = prefs.getString('auth_token');
    print("userId $userId");
    print("token $token");
    var myStudentProvider =
        Provider.of<MyStudentProvider>(context, listen: false);
    if (token == null) {
      return false;
    }
    try {
      var response = await http.get(
        Uri.parse('${baseUrl}/student/?addedBy=${userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        },
      );

      if (response.statusCode == 201) {
        List<Map<String, dynamic>> list = [];
        var res = jsonDecode(response.body);
        print('res :$res');
        for (var student in res) {
          student["gotra"] = student['gotra_id']?['name'];
          student = student;
          // print(
          //     "stundet==================??/////////........................>>>> $student");
          list.add(student);
          print("list ------------------------------------->>>> $list");
        }
        myStudentProvider.addAllStudents(list);
        print(myStudentProvider.students[0].toJson());

        return true;
      } else {
        scaffold.showSnackBar(const SnackBar(
            backgroundColor: Color.fromARGB(255, 90, 0, 0),
            content: Text(
              "token authorization failed for student",
              style: TextStyle(color: Colors.white),
            )));
        return false;
      }
    } catch (err) {
      scaffold.showSnackBar(SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(
            "Failed ! Please Try Again ${err.toString()}",
            style: const TextStyle(color: Colors.white),
          )));

      return false;
    }
  }

  static Future<bool> updateStudent({
    required BuildContext context,
    required MyStudent updatedStundent,
  }) async {
    var myStudentsProvider =
        Provider.of<MyStudentProvider>(context, listen: false);
    final scaffold = ScaffoldMessenger.of(context);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // String? userId = prefs.getString('userId');
      String? token = prefs.getString('auth_token');
      String newDate =
          "${DateFormat('dd/MM/yyyy').parse(updatedStundent.dob).toIso8601String()}Z";
      Map<String, dynamic> payload = {
        "name": updatedStundent.name,
        "father_name": updatedStundent.fatherName,
        "dob": newDate,
        "mobile": updatedStundent.mobile,
        "email": updatedStundent.email,
        "studyAt": updatedStundent.studyAt,
        "study_place": updatedStundent.studyPlace,
        "village": updatedStundent.village,
        "gender": updatedStundent.gender,
        "addedBy": updatedStundent.addedBy,
        "curr_class": updatedStundent.currentClass,
        "college_year": updatedStundent.collegeYear,
        "study_type": updatedStundent.studyType,
        "gotra": {
          "value": updatedStundent.gotra,
          "label": updatedStundent.gotra
        },
        "medium": updatedStundent.medium,
        "study_level": updatedStundent.studyLevel
      };
      print("student data : ${jsonEncode(payload)}");
      final response = await http.put(
        Uri.parse('$baseUrl/student/${updatedStundent.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
        body: jsonEncode(payload),
      );
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        res['gotra'] = updatedStundent.gotra;
        res = jsonEncode(res);
        print("updateStundetResponse ${res}");
        myStudentsProvider.updateStudent(res);
        print(
            "updateStundetProvider ${myStudentsProvider.students[0].toJson()}");
        return true;
      } else {
        print("Failed to Update student ${(response.body)}");
        return false;
      }
    } catch (err) {
      print("error;;;;;;;;;;;--------------- ${err}");
      scaffold.showSnackBar(SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(
            "Failed Update STUDENT ! Please Try Again ${err.toString()}",
            style: const TextStyle(color: Colors.white),
          )));
      return false;
    }
  }

  static Future<bool> deleteStudent({
    required BuildContext context,
    required MyStudent student,
  }) async {
    var myStudentsProvider =
        Provider.of<MyStudentProvider>(context, listen: false);
    final scaffold = ScaffoldMessenger.of(context);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // String? userId = prefs.getString('userId');
      String? token = prefs.getString('auth_token');
      String studentId = student.id;

      final response = await http.delete(
        Uri.parse('$baseUrl/student/${studentId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );
      if (response.statusCode == 200) {
        myStudentsProvider.removeStudent(student);
        return true;
      }
      return false;
    } catch (err) {
      scaffold.showSnackBar(SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(
            "Failed Delete STUDENT ! Please Try Again ${err.toString()}",
            style: const TextStyle(color: Colors.white),
          )));
      return false;
    }
  }

  static Future<bool> addBusiness(
      {required BuildContext context,
      required String name,
      required String mobile,
      required String email,
      required String location,
      required List<String> owners,
      required String category,
      required File? businessImage}) async {
    final scaffold = ScaffoldMessenger.of(context);
    var myBusinessProvider =
        Provider.of<MyBusinessProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    // String? token = prefs.getString('auth_token');
    if (businessImage != null) {
      await saveBusinessImage(context: context, businessImage: businessImage);
    }
    try {
      Map<String, dynamic> payload = {
        'name': name,
        'location': location,
        'category': category,
        'owner_names': owners,
        'owner_mobile': mobile,
        'owner_email': email,
        'added_by': userId
      };
      print("payload ----------------------------- $payload");
      var response = await http.post(
        Uri.parse('$baseUrl/business'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        print("business response : ${res}");

        scaffold.showSnackBar(const SnackBar(
            backgroundColor: Color.fromARGB(255, 0, 90, 46),
            content: Text(
              "save business sucess !",
              style: TextStyle(color: Colors.white),
            )));
      }
      return true;
    } catch (err) {
      scaffold.showSnackBar(SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(
            "save failed ! Please Try Again ${err.toString()}",
            style: const TextStyle(color: Colors.white),
          )));
      print("geddd $err");
      return false;
    }
  }

  static Future<void> saveBusinessImage({
    required BuildContext context,
    required File businessImage,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    final bytes = await businessImage.readAsBytes();
    final base64Image = base64Encode(bytes);

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/business/$userId/image'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"image": base64Image}),
      );

      if (response.statusCode == 200) {
        print("image response : ${jsonDecode(response.body)}");
        print("image path : ${businessImage.path}");
      } else {
        throw Exception("Failed to update Business picture");
      }
    } catch (error) {
      print("An error occurred: $error");
    }
  }
}
