import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

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

  ScreenArguments args = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initCheck = true;
    _isCouponButtonDisable = false;
    _isPointButtonDisable = false;
  }

  @override
  Widget build(BuildContext context) {

    args = ModalRoute.of(context).settings.arguments;
    print(args.toString());

    setState(() {
      // marker 추가
      _markers.add(Marker(
        markerId: MarkerId(args.heading),
        position: LatLng(args.lat, args.lng),
        infoWindow: InfoWindow(title: args.heading),
      ));

      if(initCheck) {
        // coupon 상태 초기화
        _isCouponButtonDisable = args.coupon;

        // point 상태 초기화
        _isPointButtonDisable = args.point;

        initCheck = false;
      }
    });
    print(args.imageUrl);
    print(args.heading);
    print(args.lat);
    print(args.lng);


    return args == null ? Scaffold() : Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(args.heading),
      ),
      body: _buildBody(args),
    );
  }

  _buildBody(ScreenArguments args) {
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
                                color: Colors.lightBlue,
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
                              child: Image.network(args.imageUrl),
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
                                color: Colors.lightBlue,
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
                                  args == null ? Container() : GoogleMap(
                                    mapType: MapType.normal,
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(args.lat, args.lng),   // 전단지 배포 위치가 아닌, 실제 가게가 운영되는 위치
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
                                color: Colors.lightBlue,
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
                                    padding: const EdgeInsets.only(top : 16, left: 20),
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Text('50,000원 할인',
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
                                          child: Text('상담만 받아도!',
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
                                          child: Text('한글로는몇자까지만가능해14자\n2줄커버가능개행포함',
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
                            data: "1234567890",
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
                  child: Text(_isPointButtonDisable ? '지급완료' : 'Point 겟 하기', style: TextStyle(fontSize: 20),),
                  onPressed: _isPointButtonDisable ? null : () {},
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

  _getCoupon()  {
    showAlertDialog(context);
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
              onPressed: () {
                setState(() {
                  print('Coupon : $_isCouponButtonDisable');
                  _isCouponButtonDisable = true;
                  print('Coupon : $_isCouponButtonDisable');
                });
                Navigator.pop(context, "쿠폰을 사용하였습니다!");
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
}

// 라우트 생성시 전달할 아규먼트 클래스
class ScreenArguments{
  // 아규먼트의 타이틀과 메시지. 생성자에 의해서만 초기화되고 변경할 수 없음
  final int id;
  final String imageUrl;
  final String heading;
  final double lat;
  final double lng;
  final bool coupon;

  final bool point;

  // 생성자
  ScreenArguments(this.id, this.imageUrl, this.heading, this.lat, this.lng, this.coupon, this.point);

  @override
  String toString() {
    return 'ScreenArguments{id: $id, imageUrl: $imageUrl, heading: $heading, lat: $lat, lng: $lng, coupon: $coupon, point: $point}';
  }
}