import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flare_flutter/flare_actor.dart'; // Add this to your pubspec.yaml
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sirvi_mobile_app/Screen/mainScreen.dart';
import 'package:sirvi_mobile_app/Screen/signupScreen.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  final String verificatioID;

  PinCodeVerificationScreen(this.phoneNumber, this.verificatioID);

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  late TapGestureRecognizer onTapRecognizer;
  late TextEditingController _otpController;
  late StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    _otpController = TextEditingController();
    errorController = StreamController<ErrorAnimationType>();
  }

  @override
  void dispose() {
    errorController.close();
    _otpController.dispose();
    super.dispose();
  }

  void _verifyOtp() async {
    final otp = _otpController.text;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificatioID, smsCode: otp);

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green[900],
          content: Text(
            "OTP Verification Successful !",
            style: TextStyle(color: Colors.white),
          )));
      Navigator.pop(context, true);

      // Navigate to another screen or perform other actions
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(
            "Invalid OTP ! Please Enter Correct Code.",
            style: TextStyle(color: Colors.white),
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Center(
                child: Container(
                  color: Colors.transparent,
                  height: MediaQuery.of(context).size.height / 3,
                  child: Lottie.asset(
                    repeat: false,
                    "assets/images/otp.json",
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.center,
                  ),
                  //  FlareActor(
                  //   "assets/images/",
                  //   animation: "otp",
                  //   fit: BoxFit.fitHeight,
                  //   alignment: Alignment.center,
                  // ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Mobile Number Verification',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                    text: "Enter the code sent to ",
                    children: [
                      TextSpan(
                        text: widget.phoneNumber,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                  child: PinCodeTextField(
                    appContext: context,

                    pastedTextStyle: TextStyle(
                      color: Color(
                        0xFFFF0844,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,
                    obscureText: false,
                    obscuringCharacter: '*',
                    animationType: AnimationType.fade,

                    pinTheme: PinTheme(
                        inactiveColor: Color.fromARGB(255, 255, 220, 229),
                        shape: PinCodeFieldShape.box,
                        selectedColor: Color(
                          0xFFFF0844,
                        ),
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 60,
                        fieldWidth: 50,
                        activeFillColor: Colors.white),
                    cursorColor: Colors.black,
                    animationDuration: Duration(milliseconds: 300),
                    textStyle: TextStyle(fontSize: 20, height: 1.6),
                    backgroundColor: Colors.white,
                    // enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    boxShadows: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 10,
                      ),
                    ],
                    onCompleted: (v) {
                      print("Completed");
                    },
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      return true;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Didn't receive the code? ",
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                  children: [
                    TextSpan(
                      text: " RESEND",
                      recognizer: onTapRecognizer,
                      style: TextStyle(
                          color: Color(
                            0xFFFF0844,
                          ),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // conditions for validating
                      if (currentText.length != 6) {
                        errorController.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() {
                          hasError = true;
                        });
                      } else {
                        _verifyOtp();
                      }
                    }
                  },
                  child: Center(
                    child: Text(
                      "VERIFY".toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(
                      0xFFFF0844,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 5,
                    shadowColor: Color(
                      0xFFFF0844,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
