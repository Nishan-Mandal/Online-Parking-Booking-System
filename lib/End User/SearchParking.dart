import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_parking/End%20User/BookParking.dart';

class SearchParking extends StatefulWidget {
  const SearchParking({super.key});

  @override
  State<SearchParking> createState() => _SearchParkingState();
}

class _SearchParkingState extends State<SearchParking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Parking Locations')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildParkingList(),
      ),
    );
  }

  Widget _buildParkingList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Parkings').snapshots(),
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
    color: Colors.blue[100], // Set your desired background color here
    child: ListTile(
      title: Text(
        parkingData['Location'],
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '${parkingData['Charge']}/hr',
        style: TextStyle(fontSize: 14),
      ),
      trailing: ElevatedButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookParking(
                parkingId: parkingData.id,
                totalSlotsAvailable: parkingData['SlotsAvailable'],
                location: parkingData['Location'],
              ),
            ),
          );
        },
        child: Text('Book'),
      ),
    ),
  );
}
}
