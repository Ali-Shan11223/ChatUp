import 'package:chat_up/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool value = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Settings',
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
              Material(
                color: colorWhite,
                elevation: 2,
                child: Column(
                  children: [
                    verticalSpace(20),
                    Row(
                      children: [
                        horizontalSpace(10),
                        Text(
                          'General',
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 18),
                        )
                      ],
                    ),
                    verticalSpace(10),
                    Row(
                      children: [
                        horizontalSpace(10),
                        const Expanded(
                          child: Text(
                            'Change Theme',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.light_mode_rounded)),
                      ],
                    )
                  ],
                ),
              ),
              verticalSpace(20),
              InkWell(
                onTap: () {},
                child: Material(
                  elevation: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    color: colorWhite,
                    child: const Center(
                      child: Text(
                        'Save',
                        style: TextStyle(color: colorBlue, fontSize: 18),
                      ),
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
