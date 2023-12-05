import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_parking/Landing.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                //backgroundImage: AssetImage('assets/profile_picture.jpg'), // Add your profile picture asset
              ),
              SizedBox(height: 16.0),
              Text(
                'Nishan Mandal',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'User',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 24.0),
              Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'About Me',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Phone: +9111232332\nEmail: nishan@gmail.com',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  // Add logic for navigating to edit profile screen
                },
                child: Text('Edit Profile'),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  // FirebaseAuth.instance.signOut();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => Landing()),
                  // );
                },
                child: Text('Logout'),
              ),
            ],
          )),
    );
  }
}
