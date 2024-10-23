import 'dart:convert';

class MyBusiness {
  String id;
  String busninessName;
  String location;
  String catagory;
  List<String> owners;
  String mobile;
  String email;
  String addedBy;
  String? businessPic;

  MyBusiness({
    required this.id,
    required this.busninessName,
    required this.location,
    required this.catagory,
    required this.owners,
    required this.mobile,
    required this.email,
    required this.addedBy,
    this.businessPic,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'busninessName': busninessName,
      'location': location,
      'catagory': catagory,
      'owners': owners,
      'mobile': mobile,
      'email': email,
      'addedBy': addedBy,
      'businessPic': businessPic,
    };
  }

  factory MyBusiness.fromMap(Map<String, dynamic> map) => MyBusiness(
        id: map['_id'] as String,
        busninessName: map['name'] as String,
        location: map['location'] as String,
        catagory: map['catagory'] as String,
        owners: List<String>.from(map['owner_names'] as List<dynamic>),
        mobile: map['owner_mobile'] as String,
        email: map['owner_email'] as String,
        addedBy: map['added_by'] as String,
        businessPic: "",
      );

  String toJson() => json.encode(toMap());

  factory MyBusiness.fromJson(String source) =>
      MyBusiness.fromMap(json.decode(source) as Map<String, dynamic>);
}
