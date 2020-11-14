import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:userApp/Screens/Login/login_screen.dart';
import 'package:userApp/Screens/Welcome/welcome_screen.dart';
import 'package:userApp/adblock_setting_page.dart';
import 'package:userApp/leaflet_detail_page.dart';
import 'package:userApp/private_info_setting_page.dart';
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ ListTile(
              title: Text(
                  'dd',
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
            ),]
          )

        ],
      ),
    );
  }
}

class Constants {
  static const String notifySet = '알림 설정';
  static const String privateInfoSet = '내 정보 설정';
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
        if(_name == Constants.notifySet) {
          Fluttertoast.showToast(
              msg: '준비중입니다^^',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
        else if(_name == Constants.privateInfoSet) {
          Navigator.pushNamed(context, PrivateInfoSettingPage.routeName);
        }
        else if(_name == Constants.adBlockSet) {
          Navigator.pushNamed(context, AdblockSettingPage.routeName);
        }
        else if(_name == Constants.logout) {
          FlutterSecureStorage().delete(key: 'token');    // token 삭제

          AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            headerAnimationLoop: false,
            dialogType: DialogType.SUCCES,
            title: '다음에 또 와요!',
            desc: '로그아웃 되었습니다',
            btnOkIcon: Icons.check_circle,
            btnOkOnPress: () {
              debugPrint('OnClcik');
            },
          )..show().then((value) => Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) => WelcomeScreen()), (route) => false
          ));
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