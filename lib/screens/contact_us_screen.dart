import 'package:chat_up/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Contact Us',
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
            children: [
              Material(
                elevation: 2,
                child: Container(
                  width: double.infinity,
                  color: colorWhite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ListTile(
                        title: Text(
                          'Our Address',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Bacha Khan University Charsadda'),
                      ),
                      ListTile(
                        title: const Text(
                          'Email Us',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text('office@gmail.com'),
                        trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_forward_ios_rounded)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
