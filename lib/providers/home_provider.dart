import 'package:chat_up/consts/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeProvider {
  final FirebaseFirestore firebaseFirestore;

  HomeProvider({
    required this.firebaseFirestore,
  });

  // A future function to update data on database
  Future<void> updateFirestoreData(
      String collectionPath, String path, Map<String, String> updateData) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(updateData);
  }

  // A stream type function for showing users on home screen
  // And also for searching users
  Stream<QuerySnapshot> getFirestoreStream(
      String collectionPath, int limit, String? textSearch) {
    if (textSearch!.isNotEmpty == true) {
      return firebaseFirestore
          .collection(collectionPath)
          .limit(limit)
          .where(FirestoreConstants.nickName, isEqualTo: textSearch)
          .snapshots();
    } else {
      return firebaseFirestore
          .collection(collectionPath)
          .limit(limit)
          .snapshots();
    }
  }

  void getUserData() async {
    await firebaseFirestore
        .collection(FirestoreConstants.userCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }
}
