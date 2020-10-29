import 'package:dolligo_ads_manager/screens/tap_page.dart';
import 'package:dolligo_ads_manager/screens/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //이 화면에서 로그인을 했는지 안 했는지 처리.
    // return TabPage();
    return WelcomeScreen();
  }
}