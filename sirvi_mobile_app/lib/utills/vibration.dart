import 'package:vibration/vibration.dart';

class Vibrate {
  static void vibrate({required int duration, required int amplitude}) {
    try {
      Vibration.vibrate(duration: duration, amplitude: amplitude);
    } catch (e) {
      print(e);
    }
  }
}
