//import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gail_chat_app/API/apis.dart';
import 'package:gail_chat_app/helper/dialogs.dart';
import 'package:gail_chat_app/models/chat_user.dart';
import 'package:gail_chat_app/screens/login_Page.dart';
import 'package:gail_chat_app/screens/profile_setting.dart';
import 'package:gail_chat_app/widgets/theme_prefernces.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_network/image_network.dart';
// import 'package:provider/provider.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({
    super.key,
    required this.user,
  });
  final ChatUser? user;

  @override
  State<MainDrawer> createState() {
    return _MainDrawerState();
  }
}

class _MainDrawerState extends State<MainDrawer> {
  List<ChatUser> list = [];
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          if (widget.user != null)
            DrawerHeader(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 0,
                right: 20,
                left: 20,
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 212, 201, 70),
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Stack(children: [
                            //profile picture
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ImageNetwork(
                                width: 80,
                                height: 80,
                                image: widget.user!.image,
                              ),
                            ),
                            //edit button
                            Positioned(
                              bottom: -10,
                              width: 130,
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProfileSetting(
                                        user: APIs.me,
                                      ),
                                    ),
                                  );
                                },
                                shape: const CircleBorder(),
                                color: Colors.yellow,
                                elevation: 1,
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ]),
                          SizedBox(
                            width: 120,
                          ),
                          MaterialApp(
                            debugShowCheckedModeBanner: false,
                            theme: ThemeData.light(),
                            darkTheme: ThemeData.dark(),
                            themeMode: currentTheme.currentTheme(),
                          ),
                          IconButton(
                            onPressed: () {
                              currentTheme.switchTheme();
                            },
                            icon: Icon(Icons.wb_sunny),
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    child: Row(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 20,
                            ),
                          ),
                          Text(
                            widget.user!.Name,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          Text(
                            widget.user!.about,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      )
                    ]),
                  ),
                ],
              ),
            ),
          ListTile(
            leading: Icon(
              Icons.help,
              size: 26,
              color: Color.fromARGB(209, 182, 165, 9),
            ),
            title: Text(
              'Need Help?',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.share,
              size: 26,
              color: const Color.fromARGB(209, 182, 165, 9),
            ),
            title: Text(
              'Share',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.feedback,
              size: 26,
              color: const Color.fromARGB(209, 182, 165, 9),
            ),
            title: Text(
              'Feedback',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              size: 26,
              color: const Color.fromARGB(209, 182, 165, 9),
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            onTap: () async {
              //for showing progress dialog
              Dialogs.showProgressbar(context);

              await APIs.updateActiveStatus(false);

              //sign out from app
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then(
                  (value) {
                    APIs.auth = FirebaseAuth.instance;

                    //replacing home screen with login screen
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (ctx) => LoginPage()));
                  },
                );
              });
            },
          )
        ],
      ),
    );
  }
}
