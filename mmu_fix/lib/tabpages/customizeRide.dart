import 'package:flutter/material.dart';

class CustomizeRidePage extends StatefulWidget {
  @override
  _CustomizeRidePageState createState() => _CustomizeRidePageState();
}

class _CustomizeRidePageState extends State<CustomizeRidePage> {
  bool _adjustableSeat = false;
  bool _adjustableTemperature = false;
  bool _music = false;
  bool _quietMode = false;
  bool _socialMode = false;
  bool _fastestRoute = false;
  bool _speedLimitAlert = false;
  bool _nightVision = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Customize My Ride"),
        backgroundColor: Color(0xFFB8E2F2),
        leading: const BackButton(color: Colors.black),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Text("Custom Comfort", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          CheckboxListTile(
            title: Text("Adjustable Seat"),
            value: _adjustableSeat,
            onChanged: (bool? value) {
              setState(() {
                _adjustableSeat = value!;
              });
            },
          ),
          CheckboxListTile(
            title: Text("Adjustable Car Temperature"),
            value: _adjustableTemperature,
            onChanged: (bool? value) {
              setState(() {
                _adjustableTemperature = value!;
              });
            },
          ),
          CheckboxListTile(
            title: Text("Music"),
            value: _music,
            onChanged: (bool? value) {
              setState(() {
                _music = value!;
              });
            },
          ),
          SizedBox(height: 20),
          Text("Ride Preference", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          CheckboxListTile(
            title: Text("Quiet Mode"),
            value: _quietMode,
            onChanged: (bool? value) {
              setState(() {
                _quietMode = value!;
              });
            },
          ),
          CheckboxListTile(
            title: Text("Social Mode"),
            value: _socialMode,
            onChanged: (bool? value) {
              setState(() {
                _socialMode = value!;
              });
            },
          ),
          CheckboxListTile(
            title: Text("Fastest Route"),
            value: _fastestRoute,
            onChanged: (bool? value) {
              setState(() {
                _fastestRoute = value!;
              });
            },
          ),
          SizedBox(height: 20),
          Text("Safety", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          CheckboxListTile(
            title: Text("Enable Speed Limit Alert"),
            value: _speedLimitAlert,
            onChanged: (bool? value) {
              setState(() {
                _speedLimitAlert = value!;
              });
            },
          ),
          CheckboxListTile(
            title: Text("Enable Night Vision"),
            value: _nightVision,
            onChanged: (bool? value) {
              setState(() {
                _nightVision = value!;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              // Action to finalize customization
              // Potentially save these settings or apply them
              print("Customizations applied");
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black, backgroundColor: Color(0xFFB8E2F2),
              textStyle: TextStyle(fontSize: 16),
              minimumSize: Size(double.infinity, 50),
              elevation: 5,
            ),
            child: Text("Customize My Ride"),
          )
        ],
      ),
    );
  }
}
