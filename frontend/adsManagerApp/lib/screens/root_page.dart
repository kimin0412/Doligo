import 'package:dolligo_ads_manager/screens/tap_page.dart';
import 'package:dolligo_ads_manager/screens/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    //이 화면에서 로그인을 했는지 안 했는지 처리.
    return FutureBuilder(
        future: _fetch(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
          if (snapshot.hasData == false) {
            //뱅글뱅글
            return CircularProgressIndicator();
          }
          //error가 발생하게 될 경우 반환하게 되는 부분
          else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 15),
              ),
            );
          }
          // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
          else {
            return snapshot.data;
          }
        });
  }

  Future<Widget> _fetch() async {
    if(await FlutterSecureStorage().containsKey(key: 'jwt')){
      String jwt = await FlutterSecureStorage().read(key: 'jwt');

      if(JwtDecoder.isExpired(jwt)){
        FlutterSecureStorage().delete(key: 'jwt');
        return WelcomeScreen();
      } else {
        return TabPage();
      }
    } else {
      return WelcomeScreen();
    }
  }
}