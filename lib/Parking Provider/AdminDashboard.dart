import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_parking/Parking%20Provider/AddParking.dart';
import 'package:online_parking/utils/CommonWidgets.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Parkings'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddParking()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildParkingList(),
      ),
    );
  }

  Widget _buildParkingList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Parkings').where('Uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid ).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var parkingData = snapshot.data!.docs[index];
              return _buildParkingCard(parkingData);
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildParkingCard(QueryDocumentSnapshot parkingData) {
    // Customize this method to create a card based on your Firestore document structure
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(parkingData['Location']),
        subtitle: Text('Available slots: ${parkingData['SlotsAvailable']}'),
        trailing: Text('Charge/hr:${parkingData['Charge']}' ),
        // Add more details as needed
      ),
    );
  }
}