import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'front_page.dart';
import 'main.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  handleAuthState(){
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return  NFTBuyingPage();
          } else {
            return MyApp();
          }
        });
  }

  Future<UserCredential> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

       final FirebaseAuth authfire = FirebaseAuth.instance;
        final User? user = authfire.currentUser;
        CollectionReference collref = FirebaseFirestore.instance.collection("user_kart");
        List<String> ls = [];
        Map<String,dynamic> mp = {
          "kart": ls
        };
        
        //print("stage2");
        await collref.doc(user!.uid).set(mp);

      return userCredential;
    } catch (e) {
      print("not possible");
      throw e;
    }
  }

  Future<UserCredential> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      // Handle error
      throw e;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
