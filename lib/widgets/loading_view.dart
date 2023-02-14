import 'package:chat_up/consts/consts.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorBlack.withOpacity(0.8),
      child: const Center(
        child: CircularProgressIndicator(
          color: colorBlue,
        ),
      ),
    );
  }
}
