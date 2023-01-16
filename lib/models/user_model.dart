// ignore_for_file: empty_catches

import 'package:chat_up/consts/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String photoUrl;
  String nickName;
  String? emailAddress;
  String aboutMe;
  String pushToken;

  UserModel(
      {required this.id,
      required this.photoUrl,
      required this.nickName,
      this.emailAddress,
      required this.aboutMe,
      required this.pushToken});

  Map<String, String> toJson() {
    return {
      FirestoreConstants.nickName: nickName,
      FirestoreConstants.aboutMe: aboutMe,
      FirestoreConstants.photoUrl: photoUrl
    };
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    String nickName = '';
    String aboutMe = '';
    String photoUrl = '';
    String emailAddress = '';
    String pushToken = '';
    try {
      nickName = doc.get(FirestoreConstants.nickName);
    } catch (e) {}
    try {
      emailAddress = doc.get(FirestoreConstants.emailAddress);
    } catch (e) {}
    try {
      aboutMe = doc.get(FirestoreConstants.aboutMe);
    } catch (e) {}
    try {
      photoUrl = doc.get(FirestoreConstants.photoUrl);
    } catch (e) {}
    try {
      pushToken = doc.get(FirestoreConstants.pushToken);
    } catch (e) {}
    return UserModel(
        id: doc.id,
        photoUrl: photoUrl,
        nickName: nickName,
        aboutMe: aboutMe,
        emailAddress: emailAddress,
        pushToken: pushToken);
  }
}
