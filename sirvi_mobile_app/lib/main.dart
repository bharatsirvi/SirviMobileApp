import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sirvi_mobile_app/Screen/selectLanguage.dart';
import 'package:sirvi_mobile_app/Screen/splashScreen.dart';
import 'package:sirvi_mobile_app/localization/locales.dart';
import 'package:sirvi_mobile_app/provider/gotra_provider.dart';
import 'package:sirvi_mobile_app/provider/my_students_provider.dart';
import 'package:sirvi_mobile_app/provider/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      // apiKey: 'AIzaSyCz7O9ko_GS6Hk-d4hNSYI2RLYF8U8d-Lo',
      // appId: '1:825414315663:android:71197bd9e584263161cafa',
      // messagingSenderId: '1234567890',
      // projectId: 'sirvi-mobile-app',
      // storageBucket: 'sirvi-mobile-app.appspot.com',
      // databaseURL: 'https://sirvi-mobile-app.firebaseio.com',
      // measurementId: 'G-1234567890',
      apiKey: "AIzaSyDaajsJv-lhXVLOW0YdJ_m094p0RPIgY-Q",
      appId: "1:825414315663:android:71197bd9e584263161cafa",
      messagingSenderId: "825414315663",
      projectId: 'sirviapp-8be80',
      storageBucket: "sirviapp-8be80.appspot.com",
      authDomain: "sirviapp-8be80.firebaseapp.com",
      databaseURL: 'https://sirviapp-8be80.firebaseio.com',
    ),
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => GotrasProvider()),
    ChangeNotifierProvider(create: (_) => MyStudentProvider())
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final FlutterLocalization localization = FlutterLocalization.instance;
  @override
  void initState() {
    configureLocalization();
    // getPreferedLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        supportedLocales: localization.supportedLocales,
        localizationsDelegates: localization.localizationsDelegates,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: localization.currentLocale!.languageCode == 'hi'
              ? 'Eczar-Regular'
              : 'Inter',
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFFFF0844),
          ),
          useMaterial3: true,
        ),
        home: SplashScreen());
  }

  void configureLocalization() {
    localization.init(mapLocales: LOCALES, initLanguageCode: 'hi');
    localization.onTranslatedLanguage = onTranslatedLanguage;
  }

  void onTranslatedLanguage(Locale? p1) {
    setState(() {});
  }

  // void getPreferedLanguage() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   String? lang = pref.getString("prefered_language");
  //   print("prefered lan >>>  $lang");

  //   if (lang != null) {
  //     localization.translate(lang);
  //   }
  // }
  // void clearToken() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   setState(() {
  //     pref.setString("auth_token", "");
  //   });
  // }
}
