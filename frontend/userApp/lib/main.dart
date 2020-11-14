import 'dart:async';

import 'package:background_fetch/background_fetch.dart';
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

/// This "Headless Task" is run when app is terminated.
void backgroundFetchHeadlessTask(String taskId) async {
  print('[BackgroundFetch] Headless event received.112');
  BackgroundFetch.finish(taskId);
}


void main() {
  runApp(MyApp());

  // Register to receive BackgroundFetch events after app is terminated.
  // Requires {stopOnTerminate: false, enableHeadless: true}
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}


class MyApp extends StatefulWidget {
  static String commonUrl = 'http://k3a401.p.ssafy.io:8080/api';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _enabled = true;
  int _status = 0;
  List<DateTime> _events = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: false,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.NONE
    ), (String taskId) async {
      // This is the fetch-event callback.
      print("[BackgroundFetch] Event received $taskId");
      setState(() {
        _events.insert(0, new DateTime.now());
      });
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }).then((int status) {
      print('[BackgroundFetch] configure success: $status');
      setState(() {
        _status = status;
      });
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
      setState(() {
        _status = e;
      });
    });

    // Optionally query the current BackgroundFetch status.
    int status = await BackgroundFetch.status;
    setState(() {
      _status = status;
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

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
      home: RootPage(),
      // home: SplashScreen(),
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


