import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sirvi_mobile_app/Screen/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:sirvi_mobile_app/localization/locales.dart';
import 'package:sirvi_mobile_app/models/userModel.dart';
import 'package:sirvi_mobile_app/services/api_services.dart';
import 'package:sirvi_mobile_app/utills/otp_input_fields.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sirvi_mobile_app/utills/slideAnimation.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late FlutterLocalization localization;
  late String _prefered_lang;
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _otpController = TextEditingController();

  var _passwordVisibility = true;
  String _verificationId = '';

  bool _otpSentStatus = false;
  bool _otpVerifiedStatus = false;

  bool _loadingOtp = false;
  bool _loadingSignup = false;

  @override
  void initState() {
    super.initState();
    getPreferedLanguage();
  }

  void getPreferedLanguage() async {
    localization = FlutterLocalization.instance;
    _prefered_lang = localization.currentLocale!.languageCode;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleData.nameErrorMsg;
    }
    return null;
  }

  String? _validateMobile(String? value) {
    // Simple regex for validating mobile number
    String pattern = r'(^[0-9]{10}$)';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return LocaleData.mobileErrorMsg1.getString(context);
    } else if (!regExp.hasMatch(value)) {
      return LocaleData.mobileErrorMsg2.getString(context);
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleData.passwordErrorMsg1.getString(context);
    } else if (value.length < 6) {
      return LocaleData.passwordErrorMsg2.getString(context);
    }
    return null;
  }

  void _sendOtp() async {
    setState(() {
      _loadingOtp = true;
    });
    final phone = "+91" + _mobileController.text.trim();
    await firebase_auth.FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (firebase_auth.PhoneAuthCredential credential) {
          setState(() {
            _otpVerifiedStatus = true;
          });
        },
        verificationFailed: (firebase_auth.FirebaseException e) {
          setState(() {
            _loadingOtp = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Verification failed. Error: ${e.message}"),
          ));
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _otpSentStatus = true;
            _loadingOtp = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${LocaleData.otpSendMsg.getString(context)} $phone"),
          ));
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return PinCodeVerificationScreen(
              _mobileController.text,
              _verificationId,
            );
          })).then((result) {
            if (result == true) {
              // Handle successful verification
              setState(() {
                _otpVerifiedStatus = true; // Example: Set a state variable
              });
            }
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
            _loadingOtp = false;
          });
        });
  }

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loadingSignup = true;
      });
      print("Registering user");
      await ApiService.signupUser(
          context: context,
          name: _nameController.text.trim(),
          mobile: _mobileController.text.trim(),
          password: _passwordController.text.trim());

      setState(() {
        _loadingSignup = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFFFEEDA),
        child: Stack(children: [
          Align(
            alignment: Alignment.topCenter,
            child: FractionallySizedBox(
              widthFactor: 1.0, // Full width of the parent
              heightFactor: 0.5, // 50% of the parent height
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(
                    0xFFFF0844,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(200, 15),
                    bottomRight: Radius.elliptical(200, 15),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: FractionallySizedBox(
              widthFactor: 1.0, // Full width of the parent
              heightFactor: 0.25, // 50% of the parent height
              child: Center(
                child: Text(
                  LocaleData.appName.getString(context),
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  width: 320,
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, bottom: 20, top: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LocaleData.signUp.getString(context),
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Color(0xFFFF0844)),
                            ),
                            hintText: LocaleData.name.getString(context),
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: _validateName,
                        ),
                        const SizedBox(height: 20),
                        Stack(
                            alignment: AlignmentDirectional.centerEnd,
                            children: [
                              TextFormField(
                                controller: _mobileController,
                                keyboardType: TextInputType.phone,
                                enabled: !_otpVerifiedStatus,
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    disabledBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide:
                                          BorderSide(color: Color(0xFFFF0844)),
                                    ),
                                    hintText:
                                        LocaleData.mobileNo.getString(context),
                                    prefixIcon: const Icon(Icons.phone),
                                    suffix: _otpVerifiedStatus
                                        ? Text(
                                            LocaleData.verified
                                                .getString(context),
                                            style: TextStyle(
                                                color: Colors.green[900]),
                                          )
                                        : null),
                                validator: _validateMobile,
                              ),
                              if (!_otpVerifiedStatus)
                                Positioned(
                                  right: 0,
                                  child: TextButton(
                                    onPressed: () {
                                      if (_validateMobile(
                                              _mobileController.text) ==
                                          null) {
                                        _sendOtp();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                backgroundColor:
                                                    Colors.red[900],
                                                content: Text(
                                                  _validateMobile(
                                                      _mobileController.text)!,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )));
                                      }
                                    },
                                    child: Text(
                                      _loadingOtp
                                          ? LocaleData.sending
                                              .getString(context)
                                          : LocaleData.sendOtp
                                              .getString(context),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                            ]),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _passwordVisibility,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              disabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(color: Color(0xFFFF0844)),
                              ),
                              hintText: LocaleData.password.getString(context),
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisibility =
                                          !_passwordVisibility;
                                    });
                                  },
                                  icon: Icon(_passwordVisibility
                                      ? Icons.visibility_off
                                      : Icons.visibility))),
                          validator: _validatePassword,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                              label: Text(
                                LocaleData.signUp.getString(context),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              iconAlignment: IconAlignment.end,
                              icon: const Icon(
                                Icons.login,
                                color: Colors.white,
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                                backgroundColor: _otpVerifiedStatus
                                    ? const Color(0xFFFF0844)
                                    : const Color.fromARGB(255, 191, 184, 184),
                                shadowColor: const Color(0xFFFFB199),
                              ),
                              onPressed: _otpVerifiedStatus
                                  ? _registerUser
                                  : () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(LocaleData
                                            .firstClickOnSend
                                            .getString(context)),
                                      ));
                                    }),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(LocaleData.accountExitsMsg.getString(context)),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 0,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        LoginPage(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Text(LocaleData.login.getString(context)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                changeLanguage();
                              },
                              splashColor: Colors.transparent,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.language,
                                      color: Color.fromARGB(255, 97, 2, 16)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    LocaleData.changeLang.getString(context),
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 97, 2, 16)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _prefered_lang == 'en'
                                      ? "Eng(UK)"
                                      : LocaleData.hindilang.getString(context),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  height: 20,
                                  width: 20,
                                  child: Center(
                                    child: Image.asset(
                                      _prefered_lang == 'en'
                                          ? "assets/images/Britain.png"
                                          : "assets/images/india.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_loadingOtp || _loadingSignup)
            Container(
              color: Colors.white30,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ]),
      ),
    );
  }

  void changeLanguage() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();

    if (_prefered_lang == 'en') {
      localization.translate('hi');
      // pref.setString("prefered_language", "hi");
      setState(() {
        _prefered_lang = 'hi';
      });
    } else {
      localization.translate('en');
      // pref.setString("prefered_language", "en");
      setState(() {
        _prefered_lang = 'en';
      });
    }
  }
}
