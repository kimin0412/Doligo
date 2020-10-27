import 'package:flutter/material.dart';
import 'package:doligo/tap_page.dart';
import 'package:doligo/login_page.dart';
import 'package:doligo/Screens/Login/login_screen.dart';
import 'package:doligo/Screens/Welcome/welcome_screen.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //이 화면에서 로그인을 했는지 안 했는지 처리.
    // return TabPage();
    return WelcomeScreen();
  }
}