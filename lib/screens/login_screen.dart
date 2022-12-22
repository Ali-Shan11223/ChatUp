import 'package:chat_up/consts/consts.dart';
import 'package:chat_up/providers/auth_provider.dart';
import 'package:chat_up/screens/home_screen.dart';
import 'package:chat_up/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    switch (authProvider.status) {
      case Status.authenticateError:
        Fluttertoast.showToast(
            msg: 'Signin Failed',
            backgroundColor: colorBlue,
            textColor: colorWhite,
            gravity: ToastGravity.BOTTOM);
        break;
      case Status.authenticateCanceled:
        Fluttertoast.showToast(
            msg: 'Signin Canceled',
            backgroundColor: colorBlue,
            textColor: colorWhite,
            gravity: ToastGravity.BOTTOM);
        break;
      case Status.authenticated:
        Fluttertoast.showToast(
            msg: 'Signin Successfully',
            backgroundColor: colorBlue,
            textColor: colorWhite,
            gravity: ToastGravity.BOTTOM);
        break;
      default:
        break;
    }
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(color: colorWhite),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              verticalSpace(20),
              SizedBox(
                width: double.infinity,
                height: 300,
                child: Image.asset(
                  'assets/icons/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const Text(
                'Welcome to ChatUp',
                style: TextStyle(
                    letterSpacing: 1,
                    color: colorBlue,
                    fontSize: 24,
                    fontWeight: FontWeight.w600),
              ),
              verticalSpace(20),
              const Text(
                'Stay in touch with your friends.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              verticalSpace(40),
              CustomButton(
                  title: 'Sign in with Google',
                  onTap: () async {
                    await authProvider
                        .handleSignIn()
                        .then((value) {})
                        .catchError((error, stackTrace) {
                      Fluttertoast.showToast(msg: error.toString());
                      authProvider.handleException();
                    });
                    Get.to(() => const HomeScreen(),
                        transition: Transition.downToUp);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
