import 'dart:io';
import 'package:chat_up/consts/consts.dart';
import 'package:chat_up/consts/firestore_constants.dart';
import 'package:chat_up/models/user_model.dart';
import 'package:chat_up/providers/profile_provider.dart';
import 'package:chat_up/widgets/loading_view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController? nickNameController;
  TextEditingController? aboutMeController;

  final FocusNode focusNodeNickName = FocusNode();
  final FocusNode focusNodeAboutMe = FocusNode();

  String id = '';
  String nickName = '';
  String aboutMe = '';
  String photoUrl = '';
  String emailAddress = '';

  bool isLoading = false;
  File? avatarProfile;
  late ProfileProvider profileProvider;

  void getLocalData() {
    setState(() {
      id = profileProvider.getPref(FirestoreConstants.id) ?? '';
      nickName = profileProvider.getPref(FirestoreConstants.nickName) ?? '';
      aboutMe = profileProvider.getPref(FirestoreConstants.aboutMe) ?? '';
      photoUrl = profileProvider.getPref(FirestoreConstants.photoUrl) ?? '';
      emailAddress =
          profileProvider.getPref(FirestoreConstants.emailAddress) ?? '';
    });

    nickNameController = TextEditingController(text: nickName);
    aboutMeController = TextEditingController(text: aboutMe);
  }

  @override
  void initState() {
    super.initState();
    profileProvider = context.read<ProfileProvider>();
    getLocalData();
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
    File? image;
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    if (image != null) {
      setState(() {
        avatarProfile = image;
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = id;
    UploadTask uploadTask =
        profileProvider.uploadFile(avatarProfile!, fileName);
    try {
      TaskSnapshot taskSnapshot = await uploadTask;
      photoUrl = await taskSnapshot.ref.getDownloadURL();
      UserModel updateUser = UserModel(
          id: id,
          photoUrl: photoUrl,
          nickName: nickName,
          emailAddress: emailAddress,
          aboutMe: aboutMe);
      profileProvider
          .updateFirestoreData(
              FirestoreConstants.userCollection, id, updateUser.toJson())
          .then((data) async {
        await profileProvider.setPref(FirestoreConstants.photoUrl, photoUrl);
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: 'Updated Successfully',
            backgroundColor: colorBlue,
            textColor: colorWhite,
            gravity: ToastGravity.BOTTOM);
      }).catchError((err) {
        setState(() {
          isLoading = false;
          Fluttertoast.showToast(
              msg: err.toString(),
              backgroundColor: colorBlue,
              textColor: colorWhite,
              gravity: ToastGravity.BOTTOM);
        });
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: e.message ?? e.toString(),
          backgroundColor: colorBlue,
          textColor: colorWhite,
          gravity: ToastGravity.BOTTOM);
    }
  }

  void handleUpdateData() {
    focusNodeAboutMe.unfocus();
    focusNodeNickName.unfocus();
    setState(() {
      isLoading = true;
    });
    UserModel updateUser = UserModel(
        id: id, photoUrl: photoUrl, nickName: nickName, aboutMe: aboutMe);
    profileProvider
        .updateFirestoreData(
            FirestoreConstants.userCollection, id, updateUser.toJson())
        .then((value) async {
      await profileProvider.setPref(FirestoreConstants.nickName, nickName);
      await profileProvider.setPref(FirestoreConstants.aboutMe, aboutMe);
      await profileProvider.setPref(FirestoreConstants.photoUrl, photoUrl);
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: 'Updated Successfully',
          backgroundColor: colorBlue,
          textColor: colorWhite,
          gravity: ToastGravity.BOTTOM);
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: err.toString(),
          backgroundColor: colorBlue,
          textColor: colorWhite,
          gravity: ToastGravity.BOTTOM);
    });
  }

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
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Column(
                children: [
                  verticalSpace(25),
                  Stack(children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: colorBlue,
                      child: avatarProfile == null
                          ? photoUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    photoUrl,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.account_circle_rounded,
                                  color: colorWhite,
                                  size: 100,
                                )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.file(
                                avatarProfile!,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 8,
                      child: Material(
                        shape: const CircleBorder(side: BorderSide.none),
                        elevation: 8,
                        child: CircleAvatar(
                            radius: 18,
                            backgroundColor: colorBlue,
                            child: IconButton(
                              onPressed: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Column(
                                          children: const [
                                            Center(
                                              child: Text('Select Image'),
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
                                              title: const Text('From Camera'),
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
                                                Icons
                                                    .photo_size_select_actual_rounded,
                                                color: colorBlue,
                                              ),
                                              title: const Text('From Gallery'),
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
                              icon: const Icon(
                                Icons.camera_alt_rounded,
                                color: colorWhite,
                                size: 19,
                              ),
                            )),
                      ),
                    )
                  ]),
                  verticalSpace(30),
                  //input
                  //nickname
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        child: Text(
                          'Nickname',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                      )),
                  verticalSpace(6),
                  //nickname Textfield
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: TextField(
                      controller: nickNameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          hintText: 'Nickname',
                          isDense: true,
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(color: Colors.grey)),
                      onChanged: (value) {
                        nickName = value;
                      },
                      focusNode: focusNodeNickName,
                    ),
                  ),
                  verticalSpace(20),
                  //aboutme
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        child: Text(
                          'About Me',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                      )),
                  verticalSpace(6),
                  //aboutme Textfield
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: TextField(
                      controller: aboutMeController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          hintText: 'Type about me',
                          isDense: true,
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(color: Colors.grey)),
                      onChanged: (value) {
                        aboutMe = value;
                      },
                      focusNode: focusNodeAboutMe,
                    ),
                  ),
                  verticalSpace(40),

                  ElevatedButton(
                    onPressed: handleUpdateData,
                    child: const Text(
                      'Update Profile',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
                child:
                    isLoading ? const LoadingView() : const SizedBox.shrink())
          ],
        ),
      ),
    );
  }
}
