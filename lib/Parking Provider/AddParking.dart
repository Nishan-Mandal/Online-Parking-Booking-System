import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AddParking extends StatefulWidget {
  const AddParking({super.key});

  @override
  State<AddParking> createState() => _AddParkingState();
}

class _AddParkingState extends State<AddParking> {
  TextEditingController locationController = TextEditingController();
TextEditingController parkingSlotsController = TextEditingController();
TextEditingController chargeController = TextEditingController();


static List<String> _vehicles = ["SUV", "Sedan", "Compact SUV", "Bike"];

final _items = _vehicles
    .map((vehicle) => MultiSelectItem<String>(vehicle, vehicle))
    .toList();

  List<String> _selectedVehicle = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter Details'),),
      body: Container(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                        Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Location',
                  ))),
                        SizedBox(
            height: 10,
                        ),
                        Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                  controller: parkingSlotsController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'No. of Parking slots available',
                  ))),
                        SizedBox(
            height: 10,
                        ),
                        Padding(
            padding: const EdgeInsets.all(8.0),
            child: MultiSelectDialogField(
              dialogHeight: 200,
              items: _items,
              title: Text("Vehicle Type"),
              selectedColor: Colors.blue,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
              buttonIcon: Icon(
                Icons.pets,
                color: Colors.blue,
              ),
              buttonText: Text(
                "Vehicle Type",
                style: TextStyle(
                  color: Colors.blue[800],
                  fontSize: 16,
                ),
              ),
              onConfirm: (results) {
                _selectedVehicle.clear();
              _selectedVehicle.addAll(results.map((result) => result));
              },
            ),
                        ),
                        SizedBox(
            height: 10,
                        ),
                        Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                  controller: chargeController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Charge/hr',
                  ))),
                        SizedBox(
            height: 10,
                        ),
                        SizedBox(
            height: 10,
                        ),
                        Center(
            child: ElevatedButton(
              onPressed: () {
                addNewParking();
                Navigator.of(context).pop();
              },
              child: Text('Add Parking'),
            ),
                        ),
                      ]),
          )),
    );
  }

  Future<void> addNewParking() async {
    FirebaseFirestore.instance.collection('Parkings').add({
      'Location': locationController.text,
      'SlotsAvailable': parkingSlotsController.text,
      'VehicleType': _selectedVehicle,
      'Charge': chargeController.text,
      'Uid':FirebaseAuth.instance.currentUser?.uid
    }).then((value) {
      print('Data set successfully');
    }).catchError((error) {
      print('Failed to set data: $error');
    });
  }
}


