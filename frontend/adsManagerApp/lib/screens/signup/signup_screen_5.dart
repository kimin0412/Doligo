import 'dart:async';
import 'dart:convert';

import 'package:dolligo_ads_manager/components/rounded_button.dart';
import 'package:dolligo_ads_manager/constants.dart';
import 'package:dolligo_ads_manager/models/advertiser_model.dart';
import 'package:dolligo_ads_manager/models/category_model.dart';
import 'package:dolligo_ads_manager/screens/tap_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';


class SignUpScreen5 extends StatefulWidget {
  static const routeName = '/signUp5';

  @override
  _SignUpScreen5 createState() => _SignUpScreen5();
}

class _SignUpScreen5 extends State<SignUpScreen5> {
  Advertiser advertiser;
  MediumCategoryItem mci;
  ImagePicker imagePicker;
  Completer<GoogleMapController> _controller = Completer(); // ?
  MapType _googleMapType = MapType.normal;
  LatLng currentPosition;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;

  User selectedUser;
  List<User> users = <User>[const User('Foo', 'ee'), const User('Bar', 'bb')];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 현재 위치를 얻어와 초기화 한다.
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    advertiser = ModalRoute.of(context).settings.arguments;

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
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      color: kPrimaryLightColor,
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: size.height * 0.03),
            Container(
              child: Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '점포 위치',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                ]
              )
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
                        zoomControlsEnabled: false,
                        onCameraMove: _cameraMove,
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
            RoundedButton(
              text: "등록하기",
              press: () {
                signUp();
              },
            )
          ],
        ),
      )
    );
  }

  void _getUserLocation() async{
    Position position = await GeolocatorPlatform.instance.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
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


  void signUp() async{
    final response = await http.post(
      "$SERVER_IP/api/advertiser/signup",
      body: jsonEncode(
        {
          'email': advertiser.email,
          'password': advertiser.password,
          'lat': currentPosition.latitude,
          'lon': currentPosition.longitude,
          'marketaddress': advertiser.marketaddress,
          'marketname': advertiser.marketname,
          'mtid': advertiser.mtid
        },
      ),
      headers: {'Content-Type': "application/json"},
    );

    if(response.statusCode == 200){
      await FlutterSecureStorage().write(key: 'jwt', value: response.headers['token']);

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return TabPage();
        },
      ), (r) => false);
    } else {
      print('실패');
    }
  }
}

class User {
  const User(this.name,this.aa);

  final String name;
  final String aa;
}
