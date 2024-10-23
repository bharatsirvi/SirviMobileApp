import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MyStudent {
  String id;
  String name;
  String fatherName;
  String dob;
  String mobile;
  String email;
  String studyAt;
  String studyPlace;
  String village;
  String gotra;
  String medium;
  String studyLevel;
  String addedBy;
  String gender;
  String? studyType;
  String? currentClass;
  String? collegeYear;

  MyStudent({
    required this.id,
    required this.name,
    required this.fatherName,
    required this.dob,
    required this.mobile,
    required this.email,
    required this.studyAt,
    required this.studyPlace,
    required this.village,
    required this.gotra,
    required this.medium,
    required this.studyLevel,
    required this.gender,
    required this.addedBy,
    this.studyType,
    this.currentClass,
    this.collegeYear,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'fatherName': fatherName,
      'dob': dob,
      'mobile': mobile,
      'email': email,
      'studyAt': studyAt,
      'addedBy': addedBy,
      'studyPlace': studyPlace,
      'village': village,
      'gotra': gotra,
      'medium': medium,
      'studyLevel': studyLevel,
      'gender': gender,
      'studyType': studyType,
      'currentClass': currentClass,
      'collegeYear': collegeYear,
    };
  }

  MyStudent copyWith({
    String? name,
    String? fatherName,
    String? gotra,
    String? gender,
    String? medium,
    String? dob,
    String? studyAt,
    String? studyPlace,
    String? studyLevel,
    String? studyType,
    String? village,
    String? email,
    String? mobile,
    String? currentClass,
    String? collegeYear,
  }) {
    return MyStudent(
      id: this.id,
      addedBy: this.addedBy,
      name: name ?? this.name,
      fatherName: fatherName ?? this.fatherName,
      gotra: gotra ?? this.gotra,
      gender: gender ?? this.gender,
      medium: medium ?? this.medium,
      dob: dob ?? this.dob,
      studyAt: studyAt ?? this.studyAt,
      studyPlace: studyPlace ?? this.studyPlace,
      studyLevel: studyLevel ?? this.studyLevel,
      studyType: studyType ?? this.studyType,
      village: village ?? this.village,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      currentClass: currentClass ?? "",
      collegeYear: collegeYear ?? "",
    );
  }

  factory MyStudent.fromMap(Map<String, dynamic> map) {
    return MyStudent(
      id: map['_id'] as String,
      name: map['name'] as String,
      fatherName: map['father_name'] as String,
      dob: map['dob'] as String,
      mobile: map['mobile'] as String,
      email: map['email'] as String,
      studyAt: map['studyAt'] as String,
      studyPlace: map['study_place'] as String,
      addedBy: map['addedBy'] as String,
      village: map['village'] as String,
      gotra: map['gotra'] as String,
      medium: map['medium'] as String,
      studyLevel: map['study_level'] as String,
      gender: map['gender'] as String,
      studyType: map['study_type'] != null ? map['study_type'] as String : "",
      currentClass: map['curr_class'] != null
          ? map['curr_class'].toString() as String
          : "",
      collegeYear: map['college_year'] != null
          ? map['college_year'].toString() as String
          : "",
    );
  }

  String toJson() => json.encode(toMap());

  factory MyStudent.fromJson(String source) =>
      MyStudent.fromMap(json.decode(source) as Map<String, dynamic>);
}
