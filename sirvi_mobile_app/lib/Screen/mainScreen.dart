import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:sirvi_mobile_app/Screen/eventScreen.dart';
import 'package:sirvi_mobile_app/Screen/homeScreen.dart';
import 'package:sirvi_mobile_app/Screen/imageScreen.dart';
import 'package:sirvi_mobile_app/Screen/profileScreen.dart';
import 'package:sirvi_mobile_app/localization/locales.dart';
import 'package:sirvi_mobile_app/services/api_services.dart';
import 'package:vibration/vibration.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late FlutterLocalization _localization;
  late String _currLocale;

  final List<Widget> _pages = [
    HomePage(),
    EventPage(),
    ImagePage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _localization = FlutterLocalization.instance;
    _currLocale = _localization.currentLocale!.languageCode;
    _initializeApp();
  }

  Future<void> _vibrate() async {
    Vibration.vibrate(duration: 40, amplitude: 40);
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await ApiService.getMyStudents(context);
  }

  void _setLocale(String? value) {
    if (value == null) {
      return;
    } else if (value == 'hi') {
      _localization.translate('hi');
    } else if (value == 'en') {
      _localization.translate('en');
    } else {
      return;
    }
    setState(() {
      _currLocale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex != 3
          ? AppBar(
              title: Text(LocaleData.appName.getString(context)),
              foregroundColor: Colors.white,
              centerTitle: true,
              actions: [],
              backgroundColor: Color.fromARGB(255, 255, 56, 106),
            )
          : AppBar(
              title: Text(LocaleData.profile.getString(context)),
              foregroundColor: Colors.white,
              centerTitle: true,
              backgroundColor: Color.fromARGB(255, 255, 56, 106),
            ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        elevation: 30,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        selectedItemColor: Color(0xFFFF0844),
        onTap: (index) {
          _vibrate();
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: Color(0xFFFF0844),
            icon: Icon(Icons.home_outlined),
            label: LocaleData.home.getString(context),
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xFFFF0844),
            icon: Icon(Icons.event_outlined),
            label: LocaleData.event.getString(context),
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xFFFF0844),
            icon: Icon(Icons.image_outlined),
            label: LocaleData.image.getString(context),
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xFFFF0844),
            icon: Icon(Icons.person_outlined),
            label: LocaleData.profile.getString(context),
          ),
        ],
      ),
    );
  }
}
