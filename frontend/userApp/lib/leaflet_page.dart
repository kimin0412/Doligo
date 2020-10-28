import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:userApp/leaflet_detail_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;

class LeafletPage extends StatefulWidget {

  @override
  _LeafletPageState createState() => _LeafletPageState();
}

class _LeafletPageState extends State<LeafletPage> {

  Container MyArticles(String imageVal, String heading, String subHeading) {
    return Container(
      width: 160,
      child: Card(
        child: Wrap(
          children: [
            SizedBox(
              width: 160,
              height: 170,
              child: Image.network(imageVal),
            ),
            ListTile(
              title: Text(heading),
              subtitle: Text(subHeading),
            ),
          ],
        ),
      ),
    );
  }


  int _point = -1;     // 적립 포인트

  Completer<GoogleMapController> _controller = Completer(); // ?
  MapType _googleMapType = MapType.normal;
  int _mapType = 0;
  Set<Marker> _markers = Set();
  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  LatLng currentPostion;

  @override
  void initState() {
    super.initState();

    // 나중에 적립 포인트 가져오는 부분도 여기서 구현한다!!
    //
    //
    //
    //

    // 현재 위치를 얻어와 초기화 한다.
    _getUserLocation();

  }

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
    });
  }

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
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
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
                ),  // 적립포인트 카드탭
                Container(
                  child: SizedBox(
                    width: 400,
                    height: 300,
                    child: Card(
                      elevation: 4,
                      child: Stack(
                        children: [
                          currentPostion == null ? Container() : GoogleMap(
                            mapType: _googleMapType,
                            initialCameraPosition: CameraPosition(
                              target: currentPostion,
                              zoom: 14,
                            ),
                            onMapCreated: _onMapCreated,
                            myLocationEnabled: true,
                            markers: _markers,
                            zoomControlsEnabled: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),  // 지도 부분
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _listviewData == null ? 0 : _listviewData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: MyArticles(_listviewData[index]['imageVal'], _listviewData[index]['heading'], _listviewData[index]['subHeading']),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            LeafletDetailPage.routeName,
                            arguments: ScreenArguments(1, _listviewData[index]['imageVal'], _listviewData[index]['heading'],
                                37.498295, 127.026437, false, false),
                          );
                        },
                      );
                    },

                  ),
                ),  // 전단지 리스트뷰
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller.complete(controller);
    });
  }

  var _listviewData = [
    {'imageVal' : 'https://cdn.shopify.com/s/files/1/1060/9112/products/Covid-19-01_8e003b8d-7115-41a2-b51c-1ef6d249d745_1024x1024.jpg?v=1583432489',
      'heading' : 'corona',
      'subHeading' : 'nineteen'
    },
    {'imageVal' : 'https://cdn.shopify.com/s/files/1/1060/9112/products/Covid-19-01_8e003b8d-7115-41a2-b51c-1ef6d249d745_1024x1024.jpg?v=1583432489',
      'heading' : 'corona',
      'subHeading' : 'nineteen'
    },
    {'imageVal' : 'https://cdn.shopify.com/s/files/1/1060/9112/products/Covid-19-01_8e003b8d-7115-41a2-b51c-1ef6d249d745_1024x1024.jpg?v=1583432489',
      'heading' : 'corona',
      'subHeading' : 'nineteen'
    },
    {'imageVal' : 'https://cdn.shopify.com/s/files/1/1060/9112/products/Covid-19-01_8e003b8d-7115-41a2-b51c-1ef6d249d745_1024x1024.jpg?v=1583432489',
      'heading' : 'corona',
      'subHeading' : 'nineteen'
    },
    {'imageVal' : 'https://cdn.shopify.com/s/files/1/1060/9112/products/Covid-19-01_8e003b8d-7115-41a2-b51c-1ef6d249d745_1024x1024.jpg?v=1583432489',
      'heading' : 'corona',
      'subHeading' : 'nineteen'
    },
  ];
}


