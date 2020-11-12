import 'dart:async';

import 'package:flutter/material.dart';
import 'package:userApp/Screens/Signup/signup_screen_2.dart';
import 'package:userApp/adblock_setting_page.dart';
import 'package:userApp/market_page_detail.dart';
import 'package:userApp/leaflet_detail_page.dart';
import 'package:userApp/market_page.dart';
import 'package:userApp/private_info_setting_page.dart';
import 'package:userApp/purchase_list.dart';
import 'package:userApp/purchase_list_detail.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.deepPurpleAccent,
        accentColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: RootPage(),
      home: SplashScreen(),
      routes: {
        LeafletPage.routeName:(context) => LeafletPage(),
        AdblockSettingPage.routeName:(context) => AdblockSettingPage(),
        PrivateInfoSettingPage.routeName:(context) => PrivateInfoSettingPage(),
        LeafletDetailPage.routeName:(context) => LeafletDetailPage(),
        SignUpScreen2.routeName:(context) => SignUpScreen2(),
        SignUpScreen3.routeName:(context) => SignUpScreen3(),
        MarketPage.routeName:(context) => MarketPage(),
        MarketPageDetail.routeName:(context) => MarketPageDetail(),
        PurchaseList.routeName:(context) => PurchaseList(),
        PurchaseListDetail.routeName:(context) => PurchaseListDetail(),

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


