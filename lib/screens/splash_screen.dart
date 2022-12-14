import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_up/providers/auth_provider.dart';
import 'package:chat_up/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'intro_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // isLogIn() {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User? user = auth.currentUser;
  //   if (user != null) {
  //     Timer(const Duration(seconds: 5), () {
  //       Get.to(() => const HomeScreen());
  //     });
  //   } else {
  //     Timer(const Duration(seconds: 5), () {
  //       Get.to(() => const IntroScreen());
  //     });
  //   }
  // }

  void checkSignedIn() async {
    AuthProvider authProvider = context.read<AuthProvider>();
    bool isLoggedIn = await authProvider.isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const IntroScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    // isLogIn();
    checkSignedIn();
  }

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/logo.png',
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText('ChatUp',
                      textStyle: const TextStyle(
                          fontSize: 40, fontWeight: FontWeight.bold),
                      colors: colorizeColors,
                      speed: const Duration(milliseconds: 1000))
                ],
                repeatForever: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
