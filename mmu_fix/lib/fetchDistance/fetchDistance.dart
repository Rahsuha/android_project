import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

Future<double> fetchRouteDistance(LatLng start, LatLng end) async
{
  String url = 'https://maps.googleapis.com/maps/api/directions/json?'
      'origin=${start.latitude},${start.longitude}&'
      'destination=${end.latitude},${end.longitude}&'
      'key=AIzaSyCJU-z_ECuOuLV3V2j3w8CPQqmpAkcCQY4';

  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['routes'].isNotEmpty) {
      var route = jsonResponse['routes'][0];
      var leg = route['legs'][0];
      var distance = leg['distance']['value']; // Distance in meters
      return distance / 1000.0;
    }
  }
  throw Exception('Failed to load directions');
}
