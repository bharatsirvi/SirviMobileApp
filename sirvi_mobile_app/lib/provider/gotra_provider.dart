import 'package:flutter/material.dart';
import 'package:sirvi_mobile_app/models/gotraModel.dart';

class GotrasProvider with ChangeNotifier {
  List<String> _gotraOptions = [];

  List<String> get gotraOptions => _gotraOptions;

  void setGotras(List<Gotra> gotras) {
    _gotraOptions = gotras.map((gotra) => gotra.name).toList();
    notifyListeners();
    print(_gotraOptions);
  }
}
