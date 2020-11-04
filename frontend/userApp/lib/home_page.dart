import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:userApp/leaflet_page.dart';
import 'package:userApp/main.dart';
import 'package:userApp/market_page.dart';
import 'package:userApp/my_coupon_page.dart';
import 'package:userApp/point_history_page.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

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
        title: Text("돌리Go!",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _buildBody(),
    );
  }


  Widget _buildBody(){
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
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
                                onTap: () =>{
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => PointHistoryPage()),
                                  )
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
                                            color: Colors.lightBlue,
                                            size: 50.0)
                                    ),
                                    title: Text('김민지님 어서오세요!',
                                        style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold)),
                                    subtitle: Text('브론즈?',
                                        style: TextStyle(color: Colors.lightBlue)),
                                    trailing: Wrap(
                                      spacing: 12,
                                      children: <Widget>[
                                        SizedBox(
                                            width: 50.0,
                                            height: 50.0,
                                            child: Icon(Icons.swap_vert_circle,
                                                color: Colors.lightBlue,
                                                size: 50.0)
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                          ),  // 회원 정보 Card
                          Padding(padding: EdgeInsets.all(8.0)),
                          Card(
                            margin: EdgeInsets.all(5),
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.all(8.0)),
                                ListTile(
                                  title: Text(
                                      '오늘의 잔여 횟수',
                                      style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold)
                                  ),
                                  subtitle: Text('2/10회',
                                    style: TextStyle(color: Colors.lightBlue, fontSize: 30),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                      '내 적립포인트',
                                      style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold)
                                  ),
                                  subtitle: Text('${_userInfo['point']} Point',
                                    style: TextStyle(color: Colors.lightBlue, fontSize: 30),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(8.0)),
                              ],
                            ),
                          ),  // 오늘의 잔여 횟수 및 & 적립포인트 Card
                          Padding(padding: EdgeInsets.all(8.0)),
                          Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: InkWell(
                              onTap: () =>{
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LeafletPage()),
                                )
                              },
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        title: Text('포인트 바로 받기 >',
                                            style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold)),
                                        subtitle: Text('원하는 전단지만 보고 바로 적립',
                                            style: TextStyle(color: Colors.lightBlue)),
                                        trailing: Wrap(
                                          spacing: 12,
                                          children: <Widget>[
                                            SizedBox(
                                                width: 50.0,
                                                height: 50.0,
                                                child: Icon(Icons.swap_vert_circle,
                                                    color: Colors.lightBlue,
                                                    size: 50.0)
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                            ),
                          ),  // 포인트 바로 받기 Card
                          Padding(padding: EdgeInsets.all(8.0)),
                          Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: InkWell(
                              onTap: () =>{
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MyCouponPage()),
                                )
                              },
                              child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text('내 쿠폰 확인하기 >',
                                          style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold)),
                                      trailing: Wrap(
                                        spacing: 12,
                                        children: <Widget>[
                                          SizedBox(
                                              width: 50.0,
                                              height: 50.0,
                                              child: Icon(Icons.swap_vert_circle,
                                                  color: Colors.lightBlue,
                                                  size: 50.0)
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ),  // 내 쿠폰 확인하기 Card
                          Padding(padding: EdgeInsets.all(8.0)),
                          Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: InkWell(
                                  onTap: () =>{
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MarketPage()),
                                    )
                                  },
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            title: Text('쇼핑하기 >',
                                                style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold)),
                                            trailing: Wrap(
                                              spacing: 12,
                                              children: <Widget>[
                                                SizedBox(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    child: Icon(Icons.swap_vert_circle,
                                                        color: Colors.lightBlue,
                                                        size: 50.0)
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]
                                    ),
                                  )
                              )
                          ),  // 쇼핑하기 Card
                        ],
                      )
                  )
              ),)
        )
    );
  }

  void _getUserInfo() async {
    String _token = await FlutterSecureStorage().read(key: 'token');
    final response = await http.get(MyApp.commonUrl + 'token/user',
      headers: {
        'Authorization' : 'Bearer $_token'
      }
    );

    setState(() {
      _userInfo = json.decode(response.body)['data'];
      print('userInfo : $_userInfo');
    });

  }



}

