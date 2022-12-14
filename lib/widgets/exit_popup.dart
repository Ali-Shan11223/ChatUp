import 'package:chat_up/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

Future<bool> showExitPopUp(context) async {
  return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirmation',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'Are you sure you want to exit?',
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  exit(0);
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    backgroundColor: Colors.red,
                    shape: const StadiumBorder()),
                child: const Text('Yes')),
            ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    backgroundColor: colorBlue,
                    shape: const StadiumBorder()),
                child: const Text('No'))
          ],
        );
      });
}
