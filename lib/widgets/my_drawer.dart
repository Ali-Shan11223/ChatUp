import 'package:chat_up/providers/auth_provider.dart';
import 'package:chat_up/screens/accountdetails_screen.dart';
import 'package:chat_up/screens/contact_us_screen.dart';
import 'package:chat_up/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../consts/consts.dart';
import '../screens/profile_screen.dart';
import '../screens/login_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return Drawer(
      child: Column(
        children: [
          Image.asset(
            'assets/icons/logo.png',
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          ),
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                  onTap: () {
                    Get.back();
                  },
                  selectedColor: colorBlue,
                  selected: true,
                  leading: const Icon(Icons.message_rounded),
                  title: const Text(
                    'Conversations',
                    style: TextStyle(fontSize: 18),
                  )),
              ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const ProfileScreen());
                  },
                  leading: const Icon(Icons.person),
                  title: const Text(
                    'Profile',
                    style: TextStyle(fontSize: 18),
                  )),
              ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const AccountDetails());
                  },
                  leading: const Icon(Icons.account_box_rounded),
                  title: const Text(
                    'Account Details',
                    style: TextStyle(fontSize: 18),
                  )),
              ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const SettingsScreen());
                  },
                  leading: const Icon(Icons.settings),
                  title: const Text(
                    'Settings',
                    style: TextStyle(fontSize: 18),
                  )),
              ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const ContactUsScreen());
                  },
                  leading: const Icon(Icons.phone),
                  title: const Text(
                    'Contact Us',
                    style: TextStyle(fontSize: 18),
                  )),
            ],
          ),
          const Spacer(),
          ListTile(
            onTap: () async {
              authProvider.handleSignOut();
              Fluttertoast.showToast(
                  msg: 'Logged out',
                  backgroundColor: colorBlue,
                  textColor: colorWhite,
                  gravity: ToastGravity.BOTTOM);
              Get.offAll(() => const WelcomeScreen(),
                  transition: Transition.downToUp);
            },
            leading: const Icon(Icons.logout_rounded),
            title: const Text('Logout', style: TextStyle(fontSize: 18)),
          ),
          verticalSpace(20)
        ],
      ),
    );
  }
}
