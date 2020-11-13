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

import 'package:flutter/cupertino.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var _userInfo;
  var _pointInfo = [];
  int myTree = 0;
  int pointCnt = 0;
  double co2Cnt = 0.0;
  var trees = [
    "assets/icons/tree/tree_1.svg",
    "assets/icons/tree/tree_2.svg",
    "assets/icons/tree/tree_3.svg",
    "assets/icons/tree/tree_4.svg",
    "assets/icons/tree/tree_5.svg",
    "assets/icons/tree/tree_love.svg"
  ];
  int myPoint = 0;

  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String _profileImageURL = null;

  var _point = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    refreshPage(0);
    // _getUserInfo();
    // _getPointInfo();
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

  Widget _buildBody() {
    return _userInfo == null
        ? Container()
        : Container(
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
                                          child: _profileImageURL == null
                                              ? Image.network(
                                            'https://i.pinimg.com/474x/7d/56/56/7d5656879b5d6ed45779f89c4e89c91a.jpg',
                                            height: 150,
                                            width: 150,
                                            fit: BoxFit.cover,
                                          )
                                              : Image.network(
                                            _profileImageURL,
                                            height: 150,
                                            width: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text('${_userInfo['nickname']}님 어서오세요!',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              )), // 회원 정보 Card
                          Padding(padding: EdgeInsets.all(8.0)),
                          Card(
                            margin: EdgeInsets.all(5),
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: InkWell(
                              onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PointHistoryPage()),
                                ).then(refreshPage)
                              },
                              child: Column(
                                children: <Widget>[
                                  Padding(padding: EdgeInsets.all(8.0)),
                                  ListTile(
                                    title: Text('내 적립포인트',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        AnimatedFlipCounter(
                                          duration: Duration(milliseconds: 1000),
                                          value: _point, /* pass in a number like 2014 */
                                          color: Colors.black,
                                          size: 50,
                                        ),
                                        SizedBox(width: 10,),
                                        Text('point', style: TextStyle(fontSize: 25),),
                                      ],
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(8.0)),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          "assets/icons/leaflet.svg",
                                          height: 100,
                                          alignment: Alignment.centerLeft,
                                        ),
                                        SizedBox(width: 20.0),
                                        SvgPicture.asset(
                                          "assets/icons/arrow.svg",
                                          height: 60,
                                          alignment: Alignment.centerLeft,
                                        ),
                                        SizedBox(width: 20.0),
                                        SvgPicture.asset(
                                          trees[myTree],
                                          height: 100,
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ]),
                                  Padding(padding: EdgeInsets.all(8.0)),
                                  ListTile(
                                      title: Row(children: <Widget>[
                                        Text(
                                          '* 현재까지 ',
                                          style: TextStyle(
                                              fontSize: 20, color: Colors.black),
                                        ),
                                      ]),
                                      subtitle: Row(children: [
                                        Text(
                                          ' ${co2Cnt.toStringAsFixed(3)}g',
                                          style: TextStyle(
                                              fontSize: 25, color: Colors.black),
                                        ),
                                        Text(
                                          '의 CO2를 흡수했습니다 ',
                                          style: TextStyle(
                                              fontSize: 20, color: Colors.black),
                                        ),
                                        SvgPicture.asset(
                                          "assets/icons/sprout_1.svg",
                                          height: 25,
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ])),
                                  Padding(padding: EdgeInsets.all(20.0)),
                                  // Padding(padding: EdgeInsets.all(8.0)),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(width: 10.0),
                                        Text(
                                          '등급 순서 : ',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        SvgPicture.asset(
                                          trees[0],
                                          height: 25,
                                          alignment: Alignment.centerLeft,
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          '->',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        SizedBox(width: 5.0),
                                        SvgPicture.asset(
                                          trees[1],
                                          height: 25,
                                          alignment: Alignment.centerLeft,
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          '->',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        SizedBox(width: 5.0),
                                        SvgPicture.asset(
                                          trees[2],
                                          height: 25,
                                          alignment: Alignment.centerLeft,
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          '->',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        SizedBox(width: 5.0),
                                        SvgPicture.asset(
                                          trees[3],
                                          height: 25,
                                          alignment: Alignment.centerLeft,
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          '->',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        SizedBox(width: 5.0),
                                        SvgPicture.asset(
                                          trees[4],
                                          height: 25,
                                          alignment: Alignment.centerLeft,
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          '->',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        SizedBox(width: 5.0),
                                        SvgPicture.asset(
                                          trees[5],
                                          height: 25,
                                          alignment: Alignment.centerLeft,
                                        ),
                                        SizedBox(width: 5.0),
                                      ]),
                                  Padding(padding: EdgeInsets.all(8.0)),
                                ],
                              ),
                            ),
                          ), // 오늘의 잔여 횟수 및 & 적립포인트 Card
                          Padding(padding: EdgeInsets.all(8.0)),
                          Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: InkWell(
                              onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LeafletPage()),
                                ).then(refreshPage)
                              },
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                child: Column(children: <Widget>[
                                  ListTile(
                                    title: Text('포인트 바로 받기 >',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
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
                                ]),
                              ),
                            ),
                          ), // 포인트 바로 받기 Card
                          Padding(padding: EdgeInsets.all(8.0)),
                          Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: InkWell(
                              onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyCouponPage()),
                                ).then(refreshPage)
                              },
                              child: Column(children: <Widget>[
                                ListTile(
                                  title: Text('내 쿠폰 확인하기 >',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
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
                              ]),
                            ),
                          ), // 내 쿠폰 확인하기 Card
                          Padding(padding: EdgeInsets.all(8.0)),
                          Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: InkWell(
                                  onTap: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MarketPage()),
                                    ).then(refreshPage)
                                  },
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    child: Column(children: <Widget>[
                                      ListTile(
                                        title: Text('쇼핑하기 >',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
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
                                    ]),
                                  ))), // 쇼핑하기 Card
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

      myPoint = _userInfo['point'];
      print('point : ${_userInfo['point']}');

      if (myPoint < 1000) {
        myTree = 0;
      } else if (myPoint >= 1000 && myPoint < 5000) {
        myTree = 1;
      } else if (myPoint >= 5000 && myPoint < 10000) {
        myTree = 2;
      } else if (myPoint >= 10000 && myPoint < 20000) {
        myTree = 3;
      } else if (myPoint >= 20000 && myPoint < 50000) {
        myTree = 4;
      } else {
        myTree = 5;
      }
    });

    countDownTime();

    _getProfileImage();
  }

  void _getPointInfo() async {
    String _token = await FlutterSecureStorage().read(key: 'token');
    print('token : $_token');
    final response = await http.get('${MyApp.commonUrl}/token/user/point/0',
        headers: {'Authorization': 'Bearer $_token'});

    setState(() {
      _pointInfo = json.decode(response.body)['data'];
      pointCnt = _pointInfo.length;
      co2Cnt = pointCnt * 0.66;
      // print('pointInfo : $_pointInfo');
      // print('pointInfo : $_pointInfo');
    });
  }

  FutureOr refreshPage(Object value) {
    _getUserInfo();
    _getPointInfo();
  }

  countDownTime() async {
    return Timer(
      Duration(milliseconds: 500),
          () async {
        setState(() {
          _point = _userInfo['point'];
        });
      },
    );
  }

  Future<String> _getProfileImage() async {
    StorageReference storageReference =
    _firebaseStorage.ref().child("profile/${_userInfo['id']}");

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

class AnimatedFlipCounter extends StatelessWidget {
  final int value;
  final Duration duration;
  final double size;
  final Color color;

  const AnimatedFlipCounter({
    Key key,
    @required this.value,
    @required this.duration,
    this.size = 72,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<int> digits = value == 0 ? [0] : [];

    int v = value;
    if (v < 0) {
      v *= -1;
    }
    while (v > 0) {
      digits.add(v);
      v = v ~/ 10;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(digits.length, (int i) {
        return _SingleDigitFlipCounter(
          key: ValueKey(digits.length - i),
          value: digits[digits.length - i - 1].toDouble(),
          duration: duration,
          height: size,
          width: size / 1.8,
          color: color,
        );
      }),
    );
  }
}

class _SingleDigitFlipCounter extends StatelessWidget {
  final double value;
  final Duration duration;
  final double height;
  final double width;
  final Color color;

  const _SingleDigitFlipCounter({
    Key key,
    @required this.value,
    @required this.duration,
    @required this.height,
    @required this.width,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: value),
      duration: duration,
      builder: (context, value, child) {
        final whole = value ~/ 1;
        final decimal = value - whole;
        return SizedBox(
          height: height,
          width: width,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _buildSingleDigit(
                digit: whole % 10,
                offset: height * decimal,
                opacity: 1 - decimal,
              ),
              _buildSingleDigit(
                digit: (whole + 1) % 10,
                offset: height * decimal - height,
                opacity: decimal,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSingleDigit({int digit, double offset, double opacity}) {
    return Positioned(
      child: SizedBox(
        width: width,
        child: Opacity(
          opacity: opacity,
          child: Text(
            "$digit",
            style: TextStyle(fontSize: height, color: color),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      bottom: offset,
    );
  }
}