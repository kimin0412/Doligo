import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:userApp/constants.dart';

import '../main.dart';

class Item {
  Item({this.title, this.icon, this.isSelected});

  String title;
  String icon;
  bool isSelected;
}

class MarketPage0 extends StatefulWidget {
  @override
  _MarketPage0 createState() => _MarketPage0();
}

class _MarketPage0 extends State<MarketPage0> {
  var _userInfo;
  var itemList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 로그인한 유저의 정보를 가져와 환영 문구와 적립 포인트 들을 초기화 한다.
    _getUserInfo();
    itemList = [];
    _getGiftInfo();
    // itemList
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("모바일 전단지",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return _userInfo == null
        ? Container()
        : Container(
            child: Padding(
            padding: EdgeInsets.all(15.0),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Container(
                          height: 80,
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(5),
                          child: ListTile(
                            leading: SizedBox(
                                width: 50.0,
                                height: 50.0,
                                child: Icon(Icons.account_circle,
                                    color: Colors.black87, size: 50.0)),
                            title: Text('${_userInfo['nickname']}님의 적립 포인트',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text('${_userInfo['point']} Point',
                                style: TextStyle(color: Colors.black87)),
                            trailing: Wrap(
                              spacing: 12,
                              children: <Widget>[
                                SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: Icon(Icons.card_giftcard,
                                        color: Colors.black54, size: 50.0)),
                              ],
                            ),
                          ),
                        )),
                    Padding(padding: EdgeInsets.all(8.0)),
                    Center(
                        child: Container(
                            height: 500,
                            width: 350,
                            alignment: Alignment.center,
                            child: GridView.count(
                              crossAxisCount: 1,
                              children: List.generate(itemList.length, (index) {
                                return Center(
                                    child: Card(
                                  color: Colors.white,
                                  elevation: 10.0,
                                  child: InkWell(
                                      splashColor: kPrimaryColor,
                                      onTap: () => {},
                                      child: Center(
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ListTile(
                                                  leading: SizedBox(
                                                      width: 50.0,
                                                      height: 50.0,
                                                      child: itemList[index]
                                                                  ['image'] ==
                                                              null
                                                          ? Image.network(
                                                              'https://plog-image.s3.ap-northeast-2.amazonaws.com/q.png',
                                                              fit: BoxFit.cover,
                                                              height: 80)
                                                          : Image.network(
                                                              itemList[index]
                                                                  ['image'],
                                                              fit: BoxFit.cover,
                                                              height: 80)),
                                                  title: Text(
                                                      itemList[index]['name'],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  subtitle:
                                                      Row(children: <Widget>[
                                                    Text(
                                                      itemList[index]['price']
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  ])),
                                            ]),
                                      )),
                                ));
                              }),
                            ))),
                  ],
                ),
              ),
            ),
          ));
  }

  void _getUserInfo() async {
    String _token = await FlutterSecureStorage().read(key: 'token');
    print('token : $_token');
    final response = await http.get('${MyApp.commonUrl}/token/user',
        headers: {'Authorization': 'Bearer $_token'});

    setState(() {
      _userInfo = json.decode(response.body)['data'];
      print('userInfo : $_userInfo');
    });
  }

  void _getGiftInfo() async {
    String _token = await FlutterSecureStorage().read(key: 'token');
    print('token : $_token');
    final response = await http.get('${MyApp.commonUrl}/token/gifticon',
        headers: {'Authorization': 'Bearer $_token'});

    setState(() {
      itemList = json.decode(response.body)['data'];
      print('itemList : $itemList');
    });
  }

  FutureOr refreshPage(Object value) {
    _getUserInfo();
    _getGiftInfo();
  }
}
