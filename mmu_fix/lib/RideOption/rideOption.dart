import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passenger_app/RideOption/ConfirmBooking.dart';
import 'package:passenger_app/fetchDistance/fetchDistance.dart';

class Rideoption extends StatefulWidget {
  final LatLng pickupLocation;
  final LatLng destinationLocation;

  Rideoption({required this.pickupLocation,required this.destinationLocation});
  @override
  State<Rideoption> createState() => _RideoptionState();
}

class _RideoptionState extends State<Rideoption> {
  late GoogleMapController mapController;
  Set<Polyline> _polylines = {};

  @override
  void initState()
  {
    super.initState();
    _polylines.add(
      Polyline(polylineId: PolylineId("route1"),
      visible: true,
      points: [widget.pickupLocation,widget.destinationLocation],
      width: 4,
      color: Colors.blue,)
    );
  }
  void _onMapCreated(GoogleMapController controller)
  {
    mapController = controller;
  }
  double calculateFare(double distance, String  rideType)
  {
    double baseRate = 2.0;
    double rate = baseRate;

    switch(rideType)
        {
      case "MotoRide":
        rate = baseRate;
        break;
      case "4-Seater Car":
        rate = baseRate;
        break;
      case "6-Seater Car":
        break;
    }
    return rate * distance;
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ride Options"),
        backgroundColor: Color(0xFFB8E2F2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(
              (widget.pickupLocation.latitude + widget.destinationLocation.latitude) / 2,
              (widget.pickupLocation.longitude + widget.destinationLocation.longitude) / 2,
          ),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId("pickup"),
            position: widget.pickupLocation,
            infoWindow: InfoWindow(title: 'Pick-up Location'),
          ),
          Marker(
            markerId: MarkerId("destination"),
            position: widget.destinationLocation,
            infoWindow: InfoWindow(title: 'Destination Location'),
      ),
        },
        polylines: _polylines,
      ),
      bottomSheet: rideOptionsPanel(),
    );
  }
  Widget rideOptionsPanel()
  {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0),
          topRight: Radius.circular(18.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFB8E2F2),
            blurRadius: 3.0,
            spreadRadius: 0.5,
            offset: Offset(0.7,0.7),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>
          [
           rideOptionButton(Icons.two_wheeler, "MotoRide"),
            SizedBox(height: 20),
            rideOptionButton(Icons.directions_car, "4-Seater Car"),
            SizedBox(height: 20),
            rideOptionButton(Icons.directions_car, "6-Seater Car"),
          ],
        ),
      ),
    );
  }
  Widget rideOptionButton(IconData icon, String title)
  {
    return ElevatedButton.icon(
      onPressed: () async {
        try
            {
              double distance = await fetchRouteDistance(widget.pickupLocation, widget.destinationLocation);
              double fare = calculateFare(distance, title);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConfirmBooking(
                pickupLocation: widget.pickupLocation,
                destinationLocation: widget.destinationLocation,
                rideType : title,
                fare: fare,
              ),));
            }
        catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Failed to fetch route: $e"),
          ));
        }
      },
    icon: Icon(icon,size: 24, color: Colors.black,),
      label: Text("$title"),
    style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFFB8E2F2),
      textStyle: TextStyle(fontSize: 16),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      minimumSize: Size(double.infinity, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),);
  }
}


