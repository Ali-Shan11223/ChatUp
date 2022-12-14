import 'package:flutter/material.dart';

import '../consts/consts.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const CustomButton({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: colorBlue,
        ),
        child: Center(
            child: Text(
          title,
          style: const TextStyle(
              color: colorWhite, fontSize: 20, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
