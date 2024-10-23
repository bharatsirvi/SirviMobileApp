import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:sirvi_mobile_app/Screen/signupScreen.dart';
import 'package:sirvi_mobile_app/localization/locales.dart';
import 'package:sirvi_mobile_app/main.dart';
import 'package:sirvi_mobile_app/services/api_services.dart';
import 'package:sirvi_mobile_app/utills/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loadinglogin = false;

  var _passwordVisibility = true;

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

  void _loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loadinglogin = true;
      });
      await ApiService.loginUser(
          context: context,
          mobile: _mobileController.text.trim(),
          password: _passwordController.text.trim());

      // await ApiService.getUser(context);

      setState(() {
        _loadinglogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _mobileController.text = "8003628683";
    _passwordController.text = "123456";
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
                      left: 30, right: 30, top: 30, bottom: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LocaleData.loginmsg.getString(context),
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
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
                              borderSide: BorderSide(
                                color: Color(
                                  0xFFFF0844,
                                ),
                              ),
                            ),
                            hintText: LocaleData.mobileNo.getString(context),
                            prefixIcon: const Icon(Icons.phone),
                          ),
                          validator: _validateMobile,
                        ),
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
                                borderSide: BorderSide(
                                  color: Color(
                                    0xFFFF0844,
                                  ),
                                ),
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
                                LocaleData.login.getString(context),
                                style: TextStyle(
                                    color: Colors.white,
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
                                backgroundColor: Color(
                                  0xFFFF0844,
                                ),
                                shadowColor:
                                    const Color.fromARGB(255, 191, 184, 184),
                              ),
                              onPressed: _loginUser),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(LocaleData.accountNotExitsMsg
                                .getString(context)),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.only(left: 5, right: 0),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        SignupPage(),
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
                              child:
                                  Text(LocaleData.createOne.getString(context)),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            alignment: AlignmentDirectional.centerStart,
                            child: TextButton(
                                onPressed: () {},
                                child: Text(
                                    LocaleData.forgotPassword
                                        .getString(context),
                                    style: TextStyle(
                                        color: Color(
                                          0xFFFF0844,
                                        ),
                                        fontWeight: FontWeight.w400)))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_loadinglogin)
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
}
