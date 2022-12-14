import 'package:chat_up/consts/consts.dart';
import 'package:chat_up/screens/accountdetails_screen.dart';
import 'package:chat_up/screens/contact_us_screen.dart';
import 'package:chat_up/screens/settings_screen.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(letterSpacing: 1, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              verticalSpace(20),
              CircleAvatar(
                radius: 70,
                backgroundColor: colorBlue,
                backgroundImage: const NetworkImage(
                    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80'),
                child: Stack(children: const [
                  Positioned(
                    right: 0,
                    bottom: 12,
                    child: Material(
                      shape: CircleBorder(side: BorderSide.none),
                      elevation: 8,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: colorBlue,
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: colorWhite,
                        ),
                      ),
                    ),
                  )
                ]),
              ),
              verticalSpace(20),
              verticalSpace(30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text(
                      'Update Profile',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: colorBlack),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(width: 2, color: colorGrey)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
