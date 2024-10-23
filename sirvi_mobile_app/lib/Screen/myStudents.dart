import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:sirvi_mobile_app/Screen/AddMyStudent.dart';
import 'package:sirvi_mobile_app/Screen/viewMyStudents.dart';
import 'package:sirvi_mobile_app/localization/locales.dart';

class Mystudents extends StatefulWidget {
  @override
  MystudentsState createState() => MystudentsState();
}

class MystudentsState extends State<Mystudents> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ViewMyStudent(),
    AddMyStudent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 56, 106),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            )
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _currentIndex,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          // showSelectedLabels: true,
          // showUnselectedLabels: false,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined, size: 30),
              label: LocaleData.viewAll.getString(context),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add_alt_1_outlined, size: 30),
              label: LocaleData.addStudent.getString(context),
            ),
          ],
        ),
      ),
    );
  }
}
