import 'package:flutter/material.dart';
import 'package:sirvi_mobile_app/models/myStudent.dart';

class MyStudentProvider with ChangeNotifier {
  List<MyStudent> _students = [];

  List<MyStudent> get students => _students;

  void addStudent(String studentData) {
    MyStudent student = MyStudent.fromJson(studentData);
    _students.add(student);
    notifyListeners();
  }

  void addAllStudents(List<Map<String, dynamic>> list) {
    List<MyStudent> studentsList = [];
    for (var i = 0; i < list.length; i++) {
      MyStudent student = MyStudent.fromMap(list[i]);
      studentsList.add(student);
    }
    _students = studentsList;
  }

  void updateStudent(String studentData) {
    MyStudent student = MyStudent.fromJson(studentData);
    int index = _students.indexWhere((element) => element.id == student.id);
    _students[index] = student;
    notifyListeners();
  }

  void removeStudent(MyStudent student) {
    _students.remove(student);
    notifyListeners();
  }
}
