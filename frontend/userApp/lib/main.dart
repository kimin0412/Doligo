import 'package:flutter/material.dart';
import 'package:userApp/Screens/Signup/signup_screen_2.dart';
import 'package:userApp/leaflet_detail_page.dart';
import 'package:userApp/private_info_setting_page.dart';
import 'package:userApp/root_page.dart';

import 'Screens/Signup/signup_screen_3.dart';
import 'leaflet_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  static String commonUrl = 'http://k3a401.p.ssafy.io:8080/api';
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
        LeafletPage.routeName:(context) => LeafletPage(),
        PrivateInfoSettingPage.routeName:(context) => PrivateInfoSettingPage(),
        LeafletDetailPage.routeName:(context) => LeafletDetailPage(),
        SignUpScreen2.routeName:(context) => SignUpScreen2(),
        SignUpScreen3.routeName:(context) => SignUpScreen3(),
      },
    );
  }

}


