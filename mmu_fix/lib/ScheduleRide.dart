import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:passenger_app/RideOption/rideOption.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:passenger_app/RideOption/rideOption.dart';


class ScheduleRide extends StatefulWidget {
  @override
  _ScheduleRideState createState() => _ScheduleRideState();
}

class _ScheduleRideState extends State<ScheduleRide> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final List<String> _numPassengers = ['1', '2', '3', '4', '5', '6'];
  String? _selectedPassengers = '1';
  late GoogleMapController mapController;
  LatLng? _currentLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  final _places = GoogleMapsPlaces(apiKey: "AIzaSyCJU-z_ECuOuLV3V2j3w8CPQqmpAkcCQY4");  // Insert your API Key
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  void _handledDateAndTimeSelection()
  {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime(2024,12,31),
      onConfirm: (date) {
        setState(() {
          _selectedDate = date;
          _selectedTime = TimeOfDay.fromDateTime(date);
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en
    );
  }


  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    loc.Location location = loc.Location();
    loc.PermissionStatus permissionGranted;
    bool serviceEnabled;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) return;
    }

    loc.LocationData locationData = await location.getLocation();
    setState(() {
      _currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentLocation!, zoom: 15),
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _selectDate(BuildContext context) async
  {
    final DateTime? picked = await showDatePicker(context: context
        , firstDate: DateTime.now(), lastDate: DateTime(2024,12),);
    if(picked != null && picked != _selectedDate)
      {
        setState(() {
          _selectedDate = picked;
        });
      }
  }
  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }
  Future<void> _handlePressButton(BuildContext context, TextEditingController controller, bool isPickup) async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: "AIzaSyCJU-z_ECuOuLV3V2j3w8CPQqmpAkcCQY4",  // Use your API key here
      mode: Mode.overlay,  // or Mode.fullscreen
      language: "en",
      components: [new Component(Component.country, "my")],
    );

    displayPrediction(p, controller, isPickup);
  }

  Future<void> displayPrediction(Prediction? p, TextEditingController controller, bool isPickup) async {
    if (p != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId!);
      double lat = detail.result.geometry!.location.lat;
      double lng = detail.result.geometry!.location.lng;

      setState(() {
        controller.text = detail.result.name;
        LatLng position = LatLng(lat, lng);
        if (isPickup) {
          _markers.add(Marker(
            markerId: MarkerId("pickup"),
            position: position,
            infoWindow: InfoWindow(title: "Pickup"),
          ));
        } else {
          _markers.add(Marker(
            markerId: MarkerId("destination"),
            position: position,
            infoWindow: InfoWindow(title: "Destination"),
          ));
          _polylines.add(Polyline(
            polylineId: PolylineId('route1'),
            visible: true,
            points: [_markers.first.position, _markers.last.position],
            width: 4,
            color: Colors.blue,
          ));
        }
        mapController.animateCamera(CameraUpdate.newLatLng(position));
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Schedule a Ride"),
          centerTitle: true,
          backgroundColor: Color(0xFFB8E2F2),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black,),
            onPressed: () => Navigator.of(context).pop(),
          )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _pickupController,
                decoration: InputDecoration(
                  hintText: 'Pick-up Location',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => _handlePressButton(context, _pickupController, true),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _destinationController,
                decoration: InputDecoration(
                  hintText: 'Destination',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => _handlePressButton(context, _destinationController, false),
                  ),
                ),
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: _selectedPassengers,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.blueAccent),
                underline: Container(
                  height: 2,
                  color: Colors.blueAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPassengers = newValue;
                  });
                },
                items: _numPassengers.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select Date'),
                  ),
                  SizedBox(width: 20),
                  Text('Selected Date : ${_selectedDate.toString().split(' ')[0]}'),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: Text('Select Time'),
                  ),
                  SizedBox(width: 20), // Adds space between the button and the text
                  Text('Selected Time: ${_selectedTime.format(context)}'),
                ],
              ),
              SizedBox(height: 30),
              Container(
                height: 300,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation ?? LatLng(0.0, 0.0), // Use current location if available
                    zoom: 15,
                  ),
                  markers: _markers,
                  polylines: _polylines,
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  child: Text("Show Ride Options"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB8E2f2),
                    minimumSize: Size(double.infinity, 50),
                    textStyle: TextStyle(fontSize: 18)
                  ), onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}






