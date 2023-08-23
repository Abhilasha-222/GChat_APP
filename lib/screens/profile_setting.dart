//import 'dart:developer';

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gail_chat_app/API/apis.dart';
import 'package:gail_chat_app/helper/dialogs.dart';
import 'package:gail_chat_app/models/chat_user.dart';
import 'package:gail_chat_app/screens/home_screen.dart';
//import 'package:gail_chat_app/widgets/main_drawer.dart';
import 'package:image_network/image_network.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({super.key, required this.user});
  final ChatUser? user;
  @override
  State<StatefulWidget> createState() {
    return _ProfileSettingState();
  }
}

class _ProfileSettingState extends State<ProfileSetting> {
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  String? _image;

  List<ChatUser> list = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            // automaticallyImplyLeading: false,
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
          body: Form(
            key: _formKey,
            child: Center(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                  ),
                  Text(
                    'Profile Setting',
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
                    _image != null
                        ?

                        //local image
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(_image!),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                              left: 70,
                            ),
                          ),
                    //image from server
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ImageNetwork(
                        width: 100,
                        height: 100,
                        image: widget.user!.image,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 0,
                        right: 0,
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          _showBottomSheet();
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
                    height: 20,
                  ),
                  Text(
                    widget.user!.email,
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      //top: 100,
                      bottom: 20,
                      left: 35,
                      right: 35,
                    ),
                    child: TextFormField(
                      initialValue: widget.user!.Name,
                      onSaved: (val) => APIs.me.Name = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        label: Text('Name'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      //top: 100,
                      bottom: 20,
                      left: 35,
                      right: 35,
                    ),
                    child: TextFormField(
                      initialValue: widget.user!.about,
                      onSaved: (val) => APIs.me.about = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.info,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'eg: Feeling Happy',
                        label: Text('About'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        APIs.UpdateUserInfo().then((value) {
                          Dialogs.showSnackbar(
                              context, 'Profile Update Successfully!');
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomeScreen(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 226, 218, 55),
                        shape: const StadiumBorder(),
                        minimumSize: Size(50, 50)),
                    child: Text(
                      'UPDATE',
                      style: TextStyle(
                          fontSize: 16,
                          //fontWeight: FontWeight.,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  //bottom sheet for picking a profile picture for user
  void _showBottomSheet() {
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
            padding: EdgeInsets.only(
              top: 30,
              bottom: 50,
            ),
            children: [
              //pick profile picture label
              Text(
                'Pick Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      fixedSize: Size(120, 120),
                    ),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 80);
                      if (image != null) {
                        log('Image Path: ${image.path} --MimeType: ${image.mimeType}');
                        setState(() {
                          _image = image.path;
                        });
                        APIs.updateProfilePicture(File(_image!));

                        Navigator.pop(context);
                      }
                    },
                    child: Image.asset('assets/images/add_image.png'),
                  ),

                  //take picture from camera button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: CircleBorder(),
                      fixedSize: Size(120, 120),
                    ),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        log('Image Path: ${image.path} ');
                        setState(() {
                          _image = image.path;
                        });

                        APIs.updateProfilePicture(File(_image!));

                        Navigator.pop(context);
                      }
                    },
                    child: Image.asset('assets/images/camera_image.png'),
                  ),
                ],
              )
            ],
          );
        });
  }
}
