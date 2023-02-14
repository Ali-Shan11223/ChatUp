
// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'dart:async';

import 'package:chat_up/consts/consts.dart';
import 'package:chat_up/consts/firestore_constants.dart';
import 'package:chat_up/helper/time_helper.dart';
import 'package:chat_up/models/message_model.dart';
import 'package:chat_up/providers/auth_provider.dart';
import 'package:chat_up/providers/chat_provider.dart';
import 'package:chat_up/screens/image_preview.dart';
import 'package:chat_up/screens/login_screen.dart';
import 'package:chat_up/widgets/loading_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.arguments}) : super(key: key);

  final ChatPageArguments arguments;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

final userId = math.Random().nextInt(10000).toString();

class _ChatScreenState extends State<ChatScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late String currentUserId;
  List<DocumentSnapshot> listOfMessages = [];
  int limit = 20;
  int incrementLimit = 20;
  String groupChatId = '';

  File? imageFile;
  String imageUrl = '';
  bool isLoading = false;
  bool isShowSticker = false;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  late ChatProvider chatProvider;
  late AuthProvider authProvider;

  // void requestPermission() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   NotificationSettings settings = await messaging.requestPermission();

  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print('User Granted Permission');
  //   } else if (settings.authorizationStatus ==
  //       AuthorizationStatus.provisional) {
  //     print('User Granted Provisional Permission');
  //   } else {
  //     print('User Declined or Has Not Accepted Permission');
  //   }
  // }

  // void getToken() async {
  //   await FirebaseMessaging.instance.getToken().then((token) {
  //     print('Push Token: $token');
  //     if (token != null) {
  //       FirebaseFirestore.instance
  //           .collection(FirestoreConstants.userCollection)
  //           .doc(currentUserId)
  //           .set({'pushToken': token});
  //     }
  //   });
  // }

  // initInfo() {
  //   var androidInitialize =
  //       const AndroidInitializationSettings('@mipmap/ic_launcher');
  //   var initializationSettings =
  //       InitializationSettings(android: androidInitialize);
  //   flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //       onDidReceiveNotificationResponse:
  //           (NotificationResponse? payLoad) async {
  //     try {
  //       if (payLoad != null) {
  //       } else {}
  //     } catch (e) {}
  //     return;
  //   });

  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //     print('................onMessage..............');
  //     print(
  //         'onMessage: ${message.notification?.title}/${message.notification?.body}');

  //     BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
  //         message.notification!.body.toString(),
  //         htmlFormatBigText: true,
  //         contentTitle: message.notification!.title,
  //         htmlFormatContentTitle: true);

  //     AndroidNotificationDetails androidNotificationDetails =
  //         const AndroidNotificationDetails('chatup', 'chatup',
  //             priority: Priority.high,
  //             importance: Importance.high,
  //             playSound: true);
  //     NotificationDetails notificationDetails =
  //         NotificationDetails(android: androidNotificationDetails);
  //     await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
  //         message.notification?.body, notificationDetails,
  //         payload: message.data['body']);
  //   });
  // }

  // void sendPushNotification(
  //     ChatMessages chatMessages, UserModel userModel) async {
  //   try {
  //     await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json',
  //           'Authorization':
  //               'key=AAAAMmN92cM:APA91bGmTg7zrrQ_78Sgdo6ooLXVmwArEFDuBiuvBvJeUxsHUd6Z8xCJWRv4x9w18lNMDEO_p5At3BYxhVh_CmV1ZuyBEQE6rZXavY8efi7Lw6JOiLtaYC5LKrGNrOFCs6-GTkz6I3Xn'
  //         },
  //         body: jsonEncode(<String, dynamic>{
  //           'priority': 'high',
  //           'data': <String, dynamic>{
  //             'click-action': 'FLUTTER_NOTIFICATION_CLICK',
  //             'status': 'done',
  //             'body': chatMessages.content,
  //             'title': userModel.nickName
  //           },
  //           'notification': <String, dynamic>{
  //             'title': userModel.nickName,
  //             'body': chatMessages.content,
  //             'android_channel_id': 'chatup'
  //           },
  //           'to': userModel.pushToken
  //         }));
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  @override
  void initState() {
    super.initState();

    chatProvider = context.read<ChatProvider>();
    authProvider = context.read<AuthProvider>();
    // requestPermission();
    // getToken();
    // initInfo();
    focusNode.addListener(onFocusChange);
    scrollController.addListener(scrollListener);
    getLocalData();
  }

  void getLocalData() {
    if (authProvider.getUserFirebaseId()?.isNotEmpty == true) {
      currentUserId = authProvider.getUserFirebaseId()!;
    } else {
      Get.offUntil(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          (route) => false);
    }
    String peerId = widget.arguments.peerId;
    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = '$currentUserId-$peerId';
    } else {
      groupChatId = '$peerId-$currentUserId';
    }
    chatProvider.updateFirestoreData(FirestoreConstants.userCollection,
        currentUserId, {FirestoreConstants.chattingWith: peerId});
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  scrollListener() {
    if (!scrollController.hasClients) return;
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange &&
        limit <= listOfMessages.length) {
      setState(() {
        limit += incrementLimit;
      });
    }
  }

  //my messages
  bool isMessageSent(int index) {
    if ((index > 0 &&
            listOfMessages[index - 1].get(FirestoreConstants.idFrom) !=
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  // peer messages
  bool isMessageReceived(int index) {
    if ((index > 0 &&
            listOfMessages[index - 1].get(FirestoreConstants.idFrom) ==
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  void onSendMessage(String content, int type) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      chatProvider.sendMessage(
          content, type, groupChatId, currentUserId, widget.arguments.peerId);
      if (scrollController.hasClients) {
        scrollController.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Type a message',
          backgroundColor: colorBlue,
          gravity: ToastGravity.BOTTOM);
    }
  }

  Future getImage(source) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile =
        await imagePicker.pickImage(source: source).catchError((err) {
      Fluttertoast.showToast(
          msg: err.toString(),
          backgroundColor: colorBlue,
          textColor: colorWhite,
          gravity: ToastGravity.BOTTOM);
    });

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    UploadTask uploadTask = chatProvider.uploadFile(imageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, MessageType.image);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: e.message ?? e.toString(),
          backgroundColor: colorBlue,
          gravity: ToastGravity.BOTTOM);
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      chatProvider.updateFirestoreData(FirestoreConstants.userCollection,
          currentUserId, {FirestoreConstants.chattingWith: null});
      Get.back();
    }
    return Future.value(false);
  }

  final callController = TextEditingController();

  Widget messageItem(int index, DocumentSnapshot? document) {
    if (document != null) {
      ChatMessages chatMessages = ChatMessages.fromDocument(document);
      if (chatMessages.idFrom == currentUserId) {
        //Right my messages
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                TimeHelper.getFormattedTime(context, chatMessages.timeStamp),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            chatMessages.type == MessageType.text
                ? Container(
                    decoration: const BoxDecoration(
                        color: senderColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                    margin: EdgeInsets.only(
                        bottom: isMessageSent(index) ? 20 : 10, right: 10),
                    child: Text(
                      chatMessages.content,
                      style: const TextStyle(
                        color: colorWhite,
                      ),
                    ),
                  )
                : chatMessages.type == MessageType.image
                    ? Container(
                        decoration: const BoxDecoration(
                          color: senderColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                        ),
                        margin: EdgeInsets.only(
                            bottom: isMessageSent(index) ? 20 : 10, right: 10),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(ImagePreview(image: chatMessages.content));
                          },
                          child: Material(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            clipBehavior: Clip.hardEdge,
                            child: Image.network(
                              chatMessages.content,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : Container()
          ],
        );
      } else {
        //peer messages
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  chatMessages.type == MessageType.text
                      ? Container(
                          decoration: const BoxDecoration(
                              color: receiverColor,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            chatMessages.content,
                            style: const TextStyle(
                              color: colorBlack,
                            ),
                          ),
                        )
                      : chatMessages.type == MessageType.image
                          ? Container(
                              decoration: const BoxDecoration(
                                color: receiverColor,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20)),
                              ),
                              margin: const EdgeInsets.only(left: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(ImagePreview(
                                      image: chatMessages.content));
                                },
                                child: Material(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.network(
                                    chatMessages.content,
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Text(
                      TimeHelper.getFormattedTime(
                          context, chatMessages.timeStamp),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.arguments.peerNickName,
          style: const TextStyle(letterSpacing: 1, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios_rounded)),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Center(child: Text('Add Call ID')),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      content: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: callController,
                        decoration: const InputDecoration(
                            isDense: true,
                            hintText: 'Enter Calling ID',
                            border: OutlineInputBorder()),
                      ),
                      actions: [
                        MaterialButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: colorBlue, fontSize: 16),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Get.back();
                            Get.to(() => AudioCallingScreen(
                                callId: callController.text.toString()));
                          },
                          child: const Text(
                            'Call',
                            style: TextStyle(color: colorBlue, fontSize: 16),
                          ),
                        )
                      ],
                      contentPadding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                    );
                  });
              //Get.to(() => CallScreen());
            },
            icon: const Icon(Icons.call),
            tooltip: 'Call',
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: onBackPress,
        child: Stack(
          children: [
            Column(
              children: [messagesList(), userInput()],
            ),
            showLoading()
          ],
        ),
      ),
    );
  }

  Widget messagesList() {
    return Flexible(
        child: groupChatId.isNotEmpty
            ? StreamBuilder<QuerySnapshot>(
                stream: chatProvider.getChatStream(groupChatId, limit),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    listOfMessages = snapshot.data!.docs;
                    if (listOfMessages.isNotEmpty) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, index) {
                          return messageItem(index, snapshot.data!.docs[index]);
                        },
                        reverse: true,
                        controller: scrollController,
                      );
                    } else {
                      return const Center(
                        child: Text('Inbox is empty'),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })
            : const Center(
                child: CircularProgressIndicator(
                  color: colorBlue,
                ),
              ));
  }

  Widget showLoading() {
    return Positioned(
        child: isLoading ? const LoadingView() : const SizedBox.shrink());
  }

  Widget userInput() {
    return Align(
      child: Container(
        width: double.infinity,
        height: 60,
        color: const Color(0xffF4F4F5),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //button getting image from camera and gallery
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Column(
                            children: const [
                              Center(
                                child: Text('Send Media'),
                              ),
                              Divider(
                                height: 1.5,
                              )
                            ],
                          ),
                          titlePadding: const EdgeInsets.only(
                              left: 10, top: 10, right: 10),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: colorBlue,
                                ),
                                title: const Text('Take a picture'),
                                onTap: () {
                                  getImage(ImageSource.camera);
                                  Get.back();
                                },
                              ),
                              const Divider(
                                height: 0,
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.photo_size_select_actual_rounded,
                                  color: colorBlue,
                                ),
                                title: const Text('Choose from gallery'),
                                onTap: () {
                                  getImage(ImageSource.gallery);
                                  Get.back();
                                },
                              ),
                              const Divider(
                                height: 0,
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.cancel_rounded,
                                  color: colorBlue,
                                ),
                                title: const Text('Cancel'),
                                onTap: () {
                                  Get.back();
                                },
                              )
                            ],
                          ),
                          contentPadding: EdgeInsets.zero,
                        );
                      });
                },
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: colorBlue,
                  size: 24,
                ),
              ),
            ),
            horizontalSpace(8),
            //button for getting emojis
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.face_rounded,
                  color: colorBlue,
                  size: 24,
                ),
              ),
            ),
            horizontalSpace(8),
            Flexible(
                child: TextField(
              controller: textEditingController,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              minLines: 1,
              maxLines: 3,
              onSubmitted: (value) {
                onSendMessage(textEditingController.text, MessageType.text);
              },
              decoration: InputDecoration(
                hintText: 'Type your message here',
                hintStyle: const TextStyle(fontSize: 16),
                fillColor: colorWhite,
                filled: true,
                isDense: true,
                contentPadding: const EdgeInsets.all(10),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        const BorderSide(color: Colors.black26, width: 0.2)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        const BorderSide(color: colorWhite, width: 0.2)),
              ),
              focusNode: focusNode,
            )),

            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    onSendMessage(textEditingController.text, MessageType.text);
                  },
                  child: const Icon(
                    Icons.send_rounded,
                    color: colorBlue,
                    size: 24,
                  ),
                ),
              ),
            )
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

class ChatPageArguments {
  final String peerId;
  final String peerNickName;

  ChatPageArguments({required this.peerId, required this.peerNickName});
}
