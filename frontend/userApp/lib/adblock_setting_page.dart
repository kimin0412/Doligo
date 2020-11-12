import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:userApp/main.dart';

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
    return Padding(
      padding: const EdgeInsets.all(2),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: 900,
            child: ListView.builder(
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
                          Fluttertoast.showToast(
                              msg: '${_blockedAdList[position]['advertiser']['marketname']} 차단이 해제되었습니다.',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );

                          setState(() {
                            _blockedAdList.removeAt(position);
                          });
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
