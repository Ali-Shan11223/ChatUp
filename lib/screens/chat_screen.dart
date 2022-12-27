import 'dart:io';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_up/consts/consts.dart';
import 'package:chat_up/consts/firestore_constants.dart';
import 'package:chat_up/providers/auth_provider.dart';
import 'package:chat_up/providers/chat_provider.dart';
import 'package:chat_up/screens/login_screen.dart';
import 'package:chat_up/widgets/loading_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.arguments}) : super(key: key);

  final ChatPageArguments arguments;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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

  @override
  void initState() {
    super.initState();
    chatProvider = context.read<ChatProvider>();
    authProvider = context.read<AuthProvider>();
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

  //for receiving messages
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

  // for sending messages
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

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
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
      ),
      body: WillPopScope(
        onWillPop: onBackPress,
        child: Stack(
          children: [
            Column(
              children: [buildInput()],
            ),
            //buildLoading()
          ],
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Positioned(
        child: isLoading ? const LoadingView() : const SizedBox.shrink());
  }

  Widget buildInput() {
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
            InkWell(
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
                        titlePadding:
                            const EdgeInsets.only(left: 10, top: 10, right: 10),
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
                              title: const Text('Choose image from gallery'),
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
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: colorBlue,
                  size: 24,
                ),
              ),
            ),
            //button for getting emojis
            InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: const Icon(
                  Icons.face_rounded,
                  color: colorBlue,
                  size: 24,
                ),
              ),
            ),

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
              child: InkWell(
                onTap: () {
                  onSendMessage(textEditingController.text, MessageType.text);
                },
                child: const Icon(
                  Icons.send_rounded,
                  color: colorBlue,
                  size: 24,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChatPageArguments {
  final String peerId;
  final String peerNickName;

  ChatPageArguments({required this.peerId, required this.peerNickName});
}
