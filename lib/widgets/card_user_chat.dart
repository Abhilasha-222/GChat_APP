//import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:gail_chat_app/API/apis.dart';
import 'package:gail_chat_app/helper/my_date_util.dart';
import 'package:gail_chat_app/models/chat_user.dart';
import 'package:gail_chat_app/models/message.dart';
import 'package:gail_chat_app/screens/chat_screen.dart';
import 'package:gail_chat_app/widgets/dialogs/profile_dialogs.dart';
import 'package:image_network/image_network.dart';

class CardUserChat extends StatefulWidget {
  final ChatUser user;
  const CardUserChat({super.key, required this.user});

  @override
  State<CardUserChat> createState() {
    return _CardUserChatState();
  }
}

class _CardUserChatState extends State<CardUserChat> {
  //last message info (if null --> no message)
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            15,
          ),
        ),
        elevation: 0.5,
        child: InkWell(
            onTap: () {
              // print(widget.user.image);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    user: widget.user,
                  ),
                ),
              );
            },
            child: StreamBuilder(
              stream: APIs.getLastMessaage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                if (list.isNotEmpty) _message = list[0];

                return ListTile(
                  tileColor: Color.fromARGB(255, 204, 204, 104),

                  leading: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => ProfileDialog(
                                user: widget.user,
                              ));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        child: ImageNetwork(
                          width: 40,
                          height: 40,
                          image: widget.user.image,
                        ),
                      ),
                    ),
                  ),
                  //user name
                  title: Text(widget.user.Name),

                  //last message
                  subtitle: Text(
                      _message != null
                          ? _message!.type == Type.image
                              ? 'image'
                              : _message!.msg
                          : widget.user.about,
                      maxLines: 1),

                  //last message time
                  trailing: _message == null
                      ? null //show nothing when no message is sent
                      : _message!.read.isEmpty &&
                              _message!.fromId != APIs.user.uid
                          ?
                          //show for unread message
                          Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 19, 120, 13),
                                  borderRadius: BorderRadius.circular(10)),
                            )
                          :
                          //message sent time
                          Text(
                              MyDateUtil.getLastMessageTime(
                                  context: context, time: _message!.sent),
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                );
              },
            )));
  }
}
