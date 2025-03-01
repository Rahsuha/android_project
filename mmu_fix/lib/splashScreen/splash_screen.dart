import 'package:flutter/material.dart';
import 'package:passenger_app/login_screen.dart';

class SplashScreen extends StatefulWidget
{
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
{
  @override
  void initState()
  {
    super.initState();
    Future.delayed(Duration(seconds: 3), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>
            [
              Image.asset('assets/Car.png'),
            SizedBox(height: 20),
          ]
        )
      ),
    );
  }
}