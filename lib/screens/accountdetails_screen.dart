import 'package:chat_up/consts/consts.dart';
import 'package:chat_up/consts/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({Key? key}) : super(key: key);

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  String nickName = '';
  String email = '';

  getDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    var getData = await FirebaseFirestore.instance
        .collection(FirestoreConstants.userCollection)
        .doc(user!.uid)
        .get();
    setState(() {
      nickName = getData.data()!['nickname'];
      email = getData.data()!['emailaddress'];
    });
  }

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Account Details',
            style: TextStyle(letterSpacing: 1, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace(20),
              Row(
                children: [
                  horizontalSpace(10),
                  Text(
                    'PUBLIC INFO',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 18),
                  ),
                ],
              ),
              verticalSpace(10),
              Material(
                elevation: 2,
                child: Container(
                  color: colorWhite,
                  child: ListTile(
                    leading: const Text(
                      'Nick Name',
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing:
                        Text(nickName, style: const TextStyle(fontSize: 16)),
                  ),
                ),
              ),
              verticalSpace(20),
              Row(
                children: [
                  horizontalSpace(10),
                  Text(
                    'PRIVATE DETAILS',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 18),
                  ),
                ],
              ),
              verticalSpace(10),
              Material(
                elevation: 2,
                child: Container(
                  color: colorWhite,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Text(
                          'Email Address',
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing:
                            Text(email, style: const TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
