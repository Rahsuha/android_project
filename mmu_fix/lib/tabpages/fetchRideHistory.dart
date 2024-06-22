import 'package:cloud_firestore/cloud_firestore.dart';

import 'RideHistory.dart';

Future<List<RideHistory>> fetchRideHistory() async {
  var collection = FirebaseFirestore.instance.collection('rideHistory');
  var snapshots = await collection.get();
  return snapshots.docs.map((doc) => RideHistory.fromMap(doc.data())).toList();
}
