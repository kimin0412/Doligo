import 'package:flutter/material.dart';
import 'package:userApp/leaflet_detail_page.dart';
import 'package:userApp/root_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static String commonUrl = 'http://k3a401.p.ssafy.io:8080/api/';
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
        LeafletDetailPage.routeName:(context) => LeafletDetailPage()
      },
    );
  }

}


