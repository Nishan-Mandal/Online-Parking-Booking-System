import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';

class BookParking extends StatefulWidget {
  final String parkingId; // New variable
  final String totalSlotsAvailable;
  final String location;
  // Constructor with parkingId parameter
  BookParking(
      {super.key,
      required this.parkingId,
      required this.totalSlotsAvailable,
      required this.location});

  @override
  State<BookParking> createState() => _BookParkingState();
}

class _BookParkingState extends State<BookParking> {
  TextEditingController vehicleNoController = TextEditingController();

  static List<String> _vehicles = ["SUV", "Sedan", "Compact SUV", "Bike"];

  var _items = _vehicles
      .map((vehicle) => MultiSelectItem<String>(vehicle, vehicle))
      .toList();

  List<String> _selectedVehicle = [];
  var startDateTime;
  var endtDateTime;
  var slotsAvailable = 0;
  bool isVisible = false;

  @override
  void initState() {
    getVehicleTypeAvailable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Parking')),
      body: Container(
          child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    DateTimeRangePicker(
                        startText: "From",
                        endText: "To",
                        doneText: "Ok",
                        cancelText: "Cancel",
                        interval: 30,
                        initialStartTime: DateTime.now(),
                        initialEndTime: DateTime.now(),
                        mode: DateTimeRangePickerMode.dateAndTime,
                        minimumTime: DateTime.now().subtract(Duration(days: 1)),
                        maximumTime: DateTime.now().add(Duration(days: 25)),
                        use24hFormat: true,
                        onConfirm: (start, end) {
                          print(start);
                          print(end);
                          setState(() {
                            startDateTime = start;
                            endtDateTime = end;
                          });
                        }).showPicker(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          2.0), // Set the radius to 0 for a rectangle
                    ),
                  ),
                  child: Text('Pick Date time'),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              startDateTime != null
                  ? Text('From: $startDateTime')
                  : Text('From:'),
              endtDateTime != null ? Text('To: $endtDateTime') : Text('To:'),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 50, right: 50),
                child: MultiSelectDialogField(
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
                    Icons.book,
                    color: Colors.blue,
                  ),
                  buttonText: Text(
                    "Vehicle Type",
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontSize: 16,
                    ),
                  ),
                  dialogHeight: 200,
                  onConfirm: (results) {
                    _selectedVehicle.clear();
                    _selectedVehicle.addAll(results.map((result) => result));
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_selectedVehicle.length > 0) {
                      slotsAvailable = await noOfSlotAvailable(
                          startDateTime, endtDateTime, widget.parkingId);
                      // _showParkingAvailabilityDialog(context, slotsAvailable);

                      setState(() {
                        isVisible = true;
                      });
                    }
                  },
                  child: Text('Check Availability'),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              isVisible
                  ? Container(
                      height: 200,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[100],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 10,),
                          slotsAvailable == 0
                              ? Text(
                                  'Parking not available!',
                                  style: TextStyle(color: Colors.red),
                                )
                              : Text('Available: ${slotsAvailable}',
                                  style: TextStyle(color: Colors.green)),
                          SizedBox(height: 10.0),
                          slotsAvailable != 0
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 16),
                                  child: TextField(
                                      controller: vehicleNoController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Vehicle No.',
                                      )))
                              : SizedBox(),
                          SizedBox(height: 10.0),
                          ElevatedButton(
                            onPressed: () {
                              if (slotsAvailable > 0 &&
                                  _selectedVehicle.length > 0) {
                                addNewBooking();
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text('Book Now',style: TextStyle(color: Colors.green),),
                          ),
                        ],
                      ),
                    )
                  : SizedBox()
            ]),
      )),
    );
  }

  Future<void> addNewBooking() async {
    FirebaseFirestore.instance.collection('Bookings').add({
      'ParkingId': widget.parkingId,
      'Uid': FirebaseAuth.instance.currentUser!.uid,
      'From': startDateTime,
      'To': endtDateTime,
      'VehicleType': _selectedVehicle[0],
      'VehicleNo': vehicleNoController.text,
      'Location': widget.location,
    }).then((value) {
      print('Data set successfully');
    }).catchError((error) {
      print('Failed to set data: $error');
    });
  }

  Future<void> getVehicleTypeAvailable() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Parkings')
          .doc(widget.parkingId)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data()! as Map<String, dynamic>;
        List<dynamic> vehicle = data['VehicleType'];
        setState(() {
          _items = vehicle
              .map((vehicle) => MultiSelectItem<String>(vehicle, vehicle))
              .toList();
        });
      } else {
        print('Document does not exist');
      }
    } catch (error) {
      print('Error getting document: $error');
    }
  }

  void _showParkingAvailabilityDialog(
      BuildContext context, var slotsAvailable) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              slotsAvailable == 0
                  ? Text(
                      'Parking not available!',
                      style: TextStyle(color: Colors.red),
                    )
                  : Text('Available: ${slotsAvailable}',
                      style: TextStyle(color: Colors.green)),
              SizedBox(height: 10.0),
              slotsAvailable != 0
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextField(
                          controller: vehicleNoController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Vehicle No.',
                          )))
                  : SizedBox(),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  if (slotsAvailable > 0) {
                    addNewBooking();
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Book Now'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<int> noOfSlotAvailable(
      DateTime startTime, DateTime endTime, String parkingId) async {
    try {
      // Query to check for overlapping bookings on 'To'
      QuerySnapshot overlappingTo = await FirebaseFirestore.instance
          .collection('Bookings')
          .where('ParkingId', isEqualTo: parkingId)
          .get();

      // Find the common documents by filtering the documents that satisfy both conditions
      int commonDocCount = 0;
      for (QueryDocumentSnapshot toSnapshot in overlappingTo.docs) {
        DateTime dbStartDate = toSnapshot['From'].toDate();
        DateTime dbEndDate = toSnapshot['From'].toDate();
        // Check for overlapping time intervals
        if (!(endTime.isBefore(dbStartDate) || startTime.isAfter(dbEndDate))) {
          commonDocCount++;
        }
      }

      // Calculate and return the available slots
      int totalSlots = int.parse(widget.totalSlotsAvailable);
      return totalSlots - commonDocCount;
    } catch (error) {
      print('Error checking time slot availability: $error');
      return 0;
    }
  }
}
