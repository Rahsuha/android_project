import 'package:flutter/material.dart';
import 'package:passenger_app/ScheduleRide.dart';
import 'package:passenger_app/tabpages/customizeRide.dart';
import 'package:passenger_app/tabpages/rideSharing.dart';

class ServiceTab extends StatefulWidget {

  @override
  State<ServiceTab> createState() => _ServiceTabState();
}

class _ServiceTabState extends State<ServiceTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Services"),
        centerTitle: true,
        backgroundColor: Color(0xFFB8E2F2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              serviceButton(context, "Ride Sharing", Icons.directions_car, (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => RideSharingPage()));
              }),
              SizedBox(height: 20),
              serviceButton(context, "Customize My Ride ", Icons.build, (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CustomizeRidePage()));
              }),
              SizedBox(height: 20),
              serviceButton(context, "Schedule a Ride", Icons.calendar_today,(){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleRide()));
              }),
              SizedBox(height: 20,),
              serviceButton(context, "Register as Driver" , Icons.person_add,(){}),
            ],
          ),
        ),
      ),
    );
  }
  Widget serviceButton(BuildContext, String title, IconData icon, VoidCallback onPressed)
  {
    return  Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ElevatedButton.icon(
          icon: Icon(icon, color: Colors.black),
      label: Text(title),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFB8E2F2),
        foregroundColor: Colors.black,
        textStyle: TextStyle(fontSize: 16),
        minimumSize: Size(double.infinity, 50),
        elevation: 5,
      ),),
    );
  }
}
