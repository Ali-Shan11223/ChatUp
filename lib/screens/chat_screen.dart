// import 'package:audioplayers/audioplayers.dart';
// import 'package:chat_bubbles/chat_bubbles.dart';
// import 'package:chat_up/consts/consts.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   AudioPlayer audioPlayer = AudioPlayer();
//   Duration duration = const Duration();
//   Duration position = const Duration();
//   bool isPlaying = false;
//   bool isLoading = false;
//   bool isPause = false;

//   @override
//   Widget build(BuildContext context) {
//     final now = DateTime.now();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Username',
//           style: TextStyle(letterSpacing: 1, fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//             onPressed: () {
//               Get.back();
//             },
//             icon: const Icon(Icons.arrow_back_ios_rounded)),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Column(
//               children: [
//                 DateChip(
//                   date: DateTime(now.year, now.month, now.day),
//                 ),
//                 const BubbleSpecialThree(
//                   text: 'Where are you??',
//                   color: colorBlue,
//                   tail: false,
//                   textStyle: TextStyle(color: Colors.white, fontSize: 16),
//                   seen: true,
//                 ),
//                 const BubbleSpecialThree(
//                   text: 'I am waiting..',
//                   color: colorBlue,
//                   tail: true,
//                   textStyle: TextStyle(color: Colors.white, fontSize: 16),
//                   seen: true,
//                 ),
//                 const BubbleSpecialThree(
//                   text: 'Ohhh sorry, I am coming please wait..',
//                   color: Color(0xFFE8E8EE),
//                   tail: false,
//                   isSender: false,
//                 ),
//                 const BubbleSpecialThree(
//                   text: 'On my way',
//                   color: Color(0xFFE8E8EE),
//                   tail: true,
//                   isSender: false,
//                 ),
//                 const SizedBox(
//                   height: 100,
//                 )
//               ],
//             ),
//           ),
//           MessageBar(
//             onSend: (_) => print(_),
//             actions: [
//               InkWell(
//                 child: const Icon(
//                   Icons.add,
//                   color: Colors.black,
//                   size: 24,
//                 ),
//                 onTap: () {},
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8, right: 8),
//                 child: InkWell(
//                   child: const Icon(
//                     Icons.camera_alt,
//                     color: Colors.green,
//                     size: 24,
//                   ),
//                   onTap: () {},
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }

//   void _changeSeek(double value) {
//     setState(() {
//       audioPlayer.seek(Duration(seconds: value.toInt()));
//     });
//   }

//   // void _playAudio() async {
//   //   final url =
//   //       'https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3';
//   //   if (isPause) {
//   //     await audioPlayer.resume();
//   //     setState(() {
//   //       isPlaying = true;
//   //       isPause = false;
//   //     });
//   //   } else if (isPlaying) {
//   //     await audioPlayer.pause();
//   //     setState(() {
//   //       isPlaying = false;
//   //       isPause = true;
//   //     });
//   //   } else {
//   //     setState(() {
//   //       isLoading = true;
//   //     });
//   //     await audioPlayer.play(url);
//   //     setState(() {
//   //       isPlaying = true;
//   //     });
//   //   }

//   //   audioPlayer.onDurationChanged.listen((Duration d) {
//   //     setState(() {
//   //       duration = d;
//   //       isLoading = false;
//   //     });
//   //   });
//   //   audioPlayer.onAudioPositionChanged.listen((Duration p) {
//   //     setState(() {
//   //       position = p;
//   //     });
//   //   });
//   //   audioPlayer.onPlayerCompletion.listen((event) {
//   //     setState(() {
//   //       isPlaying = false;
//   //       duration = new Duration();
//   //       position = new Duration();
//   //     });
//   //   });
//   // }
// }
