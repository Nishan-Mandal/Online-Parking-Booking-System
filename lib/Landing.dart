import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:online_parking/LoginPage.dart';
import 'package:online_parking/Parking%20Provider/AddParking.dart';
import 'package:online_parking/End%20User/UserDashbord.dart';

import 'Parking Provider/AdminDashboard.dart';

class Landing extends StatefulWidget {
  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                 navigate(true);
                },
                child: Text(
                  'User',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  navigate(false);
                },
                child: Text(
                  'Parking Provider',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigate(bool isUser) {
    //If user in not logged in
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(isUser: isUser)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => isUser?UserDashboard():AdminDashboard()),
      );
    }
  }
}
