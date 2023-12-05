import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class CommonWidgets {
  Future<void> addUser(String name,String phone) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('Users').doc(uid).set({
      'Uid': uid,
      'Phone': phone==''?FirebaseAuth.instance.currentUser!.phoneNumber:phone,
      'Email': FirebaseAuth.instance.currentUser!.email,
      'Name': name==''?FirebaseAuth.instance.currentUser!.displayName:name
    }).then((value) {
      print('Data set successfully');
    }).catchError((error) {
      print('Failed to set data: $error');
    });
  }
}