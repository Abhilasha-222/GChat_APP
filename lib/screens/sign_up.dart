import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gail_chat_app/screens/home_screen.dart';
//import 'package:date_time_picker/date_time_picker.dart';
import 'package:gail_chat_app/screens/login_Page.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:phone_number/phone_number.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() {
    return SignUpScreenState();
  }
}

class SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dateInput = TextEditingController();

  void initstate() {
    dateInput.text = "";
    super.initState();
  }

  void _signin() {
    // ignore: unused_local_variable
    final login = Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
        child: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 5,
                    ),
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[600]!.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextFormField(
                              controller: firstNameController,
                              decoration: const InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                border: InputBorder.none,
                                hintText: 'First Name: ',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Icon(
                                    Icons.person_2_outlined,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your First Name';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[600]!.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                border: InputBorder.none,
                                hintText: 'Last Name:',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Icon(
                                    Icons.person_2_outlined,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Last Name';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[600]!.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextFormField(
                              controller: dateInput,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                border: InputBorder.none,
                                hintText: 'Date Of Birth: ',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 19),
                                  child: Icon(
                                    // FontAwesomeIcons.calendar,
                                    Icons.calendar_today,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1980),
                                  lastDate: DateTime(2050),
                                );
                                if (pickedDate != null) {
                                  print(pickedDate);

                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);

                                  print(formattedDate);

                                  setState(() {
                                    dateInput.text = formattedDate;
                                  });
                                } else {}
                              },
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Date of Birth';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[600]!.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                border: InputBorder.none,
                                hintText: 'Email: ',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Icon(
                                    FontAwesomeIcons.solidEnvelope,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Email';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[600]!.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                border: InputBorder.none,
                                hintText: 'Phone Number: ',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 19),
                                  child: Icon(
                                    FontAwesomeIcons.phone,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[600]!.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                border: InputBorder.none,
                                hintText: 'Password: ',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 19),
                                  child: Icon(
                                    FontAwesomeIcons.lock,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                              textInputAction: TextInputAction.done,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Password';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Color.fromARGB(255, 226, 237, 103),
                              padding: EdgeInsets.only(
                                  top: 10, left: 40, right: 40, bottom: 10),
                              child: ElevatedButton(
                                onPressed: () {
                                  FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: emailController.text,
                                          password: passwordController.text)
                                      .then((value) {
                                    print("Created New Account");
                                    if (_formKey.currentState!.validate()) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => HomeScreen(),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('Please Fill details'),
                                        ),
                                      );
                                    }
                                  }).onError((error, stackTrace) {
                                    print("Error ${error.toString()}");
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                child: Text(
                                  'SignUp',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ClipRRect(
                            child: Container(
                                color: Color.fromARGB(255, 226, 235, 132),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  child: TextButton(
                                    child: Text(
                                      'Already Have an Account. Sign in!!',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black),
                                    ),
                                    onPressed: _signin,
                                  ),
                                )),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
