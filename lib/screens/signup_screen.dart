import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';

import '../utils/utils.dart';
import '../widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _biocontroller = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();
  Uint8List? _image; // can be null

  // This is the method that will be called when the user taps the login button.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _biocontroller.dispose();
    _usernamecontroller.dispose();
  }

  void selectImage() async {
    // use gallery to open user's photo gallery
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: Container(), flex: 2),
                    // svg logo
                    SvgPicture.asset(
                      'assets/ic_instagram.svg',
                      color: primaryColor,
                      height: 64,
                    ),
                    const SizedBox(height: 64),
                    // field input for avatar, circular widget to accept and show pic
                    Stack(children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg")),
                      Positioned(
                        child: IconButton(
                            icon: Icon(Icons.add_a_photo),
                            onPressed: selectImage),
                        bottom: -10,
                        right: -10,
                      )
                    ]),
                    const SizedBox(height: 16),
                    // text field input for username
                    TextFieldInput(
                      textEditingController: _usernamecontroller,
                      hintText: 'Enter your username',
                      textInputType: TextInputType.name,
                    ),
                    const SizedBox(height: 16),
                    // text field input for bio
                    TextFieldInput(
                      textEditingController: _biocontroller,
                      hintText: 'Enter your bio',
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    // text filed input for email address
                    TextFieldInput(
                      textEditingController: _emailController,
                      hintText: 'Enter your email',
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    // text field input for password
                    TextFieldInput(
                      textEditingController: _passwordController,
                      hintText: 'Enter your password',
                      isPassword: true,
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),

                    //
                    // button for login, use Container
                    InkWell(
                      onTap: () async {
                        String res = await AuthMethods().signUpUser(
                            email: _emailController.text,
                            password: _passwordController.text,
                            username: _usernamecontroller.text,
                            bio: _biocontroller.text,
                            profileImage: _image!);
                        print(res);
                      },
                      child: Container(
                        child: const Text('Sign Up'),
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            color: blueColor),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Flexible(child: Container(), flex: 2),
                    // transition to signup in row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: const Text('Don\'t have an account?'),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ],
                    )
                  ],
                ))));
  }
}
