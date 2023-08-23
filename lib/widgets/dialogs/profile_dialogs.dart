import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gail_chat_app/models/chat_user.dart';
import 'package:gail_chat_app/screens/view_profile_screen.dart';
// import 'package:image_network/image_network.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      backgroundColor: Color.fromARGB(255, 236, 173, 15).withOpacity(0.9),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
        20,
      )),
      content: SizedBox(
        width: 50,
        height: 35,
        child: Stack(
          children: [
            //user profile picture
            Positioned(
              top: 10,
              left: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CachedNetworkImage(
                    width: 50,
                    fit: BoxFit.cover,
                    imageUrl: user.image,
                    errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person),
                          //image: user.image,
                        )),
              ),
            ),

            //user name
            Positioned(
              left: 4,
              top: 2,
              width: 55,
              child: Text(
                user.Name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            //info button
            Positioned(
              right: 8,
              top: 6,
              child: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewProfileScreen(user: user),
                    ),
                  );
                },
                minWidth: 0,
                padding: EdgeInsets.all(0),
                shape: CircleBorder(),
                child: Icon(
                  Icons.info_outline,
                  color: Colors.yellow,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
