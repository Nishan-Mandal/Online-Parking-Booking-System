import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_parking/End%20User/MyBookings.dart';
import 'package:online_parking/End%20User/SearchParking.dart';
import 'package:online_parking/Profile.dart';
import 'package:online_parking/utils/CommonWidgets.dart';

import 'BookParking.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _currentIndex = 1;
  final tabs = [
    Center(
      child: MyBookings(),
    ),
    Center(
      child: SearchParking(),
    ),
    Center(
      child: Profile(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'My Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
        body: tabs[_currentIndex]);
  }


}
