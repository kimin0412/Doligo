import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateLeafletPage extends StatefulWidget {
  @override
  _CreateLeafletPage createState() => _CreateLeafletPage();
}

class _CreateLeafletPage extends State<CreateLeafletPage> {
  PickedFile _leafletImage;
  ImagePicker imagePicker;
  Completer<GoogleMapController> _controller = Completer(); // ?
  MapType _googleMapType = MapType.normal;
  LatLng currentPosition;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
  int orderNum = 0;

  @override
  void initState(){
    super.initState();
    imagePicker = new ImagePicker();

    // 현재 위치를 얻어와 초기화 한다.
    _getUserLocation();
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
      backgroundColor: Color(0xffeeeeee),
    );
  }

  Widget _buildBody(){
    return Center(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            child: ListTile(
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
          ),
          Container(
            decoration: new BoxDecoration(color: Colors.white),
            child: TextField(
              style: TextStyle(fontSize: 15),
              decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(15.0),
                  hintText: "20자 이내(한글/영문/숫자)"
              ),
            ),
          ),
          Container(
            child: ListTile(
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
          ),
          Container(
            decoration: new BoxDecoration(color: Colors.white),
            child: TextField(
              style: TextStyle(fontSize: 15),
              decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(15.0),
                  hintText: "점포 주소를 입력해주세요.(100자 이내)"
              ),
            ),
          ),
          Container(
            child: ListTile(
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
          ),
          Container(
            child: SizedBox(
              width: 400,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('위도 : ${currentPosition.longitude}'),
              Text('경도 : ${currentPosition.latitude}'),
            ],
          ),
          Container(
            child: ListTile(
              title: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '전단지 이미지 등록',
                    ),
                    TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red)
                    ),
                  ],
                ),
              ),
            ),
          ),
          _leafletImage != null ? Card(
            margin: EdgeInsets.fromLTRB(20,0,20,20),
            child: Image.file(File(_leafletImage.path))
          ) : Text('이미지를 등록해 주세요', textAlign: TextAlign.center,)
          ,

          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Colors.deepPurpleAccent, width: 3)
              ),
              child: Text('이미지 올리기'),
              color: Colors.white,
              onPressed: _getImage,
            ),
          ),
          Container(
            child: ListTile(
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
          ),
          Container(
            child: ListTile(
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
          ),
          Container(
            decoration: new BoxDecoration(color: Colors.white),
            child: TextField(
              style: TextStyle(fontSize: 15),
              decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(15.0),
                  hintText: "배포 매수를 입력해주세요."
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
              onChanged: (value) {
                setState(() {
                  orderNum = int.parse(value);
                });
              },
            ),
          ),
          Container(
            child: Column(
              children: [
                Text('디지털 전단지는 환경을 살립니다 🌱'),
                Text('<주문서 확인>'),
                Row(
                  children: [
                    Text('주문 매수 : '),
                    Text('$orderNum * 50원'),
                  ],
                ),
                Text('${orderNum*50}원'),

              ],
            )
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: RaisedButton(
              child: Text('결제하기', style: TextStyle(color: Colors.white),),
              color: Colors.deepPurpleAccent,
              onPressed: _getImage,
            ),
          ),
        ],
      )
    );
  }

  void _getUserLocation() async{
    Position position = await GeolocatorPlatform.instance.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
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


}
