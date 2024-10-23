import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sirvi_mobile_app/Screen/mainScreen.dart';
import 'package:sirvi_mobile_app/Screen/selectLanguage.dart';
import 'package:sirvi_mobile_app/Screen/signupScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sirvi_mobile_app/localization/locales.dart';
import 'package:sirvi_mobile_app/provider/user_provider.dart';
import 'package:sirvi_mobile_app/services/api_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCz7O9ko_GS6Hk-d4hNSYI2RLYF8U8d-Lo',
      databaseURL: 'https://sirvi-mobile-app.firebaseio.com',
      projectId: 'sirvi-mobile-app',
      storageBucket: 'sirvi-mobile-app.appspot.com',
      messagingSenderId: '1234567890',
      appId: '1:825414315663:android:71197bd9e584263161cafa',
      measurementId: 'G-1234567890',
    ),
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF0844),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool isValidetoken = false;
  bool isLoading = true;
  bool isFirstTime = true;

  List<String> gotraOptions = [];
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    _initializeApp();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2)); // Minimum display time
    await isTokenValide();
    await getUser();
    await getGotraOptions();
    await isfirstTime();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> isfirstTime() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool('first_time') != null) {
      setState(() {
        isFirstTime = false;
      });
    }
  }

  Future<void> getGotraOptions() async {
    ApiService.getAllGotras(context);
  }

  Future<void> getUser() async {
    var sucess = await ApiService.getUser(context);
  }

  Future<void> isTokenValide() async {
    var res = await ApiService.tokenValidation(context);
    setState(() {
      isValidetoken = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Color.fromARGB(255, 255, 247, 237),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                FadeTransition(
                  opacity: _animation,
                  child: Image.asset(
                    'assets/images/sirviLogo.png', // Your logo asset path
                    width: 120,
                    height: 120,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Sirvi App",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF0844),
                  ),
                ),
                if (isLoading)
                  Lottie.asset(
                    height: 130,
                    width: 200,
                    "assets/images/loading.json",
                  ),
              ],
            ),
          ],
        ),
      );
    } else {
      return isValidetoken
          ? MainScreen()
          : isFirstTime
              ? LanguageSelectionPage()
              : const SignupPage();
    }
  }
}
