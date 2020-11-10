import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class MarketPage extends StatefulWidget {
  @override
  _MarketPage createState() => _MarketPage();
}

class _MarketPage extends State<MarketPage> {
  var _userInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 로그인한 유저의 정보를 가져와 환영 문구와 적립 포인트 들을 초기화 한다.
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
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
    return _userInfo == null
        ? Container()
        : Container(
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: SafeArea(
                  child: SingleChildScrollView(
                      child: Center(
                          child: Column(
                    children: <Widget>[
                      Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: InkWell(
                            onTap: () => {
                              // Navigator.push(
                              // context,
                              // MaterialPageRoute(builder: (context) => PointHistoryPage()),
                              // ).then(refreshPage)
                            },
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                              height: 100,
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(5),
                              child: ListTile(
                                leading: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: Icon(Icons.account_circle,
                                        color: Colors.black, size: 50.0)),
                                title: Text('${_userInfo['nickname']}님 어서오세요!',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text('브론즈?',
                                    style: TextStyle(color: Colors.black)),
                                trailing: Wrap(
                                  spacing: 12,
                                  children: <Widget>[
                                    SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child: Icon(Icons.account_circle,
                                            color: Colors.black, size: 50.0)),
                                    title: Text('${_userInfo['nickname']}님 어서오세요!',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text('브론즈?',
                                        style: TextStyle(color: Colors.black)),
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
                                ),
                              )), // 회원 정보 Card
                          Padding(padding: EdgeInsets.all(8.0)),
                          // ListView(
                          //     scrollDirection: Axis.vertical,
                          //     shrinkWrap: true,
                          //     children: <Widget>[
                          //       new GridView.count(
                          //         scrollDirection: Axis.horizontal,
                          //         //스크롤 방향 조절
                          //         crossAxisSpacing: 10,
                          //         mainAxisSpacing: 10,
                          //         crossAxisCount: 6,
                          //         //로우 혹은 컬럼수 조절 (필수값)
                          //         children: List.generate(100, (index) {
                          //           return Container(
                          //             child: Text("Item $index",
                          //                 style: Theme.of(context).textTheme.body1),
                          //             color: Colors.green,
                          //           );
                          //         }),
                          //       ),
                          //     ]),
                        ],
                      ))),
            )));
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

  FutureOr refreshPage(Object value) {
    _getUserInfo();
  }
}
