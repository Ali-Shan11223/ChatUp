import 'dart:async';

import 'package:chat_up/consts/consts.dart';
import 'package:chat_up/consts/firestore_constants.dart';
import 'package:chat_up/models/user_chat.dart';
import 'package:chat_up/providers/auth_provider.dart';
import 'package:chat_up/providers/home_provider.dart';
import 'package:chat_up/screens/login_screen.dart';
import 'package:chat_up/utilities/debouncer.dart';

import 'package:chat_up/widgets/exit_popup.dart';
import 'package:chat_up/widgets/loading_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/my_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Debouncer searchDebouncer = Debouncer(milliSeconds: 300);
  StreamController<bool> btnClearController = StreamController<bool>();

  late AuthProvider authProvider;
  late HomeProvider homeProvider;
  late String currentUserId;

  int limit = 20;
  int limitIncrement = 20;
  String textSearch = '';
  bool isLoading = false;

  final searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    authProvider = context.read<AuthProvider>();
    homeProvider = context.read<HomeProvider>();

    if (authProvider.getUserFirebaseId()!.isNotEmpty == true) {
      currentUserId = authProvider.getUserFirebaseId()!;
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          (route) => false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    btnClearController.close();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopUp(context),
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Conversations',
            style: TextStyle(letterSpacing: 1, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () {},
        //   label: const Text('Start Chat'),
        //   tooltip: 'New message',
        //   icon: const Icon(Icons.message_rounded),
        //   backgroundColor: colorBlue,
        // ),
        drawer: const MyDrawer(),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Stack(
              children: [
                Column(
                  children: [
                    searchBar(),
                    verticalSpace(10),
                    Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: homeProvider.getFirestoreStream(
                                FirestoreConstants.userCollection,
                                limit,
                                textSearch),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data!.docs.isNotEmpty) {
                                  return ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) =>
                                          showUsers(context,
                                              snapshot.data!.docs[index]));
                                } else {
                                  return const Center(
                                    child: Text('No Users'),
                                  );
                                }
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: colorBlue,
                                  ),
                                );
                              }
                            }))
                  ],
                ),
                Positioned(
                    child: isLoading
                        ? const LoadingView()
                        : const SizedBox.shrink())
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget searchBar() {
    return Container(
      height: 50,
      child: Row(
        children: [
          horizontalSpace(15),
          const Icon(
            Icons.search_rounded,
            color: Colors.grey,
            size: 20,
          ),
          horizontalSpace(5),
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              controller: searchController,
              keyboardType: TextInputType.name,
              onChanged: ((value) {
                if (value.isNotEmpty) {
                  searchDebouncer.run(() {
                    btnClearController.add(true);
                    setState(() {
                      textSearch = value;
                    });
                  });
                } else {
                  btnClearController.add(false);
                  setState(() {
                    textSearch = '';
                  });
                }
              }),
              decoration: InputDecoration(
                  hintText: 'Search for friends',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none),
                  isDense: true),
            ),
          ),
          StreamBuilder<bool>(
              stream: btnClearController.stream,
              builder: (context, snapshot) {
                return snapshot.data == true
                    ? GestureDetector(
                        onTap: () {
                          searchController.clear();
                          btnClearController.add(false);
                          setState(() {
                            textSearch = '';
                          });
                        },
                        child: const Icon(
                          Icons.clear_rounded,
                          color: Colors.grey,
                          size: 20,
                        ),
                      )
                    : const SizedBox.shrink();
              })
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: Colors.grey.shade200),
    );
  }

  Widget showUsers(BuildContext context, DocumentSnapshot? document) {
    if (document != null) {
      UserChat userChat = UserChat.fromDocument(document);
      if (userChat.id == currentUserId) {
        return const SizedBox.shrink();
      } else {
        return ListTile(
          onTap: () {
            // Get.to(() => const MyHomePage());
          },
          contentPadding: const EdgeInsets.only(bottom: 10),
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: colorBlue,
            child: userChat.photoUrl.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      userChat.photoUrl,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(
                    Icons.account_circle_rounded,
                    size: 30,
                  ),
          ),
          title: Text(
            userChat.nickName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            'About Me: ${userChat.aboutMe}',
            maxLines: 1,
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}
