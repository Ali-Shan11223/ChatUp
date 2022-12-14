import 'package:chat_up/consts/consts.dart';
import 'package:chat_up/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:get/get.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = [];
  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: slides,
      onDonePress: () {
        Get.to(() => const WelcomeScreen(), transition: Transition.downToUp);
      },
      colorActiveDot: colorWhite,
    );
  }

  @override
  void initState() {
    super.initState();
    slides.add(Slide(
        pathImage: 'assets/icons/private_messages.png',
        widthImage: 300,
        heightImage: 300,
        title: 'PRIVATE MESSAGES',
        description: 'Communicate with your friends via private messages.',
        backgroundColor: const Color(0xff6279d9)));
    slides.add(Slide(
        pathImage: 'assets/icons/group_chat.png',
        widthImage: 300,
        heightImage: 300,
        title: 'GROUP CHATS',
        description: 'Create group chats and stay in touch with your friends.',
        backgroundColor: const Color(0xff6279d9)));
    slides.add(Slide(
        pathImage: 'assets/icons/send_photos.png',
        widthImage: 300,
        heightImage: 300,
        title: 'SEND PHOTOS',
        description:
            'Have fun with your friends by sending photos and videos to each other.',
        backgroundColor: const Color(0xff6279d9)));
    slides.add(Slide(
        pathImage: 'assets/icons/notifications.png',
        widthImage: 300,
        heightImage: 300,
        title: 'GET NOTIFIED',
        description: 'Receive notifications when friends are looking for you.',
        backgroundColor: const Color(0xff6279d9)));
  }
}
