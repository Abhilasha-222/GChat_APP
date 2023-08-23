import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gail_chat_app/API/apis.dart';
import 'package:gail_chat_app/helper/dialogs.dart';
import 'package:gail_chat_app/helper/my_date_util.dart';
import 'package:gail_chat_app/models/message.dart';
import 'package:gallery_saver/gallery_saver.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
        onLongPress: () {
          _showBottomSheet(isMe);
        },
        child: isMe ? _whiteMessage() : _blueMessage());
  }

  //sender or another user message
  Widget _blueMessage() {
    //update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ? 7 : 20),
            margin: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 99, 173, 233),
                border: Border.all(color: Color.fromARGB(255, 253, 228, 8)),
                //making borders curved
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
            //show text
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  )
                //show image
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
        //message time
        Padding(
          padding: const EdgeInsets.only(right: 30),
          child: Text(
            MyDateUtil.getFormattedTime(
              context: context,
              time: widget.message.sent,
            ),
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        )
      ],
    );
  }

  //our or user message
  Widget _whiteMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            //for adding some space
            SizedBox(
              width: 25,
            ),

            //double tick green icon for message read
            if (widget.message.read.isNotEmpty)
              Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
              ),

            //for adding some space
            SizedBox(
              width: 2,
            ),

            //sent time

            Text(
              MyDateUtil.getFormattedTime(
                context: context,
                time: widget.message.sent,
              ),
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(
              widget.message.type == Type.image ? 7 : 20,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border.all(color: const Color.fromARGB(255, 253, 228, 8)),
                //making borders curved
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                )),
            //show text
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  )
                //show image
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  //bottom sheet for modifying message details
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 5,
                margin: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 150,
                ),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 210, 193, 42),
                    borderRadius: BorderRadius.circular(8)),
              ),

              widget.message.type == Type.text
                  ?
                  //copy option
                  _optionItem(
                      icon: Icon(
                        Icons.copy_all_rounded,
                        color: Color.fromARGB(255, 210, 193, 42),
                        size: 26,
                      ),
                      name: 'Copy Text',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          //for hiding bottom sheet
                          Navigator.pop(context);

                          Dialogs.showSnackbar(
                            context,
                            'Text Copied',
                          );
                        });
                      },
                    )
                  :
                  //save image
                  _optionItem(
                      icon: Icon(
                        Icons.download_rounded,
                        color: Color.fromARGB(255, 210, 193, 42),
                        size: 26,
                      ),
                      name: 'Save Image',
                      onTap: () async {
                        try {
                          print('Image Url: ${widget.message.msg}');
                          await GallerySaver.saveImage(
                            widget.message.msg,
                            albumName: ' GChat',
                          ).then((success) {
                            Navigator.pop(context);

                            if (success != null && success) {
                              Dialogs.showSnackbar(
                                context,
                                'Image Successfully Saved!',
                              );
                            }
                          });
                        } catch (e) {
                          print('ErrorWhileSavingImage : $e');
                        }
                      },
                    ),

              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: 4,
                  indent: 4,
                ),

              //edit option
              if (widget.message.type == Type.text && isMe)
                _optionItem(
                  icon: Icon(
                    Icons.edit,
                    color: Color.fromARGB(255, 210, 193, 42),
                    size: 26,
                  ),
                  name: 'Edit Message',
                  onTap: () {
                    //for hiding bottom sheet
                    Navigator.pop(context);

                    _showMessageUpdateDialog();
                  },
                ),

              //delete option
              if (isMe)
                _optionItem(
                  icon: Icon(
                    Icons.delete_forever,
                    color: Color.fromARGB(255, 210, 193, 42),
                    size: 26,
                  ),
                  name: 'Delete Message',
                  onTap: () async {
                    await APIs.deleteMessage(widget.message).then((value) {});
                    //for hiding bottom sheet
                    Navigator.pop(context);

                    Dialogs.showSnackbar(
                      context,
                      'Message Deleted',
                    );
                  },
                ),

              Divider(
                color: Colors.black45,
                endIndent: 4,
                indent: 4,
              ),

              //sent time
              _optionItem(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Color.fromARGB(255, 210, 193, 42),
                ),
                //name: 'Sent At: ',
                name: 'Sent At: ${MyDateUtil.getMessageTime(
                  context: context,
                  time: widget.message.sent,
                )}',
                onTap: () {},
              ),

              //read time
              _optionItem(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.green,
                ),
                //name: "Read At: Not Seen Yet ",
                name: widget.message.read.isEmpty
                    ? 'Read At: Not seen yet'
                    : 'Read At: ${MyDateUtil.getMessageTime(
                        context: context,
                        time: widget.message.read,
                      )}',
                onTap: () {},
              ),
            ],
          );
        });
  }

  //dialog for updating message content
  void _showMessageUpdateDialog() {
    String updatedMsg = widget.message.msg;
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
              Icons.message,
              color: Color.fromARGB(255, 210, 193, 42),
              size: 26,
            ),
            Text(' Edit Message'),
          ],
        ),

        //content
        content: TextFormField(
          initialValue: updatedMsg,
          maxLines: null,
          onChanged: (value) => updatedMsg = value,
          decoration: InputDecoration(
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

          //update button
          MaterialButton(
            onPressed: () {
              //hide alert dialog
              Navigator.pop(context);
              APIs.updateMessage(widget.message, updatedMsg);
            },
            child: Text(
              'Update',
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

class _optionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _optionItem({
    required this.icon,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          top: 15,
          bottom: 15,
        ),
        child: Row(
          children: [
            icon,
            Flexible(
              child: Text(
                '    $name',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
