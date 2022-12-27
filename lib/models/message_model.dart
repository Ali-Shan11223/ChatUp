import 'package:chat_up/consts/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessages {
  String idFrom;
  String idTo;
  String timeStamp;
  String content;
  int type;

  ChatMessages(
      {required this.idFrom,
      required this.idTo,
      required this.timeStamp,
      required this.content,
      required this.type});

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.idFrom: idFrom,
      FirestoreConstants.idTo: idTo,
      FirestoreConstants.timeStamp: timeStamp,
      FirestoreConstants.content: content,
      FirestoreConstants.type: type
    };
  }

  factory ChatMessages.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get(FirestoreConstants.idFrom);
    String idTo = doc.get(FirestoreConstants.idTo);
    String timeStamp = doc.get(FirestoreConstants.timeStamp);
    String content = doc.get(FirestoreConstants.content);
    int type = doc.get(FirestoreConstants.type);
    return ChatMessages(
        idFrom: idFrom,
        idTo: idTo,
        timeStamp: timeStamp,
        content: content,
        type: type);
  }
}
