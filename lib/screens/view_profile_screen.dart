import 'package:flutter/material.dart';
import 'package:gail_chat_app/helper/my_date_util.dart';
import 'package:gail_chat_app/models/chat_user.dart';
import 'package:image_network/image_network.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key, required this.user});
  final ChatUser user;
  @override
  State<ViewProfileScreen> createState() {
    return _ViewProfileScreenState();
  }
}

//view profile screen -- to view profile of user
class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'GChat',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 226, 218, 55),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Joined On: ',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              MyDateUtil.getLastMessageTime(
                context: context,
                time: widget.user.createdAt,
                showYear: true,
              ),
              style: const TextStyle(color: Colors.black87, fontSize: 16),
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50),
              ),
              Text(
                widget.user.Name,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                //user Profile picture
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ImageNetwork(
                    width: 100,
                    height: 100,
                    image: widget.user.image,
                  ),
                ),
              ]),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.user.email,
                style: const TextStyle(color: Colors.black87, fontSize: 16),
              ),
              SizedBox(
                height: 30,
              ),

              //user about
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'About: ',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    widget.user.about,
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
