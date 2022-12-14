import 'package:chat_up/consts/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserChat {
  String id;
  String photoUrl;
  String nickName;
  String emailAddress;
  String aboutMe;

  UserChat(
      {required this.id,
      required this.photoUrl,
      required this.nickName,
      required this.emailAddress,
      required this.aboutMe});

  Map<String, String> toJson() {
    return {
      FirestoreConstants.nickName: nickName,
      FirestoreConstants.emailAddress: emailAddress,
      FirestoreConstants.aboutMe: aboutMe,
      FirestoreConstants.photoUrl: photoUrl
    };
  }

  factory UserChat.fromDocument(DocumentSnapshot doc) {
    String nickName = '';
    String aboutMe = '';
    String photoUrl = '';
    String emailAddress = '';
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
    return UserChat(
        id: doc.id,
        photoUrl: photoUrl,
        nickName: nickName,
        aboutMe: aboutMe,
        emailAddress: emailAddress);
  }
}
