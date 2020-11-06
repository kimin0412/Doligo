import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:userApp/Screens/Login/login_screen.dart';
import 'package:userApp/Screens/Welcome/welcome_screen.dart';
import 'package:userApp/leaflet_detail_page.dart';
import 'package:userApp/tap_page.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("설정",
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
          SettingTile(Constants.notifySet, Icons.add_alert),
          SettingTile(Constants.privateInfoSet, Icons.person),
          SettingTile(Constants.adBlockSet, Icons.block),
          SettingTile(Constants.logout, Icons.logout),
        ],
      ),
    );
  }
}

class Constants {
  static const String notifySet = '알림 설정';
  static const String privateInfoSet = '개인정보 설정';
  static const String adBlockSet = '광고주 차단관리 설정';
  static const String logout = '로그아웃';

}

class SettingTile extends StatelessWidget {
  SettingTile(this._name, this._icon);

  final String _name;
  final IconData _icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if(_name == Constants.logout) {
          FlutterSecureStorage().delete(key: 'token');    // token 삭제
          Fluttertoast.showToast(
              msg: '로그아웃이 되었습니다',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0
          );
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) => WelcomeScreen()), (route) => false
          );
        }
        else if(_name == Constants.adBlockSet) {
          // Navigator.pushNamed(context, routeName);
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