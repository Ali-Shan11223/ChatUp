import 'package:chat_up/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountDetails extends StatelessWidget {
  const AccountDetails({Key? key}) : super(key: key);

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
                  child: const ListTile(
                    leading: Text(
                      'Nick Name',
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: Text('Ghost', style: TextStyle(fontSize: 16)),
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
                    children: const [
                      ListTile(
                        leading: Text(
                          'Name',
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing:
                            Text('Jennifer', style: TextStyle(fontSize: 16)),
                      ),
                      Divider(
                        height: 0,
                      ),
                      ListTile(
                        leading: Text(
                          'Email Address',
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: Text('jennifer@gmail.com',
                            style: TextStyle(fontSize: 16)),
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
