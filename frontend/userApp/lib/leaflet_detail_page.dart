import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:userApp/leaflet_page.dart';
import 'package:userApp/main.dart';

class Constants {
  static const String delete = '전단지 차단';        // 삭제
  static const String noSubscribe = '광고주 차단';   // 차단

  static const List<String> choices = <String>[
    delete,
    noSubscribe
  ];
}

class LeafletDetailPage extends StatefulWidget {
  static const routeName = '/leafFletDetail';

  @override
  _LeafletDetailPageState createState() => _LeafletDetailPageState();
}

class _LeafletDetailPageState extends State<LeafletDetailPage> {
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = Set();
  bool initCheck;
  bool _isCouponButtonDisable;
  bool _isPointButtonDisable;

  int args = -1;

  String _token = null;

  var _detailLeaflet = null;

  var _userInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initCheck = true;
    _isCouponButtonDisable = false;
    _isPointButtonDisable = false;
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {

    args = ModalRoute.of(context).settings.arguments;
    print('args : $args');

    if(initCheck) {
      _getDetailLeaflet(args);
    }

    return _detailLeaflet == null ? Scaffold() : Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(_detailLeaflet['advertiser']['marketname']),
        actions: [
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            icon: Icon(Icons.notifications),
          )
        ],
      ),
      body: _buildBody(_detailLeaflet),
    );
  }

  void choiceAction(String choice) async {
    switch(choice) {
      case Constants.delete:
        print('$choice WORKING');
        await dislike(choice);
        break;
      case Constants.noSubscribe:
        print('$choice WORKING');
        await dislike(choice);
        break;
    }
  }

  Future dislike(String choice) async {
    int _state = choice == '전단지 차단' ? 1 : 4;
    String _toastMessage = choice == '전단지 차단' ? '해당 전단지를 차단하였습니다.' : '해당 광고주를 차단하였습니다.';
    final response = await http.post('${MyApp.commonUrl}/token/user/state',
      body: jsonEncode({
        "age": _userInfo['age'],
        "gender": _userInfo['gender'],
        "pid": _detailLeaflet['p_id'],
        "state": _state,
        "uid": _userInfo['id'],
      }),
      headers: {
        'Authorization' : 'Bearer $_token',
        'Content-Type' : 'application/json'
      },
    );


    print('차단 결과 : ${response.statusCode}');

    if(response.statusCode == 200) {
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        title: '차단 성공!',
        desc: _toastMessage,
        btnOkIcon: Icons.check_circle,
        btnOkOnPress: () {
          debugPrint('OnClcik');
        },
      )..show().then((value) => Navigator.pop(context));
    }

  }

  _buildBody(var _detailLeaflet) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top : 20, left: 20, right: 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: [
                          Container(
                            width: 350,
                            child: Text('전단지',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            padding: EdgeInsets.only(bottom: 2),
                          ),
                          SizedBox(
                            child: Card(
                              elevation: 4,
                              child: Image.network(_detailLeaflet['p_image']),
                            ),
                          ),
                        ],
                      ),
                    ),  // 전단지 Area
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            width: 350,
                            child: Text('위치',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            padding: EdgeInsets.only(bottom: 2),
                          ),  // 위치 글씨
                          SizedBox(
                            height: 300,
                            child: Card(
                              elevation: 4,
                              child: Stack(
                                children: [
                                  GoogleMap(
                                    mapType: MapType.normal,
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(double.parse(_detailLeaflet['advertiser']['lat']), double.parse(_detailLeaflet['advertiser']['lon'])),   // 전단지 배포 위치가 아닌, 실제 가게가 운영되는 위치
                                      zoom: 17,
                                    ),
                                    onMapCreated: _onMapCreated,
                                    markers: _markers,
                                    gestureRecognizers: Set()..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
                                    myLocationButtonEnabled: false,
                                    myLocationEnabled: false,
                                  ),
                                ],
                              ),
                            ),
                          ),  // 지도
                        ],
                      ),
                    ),  // 위치 Area
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            width: 350,
                            child: Text('쿠폰',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            padding: EdgeInsets.only(bottom: 2),
                          ),
                          SizedBox(
                            width: 320,
                            height: 150,
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 4,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top : 16, left: 15),
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Text(_detailLeaflet['p_coupon'],
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Color(0xff7C4CFF),
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          width: 200,
                                        ),
                                        SizedBox(height: 25,),
                                        Container(
                                          width: 200,
                                          child: Text(_detailLeaflet['condition1'] == null ? '' : _detailLeaflet['condition1'],
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Color(0xffEA9836),
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Container(
                                          width: 200,
                                          height: 40,
                                          alignment: Alignment.bottomLeft,
                                          child: Text(_detailLeaflet['condition2'] == null ? '' : _detailLeaflet['condition2'],    // 한글로는몇자까지만가능해14자\n2줄커버가능개행포함
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xffA1A1A1),
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                                        child: Text(_isCouponButtonDisable ? '지급완료' : '쿠폰받기'),
                                        onPressed: _isCouponButtonDisable ? null : () {
                                          _getCoupon();
                                        },
                                        color: Color(0xff7C4CFF),
                                        textColor: Colors.white,
                                        disabledColor: Color(0xff9C9C9C),
                                        disabledTextColor: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),  // 쿠폰 Area
                    Container(
                      child: Column(
                        children: [
                          QrImage(
                            data: jsonEncode({
                              "age": _userInfo['age'],
                              "gender": _userInfo['gender'],
                              "pid": _detailLeaflet['p_id'],
                              "state": 0,
                              "uid": _userInfo['id']
                            }),
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                          Text('QR코드 찍고 가게 방문 인증하세요!', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),  // QR코드 Area
                  ],
                ),
              ),
              SizedBox(height: 30,),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: RaisedButton(
                  child: Text(_isPointButtonDisable ? '지급완료' : '${_detailLeaflet['p_point']} Point 받기', style: TextStyle(fontSize: 20),),
                  onPressed: _isPointButtonDisable ? null : () async {
                    final response = await http.post('${MyApp.commonUrl}/token/user/state',
                      body: jsonEncode({
                        "age": _userInfo['age'],
                        "gender": _userInfo['gender'],
                        "pid": _detailLeaflet['p_id'],
                        "state": 2,
                        "uid": _userInfo['id'],
                      }),
                      headers: {
                        'Authorization' : 'Bearer $_token',
                        'Content-Type' : 'application/json'
                      },
                    );

                    print('포인트 받기 : ${response.statusCode}');

                    if(response.statusCode == 200 || response.statusCode == 200) {
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.SCALE,
                        headerAnimationLoop: false,
                        dialogType: DialogType.SUCCES,
                        title: '적립 성공!',
                        desc: '포인트가 적립되었습니다!',
                        btnOkIcon: Icons.check_circle,
                        btnOkOnPress: () {
                          debugPrint('OnClcik');
                        },
                      )..show().then((value) => setState(() {
                        _isPointButtonDisable = true;
                      }));
                    } else {
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.SCALE,
                        headerAnimationLoop: false,
                        dialogType: DialogType.ERROR,
                        title: '적립 실패...',
                        desc: '적립이 실패했습니다...\n잠시 후 다시 시도해주세요!',
                        btnOkOnPress: () {},
                        btnOkIcon: Icons.cancel,
                        btnOkColor: Colors.red,
                      )..show();
                    }
                  },
                  color: Color(0xff7C4CFF),
                  textColor: Colors.white,
                  disabledColor: Color(0xff9C9C9C),
                  disabledTextColor: Colors.black,
                ),
              ),  // Point 받기 버튼
            ],
          ),
        ),
      ),
    );
  }

  _getCoupon() async {
    _token = _token == null ? await FlutterSecureStorage().read(key: 'token') : _token;
    final response = await http.post('${MyApp.commonUrl}/token/user/coupon/${_detailLeaflet['p_id']}',
        headers: {
          'Authorization' : 'Bearer $_token'
        }
    );

    if(response.statusCode == 200 || response.statusCode == 201) {
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        title: '쿠폰 획득!',
        desc: '쿠폰을 획득하셨습니다!',
        btnOkIcon: Icons.check_circle,
        btnOkOnPress: () {
          debugPrint('OnClcik');
        },
      )..show().then((value) => setState(() {
        print('Coupon : $_isCouponButtonDisable');
        _isCouponButtonDisable = true;
        print('Coupon : $_isCouponButtonDisable');
      }));
    } else {
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        headerAnimationLoop: false,
        dialogType: DialogType.ERROR,
        title: '쿠폰 획득 실패...',
        desc: '쿠폰을 못 얻었어요...\n잠시 후 다시 시도해주세요!',
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red,
      )..show();
    }
    // showAlertDialog(context);
  }

  void showAlertDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('쿠폰획득'),
          content: Text("쿠폰을 획득하셨습니다."),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () async {
                // 쿠폰 저장 http 호출
                _token = _token == null ? await FlutterSecureStorage().read(key: 'token') : _token;
                final response = await http.post('${MyApp.commonUrl}/token/user/coupon/${_detailLeaflet['p_id']}',
                    headers: {
                      'Authorization' : 'Bearer $_token'
                    }
                );

                if(response.statusCode == 200 || response.statusCode == 201) {
                  setState(() {
                    print('Coupon : $_isCouponButtonDisable');
                    _isCouponButtonDisable = true;
                    print('Coupon : $_isCouponButtonDisable');
                  });
                }
                Navigator.pop(context, "");

              },
            ),
          ],
        );
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller.complete(controller);
    });
  }

  void _getDetailLeaflet(int args) async {
    _token = _token == null ? await FlutterSecureStorage().read(key: 'token') : _token;
    final response = await http.get('${MyApp.commonUrl}/token/user/paper/$args',
        headers: {
          'Authorization': 'Bearer $_token'
        }
    );

    setState(() {
      _detailLeaflet = json.decode(response.body)['data'];

      // marker 추가
      _markers.add(Marker(
        markerId: MarkerId(_detailLeaflet['advertiser']['marketname']),
        position: LatLng(double.parse(_detailLeaflet['advertiser']['lat']), double.parse(_detailLeaflet['advertiser']['lon'])),
        infoWindow: InfoWindow(title: _detailLeaflet['advertiser']['marketname']),
      ));

      if(initCheck) {
        // coupon 상태 초기화
        _isCouponButtonDisable = _detailLeaflet['coupon'] == null ? false : true;

        // point 상태 초기화
        _isPointButtonDisable = _detailLeaflet['getpoint'];

        initCheck = false;
      }
    });

    print('leaflet : $_detailLeaflet');
  }

  void _getUserInfo() async {
    _token = _token == null ? await FlutterSecureStorage().read(key: 'token') : _token;
    print('token : $_token');
    final response = await http.get('${MyApp.commonUrl}/token/user',
        headers: {
          'Authorization' : 'Bearer $_token'
        }
    );
    _userInfo = json.decode(response.body)['data'];
    print('userInfo : $_userInfo');

  }

}

class SliverMultilineAppBar extends StatelessWidget {
  final String title;
  final Widget leading;
  final List<Widget> actions;

  SliverMultilineAppBar({this.title, this.leading, this.actions});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    double availableWidth = mediaQuery.size.width - 160;
    if (actions != null) {
      availableWidth -= 32 * actions.length;
    }
    if (leading != null) {
      availableWidth -= 32;
    }
    return SliverAppBar(
      expandedHeight: 120.0,
      forceElevated: true,
      leading: leading,
      actions: actions,
      flexibleSpace: FlexibleSpaceBar(
        title: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: availableWidth,
          ),
          child: Text(title, textScaleFactor: .8,),
        ),
      ),
    );
  }
}