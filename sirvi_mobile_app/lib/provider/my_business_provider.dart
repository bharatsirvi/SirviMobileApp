import 'package:flutter/material.dart';
import 'package:sirvi_mobile_app/models/myBusinessModel.dart';

class MyBusinessProvider with ChangeNotifier {
  List<MyBusiness> _businesses = [];

  List<MyBusiness> get businesses => _businesses;

  void addBusiness(String businessData) {
    MyBusiness business = MyBusiness.fromJson(businessData);
    _businesses.add(business);
    notifyListeners();
  }

  void addAllBusinesses(List<Map<String, dynamic>> list) {
    List<MyBusiness> businessesList = [];
    for (var i = 0; i < list.length; i++) {
      MyBusiness business = MyBusiness.fromMap(list[i]);
      businessesList.add(business);
    }
    _businesses = businessesList;
  }

  void updateBusiness(String businessData) {
    MyBusiness business = MyBusiness.fromJson(businessData);
    int index = _businesses.indexWhere((element) => element.id == business.id);
    _businesses[index] = business;
    notifyListeners();
  }

  void removeBusiness(MyBusiness business) {
    _businesses.remove(business);
    notifyListeners();
  }
}
