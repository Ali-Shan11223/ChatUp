import 'package:chat_up/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'dart:math' as math;

class CallScreen extends StatefulWidget {
  const CallScreen({Key? key}) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

final userId = math.Random().nextInt(10000).toString();

class _CallScreenState extends State<CallScreen> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Calling'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios_rounded)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: textEditingController,
              decoration: const InputDecoration(
                  hintText: 'Enter Calling ID', border: OutlineInputBorder()),
            ),
            verticalSpace(10),
            TextButton.icon(
                onPressed: () {
                  Get.to(() => AudioCallingScreen(
                      callId: textEditingController.text.toString()));
                },
                icon: const Icon(Icons.call),
                label: const Text('Call'))
          ],
        ),
      ),
    );
  }
}

class AudioCallingScreen extends StatelessWidget {
  final String callId;
  const AudioCallingScreen({Key? key, required this.callId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ZegoUIKitPrebuiltCall(
            appID: 757048881,
            appSign:
                'a57c74f6038724a5a7c6fcf79f701744b99cad76706e7db3d471ee7be80fe5c1',
            callID: callId,
            userID: userId,
            userName: userId,
            config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
              ..onOnlySelfInRoom = (context) {
                Navigator.pop(context);
              }));
  }
}
