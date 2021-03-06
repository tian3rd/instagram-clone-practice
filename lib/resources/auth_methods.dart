import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign up async future string
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List profileImage,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isEmpty ||
          password.isEmpty ||
          username.isEmpty ||
          bio.isEmpty) {
      } else {
        // register the user
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        print(userCredential.user!.uid);

        String photoUrl = await StorageMethods().uploadImageToStorage(
          "profileImages",
          profileImage,
          false,
        );

        // add user to database, create 'users' if it's not existed
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'username': username,
          'email': email,
          'bio': bio,
          'uid': userCredential.user!.uid,
          // 'profile_image': profileImage,
          'followers': [],
          'following': [],
          'photo_url': photoUrl,
        });

        // // another way which the doc id is different from uid
        // await _firestore.collection('user').add({
        //   'username': username,
        //   'email': email,
        //   'bio': bio,
        //   'uid': userCredential.user!.uid,
        //   // 'profile_image': profileImage,
        //   'followers': [],
        //   'following': [],
        // });

        res = 'success';
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        res = 'Email is invalid';
      } else if (error.code == 'weak-password') {
        res = 'Password is weak';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // sign in async future string
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all fields';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
