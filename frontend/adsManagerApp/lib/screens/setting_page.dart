import 'package:dolligo_ads_manager/constants.dart';
import 'package:dolligo_ads_manager/screens/revise_advertiser_page.dart';
import 'package:dolligo_ads_manager/screens/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SettingPage extends StatefulWidget {
  @override
  _SettingPage createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage> {
  BuildContext _context;
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("돌리Go!",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody(){
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
          // SettingTile('결제 내역', Icons.add_alert, logout),
          SettingTile('점포 관리', Icons.person,
              () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ReviseAdvPage();
                  },
                ),
              );
            },
          ),
          SettingTile('로그아웃', Icons.star,
              logout
              // (){
              //   FlutterSecureStorage().delete(key: 'jwt');
              //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              //     builder: (context) {
              //       return WelcomeScreen();
              //     },
              //   ), (r) => false);
              // }
          ),
        ],
      ),
    );
  }

  void logout() async {
    var jwt = await FlutterSecureStorage().read(key: 'jwt');
    await http.get('$SERVER_IP/api/token/advertiser/logout',
        headers: {'Authorization': 'Bearer $jwt'}
    );

    FlutterSecureStorage().delete(key: 'jwt');
    Navigator.pushAndRemoveUntil(_context, MaterialPageRoute(
      builder: (context) {
        return WelcomeScreen();
      },
    ), (r) => false);
  }
}



class SettingTile extends StatelessWidget {
  SettingTile(this._name, this._icon, this._onTap);

  final String _name;
  final IconData _icon;
  final _onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
      onTap: _onTap,
    );
  }
}