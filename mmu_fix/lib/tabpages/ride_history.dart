import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'RideHistory.dart';
import 'fetchRideHistory.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity'),
        centerTitle: true,
        backgroundColor: Color(0xFFB8E2F2),
        leading: const BackButton(color: Colors.black),
        elevation: 0,
      ),
      body: FutureBuilder<List<RideHistory>>(
        future: fetchRideHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var ride = snapshot.data![index];
                return ListTile(
                  title: Text(ride.destination),
                  subtitle: Text(
                      '${ride.dateTime} - RM ${ride.cost.toStringAsFixed(2)}'),
                );
              },
            );
          } else {
            return Center(child: Text('No ride history found.'));
          }
        },
      ),
    );
  }
}


