// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gail_chat_app/API/apis.dart';
import 'package:gail_chat_app/helper/dialogs.dart';
import 'package:gail_chat_app/models/chat_user.dart';
import 'package:gail_chat_app/widgets/card_user_chat.dart';
import 'package:gail_chat_app/widgets/main_drawer.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  //for storing all users
  List<ChatUser> list = [];

  //for storing search items
  final List<ChatUser> _searchList = [];

  //for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    APIs.firestore.collection('Users').snapshots();

    // //for setting user status to active
    // APIs.updateActiveStatus(true);

    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: APIs.getMyUsersId(),
        //get id of only known users
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // final data = snapshot.data?.docs;
            // final list =
            //     data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

            return StreamBuilder(
              stream: APIs.getAllUsers(
                  snapshot.data?.docs.map((e) => e.id).toList() ?? []),

              //get only those user who's ids are provided
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final data = snapshot.data?.docs;
                  final list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];

                  return GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: WillPopScope(
                      //if search is on & back button is pressed then close search
                      //or else simple close current screen on back button click
                      onWillPop: () {
                        if (_isSearching) {
                          setState(() {
                            _isSearching = !_isSearching;
                          });
                          return Future.value(false);
                        } else {
                          return Future.value(true);
                        }
                      },
                      child: Scaffold(
                        appBar: AppBar(
                          title: _isSearching
                              ? TextField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Name, Email, ...'),
                                  autofocus: true,
                                  style: TextStyle(
                                    fontSize: 20,
                                    letterSpacing: 0.5,
                                  ),
                                  //when search text changes then updated search list
                                  onChanged: (val) {
                                    //search logic
                                    _searchList.clear();
                                    for (var i in list) {
                                      if (i.Name.toLowerCase()
                                              .contains(val.toLowerCase()) ||
                                          i.email
                                              .toLowerCase()
                                              .contains(val.toLowerCase())) {
                                        _searchList.add(i);
                                      }
                                      setState(() {
                                        _searchList[0];
                                      });
                                    }
                                  },
                                )
                              : Text(
                                  'GChat',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                          actions: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _isSearching = !_isSearching;
                                });
                              },
                              icon: Icon((_isSearching
                                  ? CupertinoIcons.clear_circled_solid
                                  : Icons.search)),
                            ),
                          ],
                          centerTitle: true,
                          backgroundColor: Color.fromARGB(255, 226, 218, 55),
                        ),
                        drawer: MainDrawer(
                          user: APIs.me,
                        ),
                        //floating button to add new user
                        floatingActionButton: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: FloatingActionButton(
                            backgroundColor: Color.fromARGB(255, 226, 218, 55),
                            onPressed: () {
                              _addChatUserDialog();
                            },
                            child: Icon(Icons.add_comment_rounded),
                          ),
                        ),

                        //body
                        body: list.isEmpty
                            ? Center(
                                child: Text(
                                  'No Connections Found!',
                                ),
                              )
                            : ListView.builder(
                                itemCount: _isSearching
                                    ? _searchList.length
                                    : list.length,
                                padding: EdgeInsets.only(
                                  top: 2,
                                ),
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return CardUserChat(
                                    user: _isSearching
                                        ? _searchList[index]
                                        : list[index],
                                  );
                                  //return Text('Name: ${list[index]}');
                                },
                              ),
                      ),
                    ),
                  );
                }
              },
            );
          }
        });
  }

  //for adding new chat user
  void _addChatUserDialog() {
    String email = '';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 20,
          bottom: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        //title
        title: Row(
          children: const [
            Icon(
              Icons.person_add,
              color: Color.fromARGB(255, 210, 193, 42),
              size: 26,
            ),
            Text('  Add New Contact'),
          ],
        ),

        //content
        content: TextFormField(
          maxLines: null,
          onChanged: (value) => email = value,
          decoration: InputDecoration(
            hintText: 'Email Id',
            prefixIcon: Icon(
              Icons.email,
              color: Color.fromARGB(255, 210, 193, 42),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                15,
              ),
            ),
          ),
        ),
        actions: [
          //cancel button
          MaterialButton(
            onPressed: () {
              //hide alert dialog
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Color.fromARGB(255, 210, 193, 42),
                fontSize: 16,
              ),
            ),
          ),

          //Add button
          MaterialButton(
            onPressed: () async {
              //hide alert dialog
              Navigator.pop(context);
              if (email.isNotEmpty) {
                await APIs.addChatUser(email).then((value) {
                  if (!value) {
                    Dialogs.showSnackbar(context, 'User Does not Exits!');
                  }
                });
              }
            },
            child: Text(
              'Add',
              style: TextStyle(
                color: Color.fromARGB(255, 210, 193, 42),
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}

// switch (snapshot.connectionState) {
//   case ConnectionState.waiting:
//   case ConnectionState.none:
//     return const Center(child: CircularProgressIndicator());

//   //if some or all data is loaded then show it
//   case ConnectionState.active:
//   case ConnectionState.done:
