import 'package:dolligo_ads_manager/screens/signup/components/body.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int a;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}