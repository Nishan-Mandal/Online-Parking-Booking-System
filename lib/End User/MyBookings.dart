import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyBookings extends StatefulWidget {
  @override
  _MyBookingsState createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings>
    with SingleTickerProviderStateMixin {
  // Initialize the tab controller
  late TabController _tabController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // Cancel any ongoing tasks or subscriptions here

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Past Bookings'),
            Tab(text: 'Upcoming Bookings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BookingList(isUpcoming: false),
          BookingList(isUpcoming: true),
        ],
      ),
    );
  }
}

class BookingList extends StatelessWidget {
  final bool isUpcoming;

  BookingList({required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: isUpcoming
          ? FirebaseFirestore.instance
              .collection('Bookings')
              .where('Uid', isEqualTo: uid)
              .where('From', isGreaterThan: DateTime.now())
              .snapshots()
          : FirebaseFirestore.instance
              .collection('Bookings')
              .where('Uid', isEqualTo: uid)
              .where('To', isLessThan: DateTime.now())
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        var bookings = snapshot.data!.docs;

        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            var booking = bookings[index].data() as Map<String, dynamic>;

            String location = booking['Location'];
            DateTime from = booking['From'].toDate();
            DateTime to = booking['To'].toDate();

            return Padding(
              padding: const EdgeInsets.only(left:8.0,right: 8.0),
              child: Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text('Location: $location'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('From: ${_formatDateTime(from)}'),
                      Text('To: ${_formatDateTime(to)}'),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  String _formatDateTime(DateTime dateTime) {
  // Format the DateTime as needed, e.g., "yyyy-MM-dd HH:mm:ss"
  return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
}
}
