import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passenger_app/RideOption/rideOption.dart';


class Searchscreen extends StatefulWidget {
  @override
  _SearchscreenState createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  TextEditingController _pickUpSearchFieldController = TextEditingController();
  TextEditingController _destinationSearchController = TextEditingController();
  late GoogleMapsPlaces _places;
  LatLng? _pickUpLocation;
  LatLng? _destinationLocation;


  @override
  void initState() {
    super.initState();
    _places = GoogleMapsPlaces(apiKey: "AIzaSyCJU-z_ECuOuLV3V2j3w8CPQqmpAkcCQY4");
  }


  Future<void> _openAutocomplete(TextEditingController controller, bool isPickup) async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: "AIzaSyCJU-z_ECuOuLV3V2j3w8CPQqmpAkcCQY4",  // Your API key
        mode: Mode.overlay,  // or Mode.fullscreen
        language: "en",
        components: [Component(Component.country, "my")]
    );

    if (p != null) {
      _getPlaceDetail(p.placeId,controller,isPickup);
    }
  }

  Future<void> _getPlaceDetail(String? placeId, TextEditingController controller, bool isPickup) async {
    if (placeId != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(placeId);
      setState(() {
        controller.text = detail.result.name;
        LatLng location = LatLng(detail.result.geometry!.location.lat, detail.result.geometry!.location.lng);
        if(isPickup)
          {
            _pickUpLocation = location;
          }
        else
          {
            _destinationLocation = location;
          }
        print("${detail.result.name} - ${detail.result.geometry?.location.lat}, ${detail.result.geometry?.location.lng}");
      });
    }
  }

  void _navigateToRideOptions()
  {
    if(_pickUpLocation != null && _destinationLocation != null)
      {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Rideoption(
          pickupLocation : _pickUpLocation!,
          destinationLocation : _destinationLocation!,
        ),
        ));
      }
    else
      {
        print("Error : Both Location need to be selected");
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFB8E2F2),
        leading: const BackButton(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>
          [
            _buildSearchField(_pickUpSearchFieldController,'Pick-Up Location', true),
            SizedBox(height: 16),
            _buildSearchField(_destinationSearchController,'Where To? ', false),
            SizedBox(height: 24),
            Expanded(
                child:Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0,2),
                      )
                    ],
                  ),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: _navigateToRideOptions,
                      child: Text("Show Ride Options"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFB8E2F2),
                        minimumSize: Size(double.infinity, 50),
                        textStyle: TextStyle(fontSize: 18)
                      ),
                    ),
                  ),
                )
            )

          ],
        ),
      ),
    );
  }
  Widget _buildSearchField(TextEditingController controller, String hint, bool isPickup)
  {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.search, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      onTap: () => _openAutocomplete(controller, isPickup),
    );
  }
}
