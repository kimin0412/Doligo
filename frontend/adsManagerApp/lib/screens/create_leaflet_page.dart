import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:aws_s3/aws_s3.dart';
import 'package:dolligo_ads_manager/components/custom_time_picker.dart';
import 'package:dolligo_ads_manager/constants.dart';
import 'package:dolligo_ads_manager/models/advertiser_model.dart';
import 'package:dolligo_ads_manager/models/leaflet_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CreateLeafletPage extends StatefulWidget {
  @override
  _CreateLeafletPage createState() => _CreateLeafletPage();
}

class _CreateLeafletPage extends State<CreateLeafletPage> {
  String jwt;
  PickedFile _leafletImage;
  ImagePicker imagePicker;
  Completer<GoogleMapController> _controller; // ?
  MapType _googleMapType = MapType.normal;
  LatLng currentPosition;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
  int orderNum = 0;
  bool couponChecked = false;
  DateTime now = DateTime.now();
  int cost = 50;
  final DateFormat formatter = DateFormat('MM월 dd일 HH시');

  Advertiser _advertiser = Advertiser();
  Leaflet _leaflet  = Leaflet();

  @override
  void initState(){
    super.initState();

    imagePicker = new ImagePicker();
    _controller = Completer(); // ?

    _leaflet  = Leaflet();
    _leaflet.starttime = DateTime.now();
    _leaflet.endtime = _leaflet.starttime.add(Duration(hours: 1));

    _leaflet.sheets = 0;
    _leaflet.cost = 0;
    _getAdvertiserInfo();
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
      // backgroundColor: Color(0xffeeeeee),
    );
  }

  Widget _buildBody(){
    Size size = MediaQuery.of(context).size;
    return Container(child: Center(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(18,25,18,25),
            alignment: Alignment.center,
            child: Text('돌리고 전단지 주문', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(18,0,18,0),
            decoration: new BoxDecoration(color: Color(0xfff1f6FF), border: Border.all(color: Colors.blueAccent)),
            child: Column(
              children: [
                ListTile(
                  title: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '점포 이름',
                        ),
                        TextSpan(
                            text: '*',
                            style: TextStyle(color: Colors.red)
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(10,0,10,10),
                  padding: EdgeInsets.all(15.0),
                  decoration: new BoxDecoration(color: Colors.white),
                  child: Text(
                    "${_advertiser.marketname}",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(18,10,18,0),
            decoration: new BoxDecoration(color: Color(0xfff1f6FF), border: Border.all(color: Colors.blueAccent)),
            child: Column(
              children: [
                ListTile(
                  title: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '점포 주소',
                        ),
                        TextSpan(
                            text: '*',
                            style: TextStyle(color: Colors.red)
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(10,0,10,10),
                  padding: EdgeInsets.all(15.0),
                  decoration: new BoxDecoration(color: Colors.white),
                  child: Text(
                    "${_advertiser.marketaddress}",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(18,10,18,0),
            decoration: new BoxDecoration(color: Color(0xfff1f6FF), border: Border.all(color: Colors.blueAccent)),
            child: Column(
              children: [
                ListTile(
                  title: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '배포 위치',
                        ),
                        TextSpan(
                            text: '*',
                            style: TextStyle(color: Colors.red)
                        ),
                      ],
                    ),
                  ),
                  trailing: Wrap(
                    children: [
                      Text('지도에서 위치를 선택해주세요')
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10,0,10,10),
                  child: SizedBox(
                    height: 300,
                    child: Card(
                      elevation: 4,
                      child: Stack(
                        children: [
                          currentPosition == null ? Container() : GoogleMap(
                            mapType: _googleMapType,
                            initialCameraPosition: CameraPosition(
                              target: currentPosition,
                              zoom: 14,
                            ),
                            onMapCreated: _onMapCreated,
                            myLocationEnabled: true,
                            markers: Set<Marker>.of(_markers.values),
                            gestureRecognizers: Set()..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
                            zoomControlsEnabled: false,
                            onCameraMove: _cameraMove,
                            circles: Set.from([Circle(
                              circleId: CircleId('distributingRadius'),
                              center: currentPosition,
                              fillColor: Color.fromRGBO(30, 39, 133, 0.1),
                              strokeWidth: 1,
                              radius: 200,
                            )]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(10,0,10,10),
                  padding: EdgeInsets.all(15.0),
                  decoration: new BoxDecoration(color: Colors.white),
                  child: currentPosition == null ? Container() :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('위도 : ${currentPosition.latitude.toStringAsFixed(5)}'),
                      Text('경도 : ${currentPosition.longitude.toStringAsFixed(5)}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(18,10,18,0),
            decoration: new BoxDecoration(color: Color(0xfff1f6FF), border: Border.all(color: Colors.blueAccent)),
            child: Column(
              children: [
                ListTile(
                  title: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '전단지 이미지 등록 ',
                        ),
                        TextSpan(
                            text: '*',
                            style: TextStyle(color: Colors.red)
                        ),
                      ],
                    ),
                  ),
                ),
                _leafletImage != null ? Center(
                  child: Image.file(File(_leafletImage.path))
                ) : Divider( thickness: 1 ,),
                Container(
                  margin: EdgeInsets.fromLTRB(10,0,10,10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: new BoxDecoration(color: Colors.white),
                        child: Text(
                          _leafletImage != null ? "${_leafletImage.path}" : "이미지가 없습니다",
                          style: TextStyle(fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                        width: size.width * 0.6,
                      ),
                      FlatButton(
                        padding: EdgeInsets.all(10.0),
                        onPressed: _getImage,
                        child: Text('찾기', style: TextStyle(color: Colors.white),),
                        color: kPrimaryColor,
                      )
                    ],
                  )
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(18,10,18,0),
            decoration: new BoxDecoration(color: Color(0xfff1f6FF), border: Border.all(color: Colors.blueAccent)),
            child: Column(
              children: [
                ListTile(
                  title: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '쿠폰 이벤트 추가하기 ',
                        ),
                      ],
                    ),
                  ),
                  trailing: Checkbox(
                    value: couponChecked,
                    checkColor: Colors.grey,
                    onChanged: (value){
                      setState(() {
                        couponChecked = value;
                      });
                    },
                  ),
                ),
                couponChecked ?
                  Column(
                    children: [
                      Divider( thickness: 1,)
                      ,
                      ListTile(
                        title: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '쿠폰 내용',
                              ),
                              TextSpan(
                                  text: '*',
                                  style: TextStyle(color: Colors.red)
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10,0,10,10),
                        padding: EdgeInsets.fromLTRB(10,0,0,0),
                        decoration: new BoxDecoration(color: Colors.white),
                        child:
                        TextField(
                          style: TextStyle(fontSize: 15),
                          decoration: new InputDecoration(
                              hintText: "쿠폰 내용을 입력해주세요.",
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none
                          ),
                          onChanged: (value) {
                            _leaflet.p_coupon = value;
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10,0,10,10),
                        padding: EdgeInsets.fromLTRB(10,0,0,0),
                        decoration: new BoxDecoration(color: Colors.white),
                        child:
                        TextField(
                          style: TextStyle(fontSize: 15),
                          decoration: new InputDecoration(
                              hintText: "조건 1",
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none
                          ),
                          onChanged: (value) {
                            _leaflet.condition1 = value;
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10,0,10,10),
                        padding: EdgeInsets.fromLTRB(10,0,0,0),
                        decoration: new BoxDecoration(color: Colors.white),
                        child:
                        TextField(
                          style: TextStyle(fontSize: 15),
                          decoration: new InputDecoration(
                              hintText: "조건 2",
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none
                          ),
                          onChanged: (value) {
                            _leaflet.condition2 = value;
                          },
                        ),
                      ),
                    ],
                  )
                    :
                  SizedBox(height: size.height * 0.01),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.fromLTRB(18,10,18,0),
            decoration: new BoxDecoration(color: Color(0xfff1f6FF), border: Border.all(color: Colors.blueAccent)),
            child: Column(
              children: [
                ListTile(
                  title: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '배포 날짜/시간',
                        ),
                        TextSpan(
                            text: '*',
                            style: TextStyle(color: Colors.red)
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(15,0,10,10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.2,
                          child: Text('배포 시작'),
                        ),
                        FlatButton(
                            minWidth: size.width * 0.6,
                            color: Colors.white,
                            onPressed: () {
                              DatePicker.showPicker(
                                context,
                                pickerModel: CustomTimePicker(
                                  locale: LocaleType.ko,
                                  minTime: now,
                                  maxTime: now.add(Duration(days: 10)),
                                ),
                                onConfirm:(time) {
                                  setState(() {
                                    _leaflet.starttime = time;
                                    _leaflet.endtime = _leaflet.starttime.add(Duration(hours: 1));
                                  });
                                },
                              );
                            },
                            child: Text(
                              formatter.format(_leaflet.starttime),
                              style: TextStyle(color: Colors.blue, fontSize: 16),
                            )
                        ),
                      ],
                    )
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(15,0,10,10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.2,
                          child: Text('배포 종료'),
                        ),
                        FlatButton(
                            minWidth: size.width * 0.6,
                            color: Colors.white,
                            onPressed: () {
                              DatePicker.showPicker(context, pickerModel: CustomTimePicker(locale: LocaleType.ko, minTime: _leaflet.starttime,
                                  maxTime: _leaflet.starttime.add(Duration(days: 1))),
                                onConfirm:(time) {
                                  if(_leaflet.starttime.isAfter(time)){
                                    showToast('종료시간은 시작시간 이후로 해주세요.');
                                  } else {
                                    setState(() {
                                      _leaflet.endtime = time;
                                    });
                                  }
                                },);
                            },
                            child: Text(
                              formatter.format(_leaflet.endtime),
                              style: TextStyle(color: Colors.blue, fontSize: 16),
                            )
                        ),
                      ],
                    )
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(18,10,18,0),
            decoration: new BoxDecoration(color: Color(0xfff1f6FF), border: Border.all(color: Colors.blueAccent)),
            child: Column(
              children: [
                ListTile(
                  title: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '배포 매수',
                        ),
                        TextSpan(
                            text: '*',
                            style: TextStyle(color: Colors.red)
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(10,0,10,10),
                  padding: EdgeInsets.fromLTRB(10,0,0,0),
                  decoration: new BoxDecoration(color: Colors.white),
                  child:
                  TextField(
                    style: TextStyle(fontSize: 15),
                    decoration: new InputDecoration(
                      hintText: "배포 매수를 입력해주세요.",
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ], // Only numbers can be entered
                    onChanged: (value) {
                      setState(() {
                        _leaflet.sheets = int.parse(value);
                        _leaflet.cost = _leaflet.sheets * cost;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: size.height * 0.03),
          Container(
              // margin: EdgeInsets.fromLTRB(18,10,18,0),
            // padding: EdgeInsets.fromLTRB(18,10,18,18),
            decoration: new BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey)),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.03),
                Text('전단지 주문 내역', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                SizedBox(height: size.height * 0.03),
                Text('디지털 전단지는 환경을 살립니다 🌱', textAlign: TextAlign.center,),
                SizedBox(height: size.height * 0.03),
                ListTile(
                  title:  Text('전단지 x ${_leaflet.sheets}', style: TextStyle(fontSize: 18)),
                  subtitle: Text('1매당 ${cost}원'),
                  trailing: Text('${_leaflet.cost}원', style: TextStyle(fontSize: 18)),
                ),
                ListTile(
                  title:  Text('결제 금액', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kPrimaryColor)),
                  trailing: Text('${_leaflet.cost}원', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: kPrimaryColor)),
                ),
                SizedBox(height: size.height * 0.05),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    height: 40,
                    child:RaisedButton(
                      child: Text('카카오페이로 결제하기', style: TextStyle(fontSize : 20,color: Colors.white),),
                      color: Colors.deepPurpleAccent,
                      onPressed: sendLeaflet,
                    ),
                  )
                ),
                SizedBox(height: size.height * 0.1),
              ],
            )
          ),
        ],
      )
    ),
      // color: Color(0xfff1f6FF),
    );
  }

  void _pay_kakao() async {
    var res = await http.post(
      'https://kapi.kakao.com/v1/payment/ready',
      encoding: Encoding.getByName('utf8'),
      headers: {
        'Authorization' : 'KakaoAK $KAKAO_ADMIN_KEY',
        'Content-type' : 'application/x-www-form-urlencoded;charset=utf-8'
      },
      body: {
        'cid':'TC0ONETIME',
        'partner_order_id':'partner_order_id',
        'partner_user_id':'partner_user_id',
        'item_name' : '광고비 결제',
        'quantity': '1',
        'total_amount': _leaflet.cost,
        'vat_amount' : '0',
        'tax_free_amount' : '0',
        'approval_url' : '$SERVER_IP/api' ,
        'cancel_url' : '$SERVER_IP/api' ,
        'fail_url' : '$SERVER_IP/api' ,
      }
    );

    Map<String, dynamic> result = jsonDecode(res.body);

    print(result);
    AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: result['next_redirect_app_url'],
      arguments: {'txn_id': result['tid']},
    );

    var r = await intent.launch();
  }

  void sendLeaflet() async {
    _leaflet.p_point = 15;
    _leaflet.lat = currentPosition.latitude.toStringAsFixed(5);
    _leaflet.lon = currentPosition.longitude.toStringAsFixed(5);

    if(_leafletImage == null){
      showToast('전단지 이미지를 등록해주세요');
      return;
    }

    if(_leaflet.sheets <= 0){
      showToast('전단지 매수는 0보다 커야 합니다.');
      return;
    }

    String imageName = _advertiser.id.toString() + '_' + DateTime.now().toIso8601String();

    AwsS3 awsS3 = AwsS3(
        awsFolderPath: "Upload/Paper",
        file: File(_leafletImage.path),
        fileNameWithExt: imageName,
        poolId: 'ap-northeast-2:4985e7e4-3205-4085-8e76-368daf8dc9b7',
        region: Regions.AP_NORTHEAST_2,
        bucketName: 'plog-image');

    String re = await awsS3.uploadFile;

    _leaflet.p_image = "https://plog-image.s3.ap-northeast-2.amazonaws.com/Upload/Paper/" + imageName;

    _pay_kakao();
    var response = await http.post(
      '$SERVER_IP/api/token/advertiser/paper',
      headers: {'Content-Type': "application/json",
        'Authorization' : 'Bearer $jwt'},
      body:json.encode(_leaflet.toJson(),toEncodable: (item){
        if(item is DateTime) {
          return item.toIso8601String();
        }
        return item;
      })
    );

    if(response.statusCode == 200){
      showToast("전단지 등록 성공");
      Navigator.pop(context);
    } else {
      showToast("전단지 등록에 실패했습니다.");
    }
  }

  void _cameraMove(CameraPosition cameraPosition) async {

    if(_markers.length > 0) {
      MarkerId markerId = MarkerId(_markerIdVal());
      Marker marker = _markers[markerId];
      Marker updatedMarker = marker.copyWith(
        positionParam: cameraPosition.target,
      );

      setState(() {
        currentPosition = cameraPosition.target;
        _markers[markerId] = updatedMarker;
      });
    }
  }

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    if (currentPosition != null) {
      MarkerId markerId = MarkerId(_markerIdVal());
      LatLng position = currentPosition;
      Marker marker = Marker(
        markerId: markerId,
        position: position,
        draggable: false,
      );
      setState(() {
        _markers[markerId] = marker;
      });

      Future.delayed(Duration(seconds: 1), () async {
        GoogleMapController controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: position,
              zoom: 14.0,
            ),
          ),
        );
      });
    }
  }

  Future _getImage() async{
    PickedFile image = await imagePicker.getImage(source: ImageSource.gallery);

    setState(() {
      _leafletImage = image;
    });
  }

  void _getAdvertiserInfo() async{
    jwt = await FlutterSecureStorage().read(key: 'jwt');

    var response = await http.get('$SERVER_IP/api/token/advertiser',
        headers: {'Authorization' : 'Bearer $jwt'});

    _advertiser = Advertiser.fromJson(jsonDecode(response.body)['data']);

    _leaflet.p_mtid = _advertiser.mtid;
    _leaflet.p_aid = _advertiser.id;

    setState(() {
      currentPosition = LatLng(double.parse(_advertiser.lat), double.parse(_advertiser.lon));
    });
  }

  void showToast(String message){
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT
    );
  }
}
