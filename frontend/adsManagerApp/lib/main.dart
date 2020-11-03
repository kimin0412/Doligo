import 'package:dolligo_ads_manager/screens/root_page.dart';
import 'package:dolligo_ads_manager/screens/signup/signup_screen_4.dart';
import 'package:dolligo_ads_manager/screens/signup/signup_screen_5.dart';
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
      home: RootPage(),
      routes: {
        SignUpScreen4.routeName:(context) => SignUpScreen4(),
        SignUpScreen5.routeName:(context) => SignUpScreen5(),
      },
    );
  }
}