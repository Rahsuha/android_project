import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:passenger_app/ProfilePage/profile_tab.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:passenger_app/splashScreen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with custom options
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCmK0oEG7RkNPNMuSCDasOZwvcGcXhie3o",
      appId: "1:695748186376:android:fc47c97b4ef673749b9cbd",
      messagingSenderId: "695748186376",
      projectId: "passengerapp-9812f",
    ),
  );

  // Permission handling for location
  if (await Permission.locationWhenInUse.isDenied) {
    await Permission.locationWhenInUse.request();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MMU E-Hailing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
