import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sirvi_mobile_app/Screen/loginScreen.dart';
import 'package:sirvi_mobile_app/Screen/myAccountScreen.dart';
import 'package:sirvi_mobile_app/Screen/myBusiness.dart';
import 'package:sirvi_mobile_app/Screen/myStudents.dart';
import 'package:sirvi_mobile_app/localization/locales.dart';
import 'package:sirvi_mobile_app/models/userModel.dart';
import 'package:sirvi_mobile_app/provider/user_provider.dart';
import 'package:sirvi_mobile_app/utills/fadeanimation.dart';
import 'package:sirvi_mobile_app/utills/logoutComfirmationDialog.dart';
import 'package:sirvi_mobile_app/utills/vibration.dart';
import 'package:vibration/vibration.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  String? _imageUrl = "";
  Image? _mempryImage;
  @override
  void initState() {
    super.initState();

    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData();
  }

  void _loadUserData() {
    print("loaded user data");
    setState(() {
      user = Provider.of<UserProvider>(context, listen: false).user;
      _imageUrl = user!.profilePic != "" ? user!.profilePic! : "";
      Image mempryImage = Image.memory(base64Decode(_imageUrl!));
      setState(() {
        _mempryImage = mempryImage;
      });
    });
  }

  Future<bool?> showLogoutComfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return LogoutDialog();
      },
    );
  }

  void handleLogout() async {
    bool isLogout = await showLogoutComfirmation(context) ?? false;
    if (isLogout) {
      final navigator = Navigator.of(context);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("auth_token", "");
      pref.setString("userId", "");
      navigator.pushReplacement(
        createFadeRoute(LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                      backgroundColor: Colors.transparent,
                      insetPadding: EdgeInsets.all(10),
                      child: Hero(
                        tag: 'avatar',
                        child: Container(
                          height: 400,
                          width: 250,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: user!.profilePic != ""
                                  ? _mempryImage!.image
                                  : Icon(
                                      Icons.account_circle,
                                      size: 100,
                                      color: Color(0xFFFF0844),
                                    ) as ImageProvider<Object>,
                            ),
                          ),
                        ),
                      ));
                },
              );
            },
            splashColor: Color.fromARGB(255, 255, 233, 239),
            child: ListTile(
              leading: Hero(
                tag: 'avatar',
                child: user!.profilePic != ""
                    ? CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            Image.memory(base64Decode(user!.profilePic!)).image)
                    : Icon(
                        Icons.account_circle,
                        size: 50,
                        color: Color(0xFFFF0844), // Customize color as needed
                      ),
              ),
              title: Text(user!.name.toUpperCase()),
              subtitle: Text(user!.mobile),
              trailing: TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  overlayColor: Colors.transparent,
                ),
                label: Text(LocaleData.edit.getString(context),
                    style: TextStyle(color: Colors.black)),
                icon: const Icon(
                  Icons.edit,
                  size: 17,
                  color: Color(0xFFFF0844),
                ),
                onPressed: () async {
                  var res = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyAccountPage()),
                  );
                  print("res is $res");

                  _loadUserData();
                },
              ),
            ),
          ),
          const SizedBox(height: 5),
          Divider(),
          const SizedBox(height: 5),
          InkWell(
            onTap: () async {
              Vibrate.vibrate(duration: 40, amplitude: 40);
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      MyAccountPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var begin =
                        Offset(1.0, 0.0); // Start position of the new page
                    var end = Offset.zero; // End position of the new page
                    var curve = Curves.ease; // Animation curve

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    // Use SlideTransition to apply the animation
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );

              // var res = await Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => MyAccountPage()),
              // );
              // print("res is $res");

              _loadUserData();
            },
            splashColor: Color.fromARGB(255, 255, 233, 239),
            child: Dismissible(
              key: Key("myAccount"),
              direction: DismissDirection.startToEnd,
              movementDuration: Duration(milliseconds: 500),
              background: Container(
                color: const Color.fromARGB(255, 255, 223, 231),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Icon(Icons.swipe_right_rounded,
                          size: 40,
                          color: const Color.fromARGB(255, 218, 177, 177)),
                    ),
                  ],
                ),
              ),
              confirmDismiss: (direction) async {
                Vibrate.vibrate(duration: 60, amplitude: 60);
                var res = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyAccountPage()),
                );
                print("res is $res");

                _loadUserData();
                return false;
              },
              child: ListTile(
                leading: Icon(
                  Icons.account_circle,
                  color: Color(0xFFFF0844),
                ),
                title: Text(LocaleData.myAccount.getString(context)),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: () async {
              Vibrate.vibrate(duration: 40, amplitude: 40);
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Mystudents(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var begin =
                        Offset(1.0, 0.0); // Start position of the new page
                    var end = Offset.zero; // End position of the new page
                    var curve = Curves.ease; // Animation curve

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    // Use SlideTransition to apply the animation
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
            splashColor: Color.fromARGB(255, 255, 233, 239),
            child: Dismissible(
              key: Key("myStudents"),
              direction: DismissDirection.startToEnd,
              movementDuration: Duration(milliseconds: 500),
              background: Container(
                color: const Color.fromARGB(255, 255, 223, 231),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Icon(Icons.swipe_right_rounded,
                          size: 40,
                          color: const Color.fromARGB(255, 218, 177, 177)),
                    ),
                  ],
                ),
              ),
              confirmDismiss: (direction) async {
                Vibrate.vibrate(duration: 60, amplitude: 60);
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Mystudents()),
                );
                return false;
              },
              child: ListTile(
                leading: const Icon(Icons.school, color: Color(0xFFFF0844)),
                title: Text(LocaleData.student.getString(context)),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: () {
              Vibrate.vibrate(duration: 40, amplitude: 40);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyBusiness()));
            },
            splashColor: const Color.fromARGB(255, 255, 223, 231),
            child: ListTile(
              leading: const Icon(Icons.business, color: Color(0xFFFF0844)),
              title: Text(LocaleData.business.getString(context)),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: () {
              Vibrate.vibrate(duration: 40, amplitude: 40);
            },
            splashColor: const Color.fromARGB(255, 255, 223, 231),
            child: ListTile(
              leading: const Icon(
                Icons.help,
                color: Color(0xFFFF0844),
              ),
              title: Text(LocaleData.helpSupport.getString(context)),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: handleLogout,
            splashColor: const Color.fromARGB(255, 255, 223, 231),
            child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Color(0xFFFF0844),
                ),
                title: Text(
                  LocaleData.logout.getString(context),
                )),
          ),
        ],
      ),
    );
  }
}
