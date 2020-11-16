import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:userApp/tap_page.dart';
import 'package:userApp/Screens/Welcome/welcome_screen.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 토큰이 존재하는지 검사 (이 화면에서 로그인을 했는지 안 했는지 처리).
    return FutureBuilder(
      future: getToken(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData == false) {
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
        else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(fontSize: 15),
            ),
          );
        }
        else {
          return snapshot.data;
        }
      },
    );
  }

  Future<Widget> getToken() async {
    await Future.delayed(Duration(seconds: 2), () {});

    if(await FlutterSecureStorage().containsKey(key: 'token')){
      String jwt = await FlutterSecureStorage().read(key: 'token');

      if(JwtDecoder.isExpired(jwt)){
        FlutterSecureStorage().delete(key: 'token');
        return WelcomeScreen();
      } else {
        return TabPage();
      }
    } else {
      return WelcomeScreen();
    }
  }
}