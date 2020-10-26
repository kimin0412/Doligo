import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;

class LeafletPage extends StatefulWidget {

  @override
  _LeafletPageState createState() => _LeafletPageState();
}

class _LeafletPageState extends State<LeafletPage> {
  int _point = -1;     // 적립 포인트

  Completer<GoogleMapController> _controller = Completer(); // ?
  MapType _googleMapType = MapType.normal;
  int _mapType = 0;
  Set<Marker> _markers = Set();
  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.382782, 127.1189054),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('포인트 바로 받기'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 20,),
      child: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(  // 적립포인트 카드탭
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: SizedBox(
                  height: 100,
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 15),
                          width: 400,
                          child: Text(
                            '내 적립포인트',
                            style: TextStyle(
                                color: Colors.lightBlue,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 15),
                          width: 400,
                          child: Text(
                            '$_point Point',
                            style: TextStyle(
                              color: Colors.lightBlue,
                              fontSize: 25,
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(  // 지도 부분
                child: SizedBox(
                  width: 400,
                  height: 300,
                  child: Card(
                    elevation: 4,
                    child: Stack(
                      children: [
                        GoogleMap(
                          mapType: _googleMapType,
                          initialCameraPosition: _initialCameraPosition,
                          onMapCreated: _onMapCreated,
                          myLocationEnabled: true,
                          markers: _markers,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(),
            ],
          ),
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
}


