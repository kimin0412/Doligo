import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:userApp/Screens/Login/login_screen.dart';
import 'package:userApp/Screens/Welcome/welcome_screen.dart';
import 'package:userApp/tap_page.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("돌리Go!",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.all(8.0)),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.all(10),
              child: Text(
                '설정',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
            ),
          ),
          SettingTile('알림 설정', Icons.add_alert),
          SettingTile('개인정보 설정', Icons.person),
          SettingTile('선호지역 관리', Icons.star),
          SettingTile('로그아웃', Icons.logout),
        ],
      ),
    );
  }
}


class SettingTile extends StatelessWidget {
  SettingTile(this._name, this._icon);

  final String _name;
  final IconData _icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if(_name == '로그아웃') {
          FlutterSecureStorage().delete(key: 'token');    // token 삭제
          Fluttertoast.showToast(
              msg: '로그아웃이 되었습니다',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0
          );
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) => WelcomeScreen()), (route) => false
          );
        }
      },
      leading: SizedBox(
          child: Icon(_icon,
              color: Colors.deepPurpleAccent,
              size: 30.0)
      ),
      title: Text(
          _name,
          style: TextStyle(fontWeight: FontWeight.bold)
      ),
      trailing: Wrap(
        spacing: 12,
        children: <Widget>[
          SizedBox(
              child: Icon(Icons.chevron_right,
                  color: Colors.deepPurpleAccent,
                  size: 30.0)
          ),
        ],
      ),
    );
  }
}