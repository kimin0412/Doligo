import 'dart:async';
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
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
  var _pointInfo = [];
  int pointCnt = 0;
  double co2Cnt = 0.0;

  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String _profileImageURL = null;

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
    return _userInfo == null ? Container() : Container(
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
                                onTap: null,
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                  height: 100,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(5),
                                  child: ListTile(
                                    leading: SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child: CircleAvatar(
                                          radius: 70,
                                          child: ClipOval(
                                            child: _profileImageURL == null ?
                                            Image.network(
                                              'https://i.pinimg.com/474x/7d/56/56/7d5656879b5d6ed45779f89c4e89c91a.jpg', height: 150,
                                              width: 150,
                                              fit: BoxFit.cover,
                                            ) :
                                            Image.network(
                                              _profileImageURL, height: 150,
                                              width: 150,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                    ),
                                    title: Text('${_userInfo['nickname']}님 어서오세요!',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                    subtitle:
                                        Row(
                                            children: <Widget>[
                                              // FlutterLogo(),
                                              Text('현재까지 ${co2Cnt.toStringAsFixed(3)}g의 CO2를 흡수했습니당', style: TextStyle(fontSize: 14),),
                                              // Icon(Icons.sentiment_very_satisfied),
                                              SvgPicture.asset(
                                                "assets/icons/sprout_1.svg",
                                                height: 25,
                                                alignment: Alignment.centerLeft,
                                              ),
                                            ]
                                        )
                                      // SizedBox(
                                      //   width: 100.0,
                                      //   height: 30.0,
                                      //   childre
                                      //   child: SvgPicture.asset(
                                      //     "assets/icons/pay_point.svg",
                                      //     height: 30,
                                      //     alignment: Alignment.centerLeft,
                                      //   ),
                                      // ),

                                    // Text('브론즈?',
                                    //     style: TextStyle(color: Colors.black)),
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
                            child: InkWell(
                                onTap: () =>{
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => PointHistoryPage()),
                                  ).then(refreshPage)
                                },
                              child: Column(
                                children: <Widget>[
                                  Padding(padding: EdgeInsets.all(8.0)),
                                  ListTile(
                                    title: Text(
                                        '내 적립포인트',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                    ),
                                    subtitle: Text('${_userInfo['point']} Point',
                                      style: TextStyle(color: Colors.black, fontSize: 30),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(8.0)),
                                ],
                              ),
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
                                ).then(refreshPage)
                              },
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        title: Text('포인트 바로 받기 >',
                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                        subtitle: Text('원하는 전단지만 보고 바로 적립',
                                            style: TextStyle(color: Colors.black)),
                                        trailing: Wrap(
                                          spacing: 12,
                                          children: <Widget>[
                                            SizedBox(
                                              width: 50.0,
                                              height: 50.0,
                                              child: SvgPicture.asset(
                                                "assets/icons/pay_point.svg",
                                                height: 50,
                                              ),
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
                                ).then(refreshPage)
                              },
                              child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text('내 쿠폰 확인하기 >',
                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                      subtitle: Text('전단지에서 받은 쿠폰 모두 확인',
                                          style: TextStyle(color: Colors.black)),
                                      trailing: Wrap(
                                        spacing: 12,
                                        children: <Widget>[
                                          SizedBox(
                                              width: 50.0,
                                              height: 50.0,
                                              child: SvgPicture.asset(
                                                "assets/icons/coupon.svg",
                                                height: 50,
                                              ),
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
                                    ).then(refreshPage)
                                  },
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            title: Text('쇼핑하기 >',
                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                            subtitle: Text('모았으면 쓰자! 포인트로 쇼핑타임',
                                                style: TextStyle(color: Colors.black)),
                                            trailing: Wrap(
                                              spacing: 12,
                                              children: <Widget>[
                                                SizedBox(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    child: SvgPicture.asset(
                                                      "assets/icons/shopping-bag.svg",
                                                      height: 50,
                                                    ),
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
    print('token : $_token');
    final response = await http.get('${MyApp.commonUrl}/token/user',
        headers: {
          'Authorization' : 'Bearer $_token'
        }
    );

    setState(() {
      _userInfo = json.decode(response.body)['data'];
      print('userInfo : $_userInfo');
    });

    _getProfileImage();
  }

  void _getPointInfo() async {
    String _token = await FlutterSecureStorage().read(key: 'token');
    print('token : $_token');
    final response = await http.get('${MyApp.commonUrl}/token/user/point/0',
        headers: {
          'Authorization': 'Bearer $_token'
        }
    );

    setState(() {
      _pointInfo = json.decode(response.body)['data'];
      pointCnt = _pointInfo.length;
      co2Cnt = pointCnt * 0.66;
      // print('pointInfo : $_pointInfo');
    });

  }



  FutureOr refreshPage(Object value) {
    _getUserInfo();
  }

  Future<String> _getProfileImage() async {
    StorageReference storageReference = _firebaseStorage.ref().child("profile/${_userInfo['id']}");

    try {
      String _src = await storageReference.getDownloadURL();

      setState(() {
        _profileImageURL = _src;
      });
      return _src;
    } on Exception catch (e) {
      // TODO
      print('에러가 났어요.');
      return null;
    }

  }
}

