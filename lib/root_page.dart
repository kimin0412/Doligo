import 'package:flutter/material.dart';
import 'package:frontend/advertiser_tap_page.dart';
import 'package:frontend/tap_page.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //이 화면에서 로그인을 했는지 안 했는지 처리.
    return AdvertiserTabPage();
  }
}