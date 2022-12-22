import 'package:chat_up/providers/auth_provider.dart';
import 'package:chat_up/providers/home_provider.dart';
import 'package:chat_up/providers/profile_provider.dart';
import 'package:chat_up/screens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    prefs: prefs,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  MyApp({Key? key, required this.prefs}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xff6279d9),
    ));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthProvider(
                firebaseAuth: FirebaseAuth.instance,
                googleSignIn: GoogleSignIn(),
                prefs: prefs,
                firebaseFirestore: firebaseFirestore)),
        Provider<HomeProvider>(
            create: (_) => HomeProvider(
                  firebaseFirestore: firebaseFirestore,
                )),
        Provider<ProfileProvider>(
            create: (_) => ProfileProvider(
                prefs: prefs,
                firebaseStorage: firebaseStorage,
                firebaseFirestore: firebaseFirestore))
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ChatUp',
        theme: ThemeData(
            textTheme: GoogleFonts.robotoTextTheme(),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: const Color(0xff6279d9),
            )),
        home: const SplashScreen(),
      ),
    );
  }
}
