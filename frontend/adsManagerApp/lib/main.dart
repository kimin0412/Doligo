import 'dart:async';

import 'package:dolligo_ads_manager/screens/root_page.dart';
import 'package:dolligo_ads_manager/screens/signup/signup_screen_3.dart';
import 'package:dolligo_ads_manager/screens/signup/signup_screen_4.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.deepPurpleAccent,
        accentColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      routes: {
        SignUpScreen3.routeName:(context) => SignUpScreen3(),
        SignUpScreen4.routeName:(context) => SignUpScreen4()
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    countDownTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                  child: Image.asset('assets/loadingCoin.gif', width: 500, height: 500)
              ),
              Container(
                  child: Image.asset('assets/loadingText.gif', width: 150, height: 150)
              ),
            ],
          ),
        )
    );
  }

  countDownTime() async {
    return Timer(
      Duration(seconds: 3),
          () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RootPage()),
        );
      },
    );
  }
}