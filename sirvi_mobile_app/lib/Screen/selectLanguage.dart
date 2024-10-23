import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sirvi_mobile_app/Screen/signupScreen.dart';
import 'package:sirvi_mobile_app/localization/locales.dart';
import 'package:sirvi_mobile_app/main.dart';

class LanguageSelectionPage extends StatefulWidget {
  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  late FlutterLocalization localization;

  @override
  void initState() {
    super.initState();
    localization = FlutterLocalization.instance;
  }

  String _selectedLanguage = '';

  void _selectLanguage(String language) {
    localization.translate(language);
    setState(() {
      _selectedLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 56, 106),
              Color.fromARGB(255, 251, 17, 75),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  LocaleData.welcome.getString(context),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Select Your language",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '(अपनी भाषा का चयन करें)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildLanguageOption(
                      'hi',
                      'https://upload.wikimedia.org/wikipedia/en/4/41/Flag_of_India.svg',
                      'हिन्दी',
                      'assets/images/india.png',
                    ),
                    SizedBox(height: 20),
                    _buildLanguageOption(
                      'en',
                      'https://upload.wikimedia.org/wikipedia/en/a/a4/Flag_of_the_United_States.svg',
                      'English',
                      'assets/images/Britain.png',
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                TextButton.icon(
                  onPressed: _selectedLanguage == ""
                      ? null
                      : () {
                          setFirstTime();
                          // setPreferLanguage();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupPage(),
                            ),
                          );
                        },
                  label: Text(LocaleData.Continue.getString(context)),
                  iconAlignment: IconAlignment.end,
                  icon: Icon(Icons.arrow_forward),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue[900],
                    backgroundColor: const Color.fromARGB(255, 233, 238, 246),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
      String language, String flagUrl, String languageText, String url) {
    bool isSelected = language == _selectedLanguage;
    return InkWell(
      onTap: () => _selectLanguage(language),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Color.fromARGB(255, 255, 202, 217) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
          border: isSelected
              ? Border.all(
                  color: Colors.white,
                  width: 3,
                )
              : null,
        ),
        child: Column(
          children: <Widget>[
            Image.asset(
              url, // Your logo asset path
              width: 200,
              fit: BoxFit.cover,
              height: 120,
            ),
            SizedBox(height: 10),
            Text(
              languageText,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('first_time', false);
  }

  void setPreferLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('prefered_language', _selectedLanguage);
  }
}
