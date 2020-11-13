import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:userApp/main.dart';

import 'leaflet_page.dart';

class AdblockSettingPage extends StatefulWidget {
  static const String routeName = '/adblockSetting';

  @override
  _AdblockSettingPageState createState() => _AdblockSettingPageState();
}

class _AdblockSettingPageState extends State<AdblockSettingPage> {

  var _blockedAdList = [];

  String _token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBlockedAdList();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('광고주 차단관리'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return _blockedAdList.length > 0 ? Padding(
      padding: const EdgeInsets.all(2),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Container(
            height: 900,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        print('$position 해제할거임?');
                        _token = _token == null ? await FlutterSecureStorage().read(key: 'token') : _token;
                        final response = await http.delete('${MyApp.commonUrl}/token/user/block/${_blockedAdList[position]['advertiser']['id']}',
                            headers: {
                              'Authorization' : 'Bearer $_token'
                            }
                        );

                        print('url : ${MyApp.commonUrl}/token/user/block/${_blockedAdList[position]['advertiser']['id']}');
                        print('code : ${response.statusCode}');
                        if(response.statusCode == 200) {
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.SCALE,
                            headerAnimationLoop: false,
                            dialogType: DialogType.SUCCES,
                            title: '차단해제 성공!',
                            desc: '${_blockedAdList[position]['advertiser']['marketname']} 차단이 해제되었습니다.',
                            btnOkIcon: Icons.check_circle,
                            btnOkOnPress: () {
                              debugPrint('OnClcik');
                            },
                          )..show().then((value) => setState(() {
                            _blockedAdList.removeAt(position);
                          }));
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                                  child: Text(
                                    _blockedAdList[position]['advertiser']['marketname'],
                                    style: TextStyle(
                                        fontSize: 20.0, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                                  child: Text(
                                    _blockedAdList[position]['advertiser']['marketaddress'],
                                    style: TextStyle(fontSize: 15.0),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Icon(
                              Icons.block,
                              size: 35.0,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 2.0,
                      color: Colors.grey,
                    )
                  ],
                );
              },
              itemCount: _blockedAdList.length,
            ),
          ),
        ),
      ),
    ) : Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('차단한 광고가 없습니다👀', style: TextStyle(fontSize: 30),),
                RaisedButton(
                  child: Text('😍차단하러 광고보러가기😍'),
                  onPressed: () {
                    // Navigator.popAndPushNamed(context, LeafletPage.routeName);
                    // Navigator.pushNamed(context, LeafletPage.routeName);
                    Navigator.pushReplacementNamed(context, LeafletPage.routeName);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void getBlockedAdList() async {
    _token = _token == null ? await FlutterSecureStorage().read(key: 'token') : _token;
    final response = await http.get('${MyApp.commonUrl}/token/user/block',
        headers: {
          'Authorization' : 'Bearer $_token'
        }
    );

    setState(() {
      _blockedAdList = jsonDecode(response.body)['data'];
      print('data : ${_blockedAdList}');
    });

  }
}
