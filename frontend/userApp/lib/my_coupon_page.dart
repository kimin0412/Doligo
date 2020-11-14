import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:userApp/leaflet_detail_page.dart';
import 'package:userApp/leaflet_page.dart';
import 'package:userApp/main.dart';

class MyCouponPage extends StatefulWidget {
  @override
  _MyCouponPageState createState() => _MyCouponPageState();
}

class _MyCouponPageState extends State<MyCouponPage> {
  int _couponCnt;

  // Global Key of Scaffold
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _token = null;

  bool initCheck;
  var _couponList = [];

  int result;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initCheck = true;
  }

  Future<String> _getToken() async => _token = await FlutterSecureStorage().read(key: 'token');

  @override
  Widget build(BuildContext context) {

    // inialize
    if(initCheck) {
      _getcouponList();
      initCheck = false;
    }

    // UI Build
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("쿠폰함",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _buildBody(),
    );
  }

  Future _getcouponList() async {
    _token = _token == null ? await FlutterSecureStorage().read(key: 'token') : _token;
    final response = await http.get('${MyApp.commonUrl}/token/user/coupon',
        headers: {
          'Authorization' : 'Bearer $_token'
        }
    );

    if(response.statusCode == 200) {
      setState(() {
        _couponList = json.decode(response.body)['data'];
        print('couponList : $_couponList');
      });
    }
  }

  _buildBody() {
    return _couponList.length > 0 ? Padding(
      padding: EdgeInsets.all(15.0),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              Container(
                width: 500,
                child: Text('보유쿠폰 : ${_couponList.length}장',
                  style: TextStyle(fontSize: 25, color: Color(0xFF8B6DFF)),
                  textAlign: TextAlign.left,
                ),
              ),  // 보유쿠폰 현황
              Center(
                child: Container(
                  height: 180.0 * _couponList.length,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: _couponList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, LeafletDetailPage.routeName, arguments: _couponList[index]['pid']);
                        },
                        child: SizedBox(
                          width: 10,
                          height: 180,
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 16, left: 20, bottom: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        child: AutoSizeText(_couponList[index]['paper']['p_coupon'],
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff7C4CFF),
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.left,
                                          maxLines: 1,
                                        ),
                                        width: 200,
                                      ),  // 메인혜택내용
                                      SizedBox(height: 25,),
                                      Container(
                                        width: 200,
                                        child: AutoSizeText(_couponList[index]['paper']['advertiser']['marketname'],
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.left,
                                          maxLines: 1,
                                        ),
                                      ),  // 가게이름
                                      Container(
                                        width: 200,
                                        child: Text(_couponList[index]['paper']['condition1'] == null ? '' : _couponList[index]['paper']['condition1'],
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xffEA9836),
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),  // 내용1
                                      Container(
                                        width: 200,
                                        alignment: Alignment.bottomLeft,
                                        child: Text((_couponList[index]['paper']['condition2'] == null ? '' : _couponList[index]['paper']['condition2']) + '\n사용기간 ' + calExpiredDate(index),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xffA1A1A1),
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),  // 내용2 및 사용기간
                                    ],
                                  ),  // 쿠폰 내용
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: ButtonTheme(
                                      minWidth: 70,
                                      height: 70,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                                        child: Text(isExpired(index) ? '기간\n만료': '쿠폰\n쓰기',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        onPressed: isExpired(index) ? null : () {
                                          AwesomeDialog(
                                            context: context,
                                            animType: AnimType.SCALE,
                                            headerAnimationLoop: false,
                                            dialogType: DialogType.INFO,
                                            title: '쿠폰 사용',
                                            desc: '쿠폰을 사용하시겠어요?',
                                            btnCancelOnPress: () {
                                              result = 400;
                                            },
                                            btnOkOnPress: () {
                                              debugPrint('OnClcik');
                                              result = 200;
                                            },
                                          )..show().then((value) async {
                                            // print('result~~~ : $result');
                                            if(result == 200 && await _useCoupon(index, context) == 200) {
                                              // print('둘다 200');
                                              scaffoldKey.currentState
                                                ..hideCurrentSnackBar()
                                                ..showSnackBar(
                                                  SnackBar(
                                                    content: Text("쿠폰을 사용하였습니다!"),
                                                    backgroundColor: Color(0xff7C4CFF),
                                                    action: SnackBarAction(
                                                      label: "Done",
                                                      textColor: Colors.white,
                                                      onPressed: () {},
                                                    ),
                                                  ),
                                                );
                                            }
                                          });
                                          // showAlertDialog(context, index);// 쓸건지 한번 물어보는 창으로 연결
                                          //
                                        },
                                        color: Color(0xff7C4CFF),
                                        textColor: Colors.white,
                                        disabledColor: Color(0xff9C9C9C),
                                        disabledTextColor: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),  // 쿠폰 사용 버튼
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),  // 쿠폰 ListView
            ],
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
                Text('😂쿠폰이 없습니다😂', style: TextStyle(fontSize: 30),),
                RaisedButton(
                  child: Text('쿠폰받으러 가기'),
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

  bool isExpired(int index) {
    final endDate = DateFormat('yyyy-MM-dd').parse('${_couponList[index]['created']}'.substring(0, 10)).add(new Duration(days: 30));

    print('end : ${endDate.toString()}');
    print('now : ${DateTime.now().toString()}');

    if(endDate.compareTo(DateTime.now()) < 0) {
      return true;
    }
    return false;

  }

  String calExpiredDate(int index) {
    final startDate = DateFormat('yyyy-MM-dd').parse('${_couponList[index]['created']}'.substring(0, 10));
    final endDate = startDate.add(new Duration(days: 30));

    print('start : ${startDate.toString()}');
    print('end : ${endDate.toString()}');

    return '${startDate.toString().replaceAll('-', '.').substring(0,10)} - ${endDate.toString().replaceAll('-', '.').substring(0,10)}';
  }

  void showAlertDialog(BuildContext context, int index) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('쿠폰 사용'),
          content: Text("쿠폰을 사용하시겠습니까?"),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                _useCoupon(index, context);
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, "Cancel");
              },
            ),
          ],
        );
      },
    );


  }

  Future<int> _useCoupon(int index, BuildContext context) async {
    _token = _token == null ? await FlutterSecureStorage().read(key: 'token') : _token;
    final response = await http.delete('${MyApp.commonUrl}/token/user/coupon/${_couponList[index]['id']}',
        headers: {
          'Authorization' : 'Bearer $_token'
        }
    );
    print('쿠폰 사용 결과 : ${response.statusCode}');
    if(response.statusCode == 200) {
      setState(() {
        _couponList.removeAt(index);
      });
    }

    return response.statusCode;
  }
}
