import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:userApp/leaflet_detail_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;

import 'main.dart';


class LeafletPage extends StatefulWidget {
  static const routeName = '/leafFlet';

  @override
  _LeafletPageState createState() => _LeafletPageState();
}

class _LeafletPageState extends State<LeafletPage> {

  Set<Circle> circles;
  var refreshKey = GlobalKey<RefreshIndicatorState>();


  List _listviewData = [];
  var _userInfo;

  PageController _pageController;
  int _currentPageIndex;

  double _zoom;

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await _getNearLeafletList();

    setState(() {

    });

    return null;
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }


  bool markerBugProtect;

  Completer<GoogleMapController> _controller = Completer();
  MapType _googleMapType = MapType.normal;
  int _mapType = 0;
  List<Marker> _markers = <Marker>[];
  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  LatLng currentPostion;

  @override
  void initState() {
    super.initState();

    _currentPageIndex = 0;
    _pageController = new PageController(
      initialPage: _currentPageIndex,
      keepPage: false,
      viewportFraction: 0.8,
    );
    _zoom = 17;

    markerBugProtect = false;

    // 현재 위치를 얻어와 초기화 한다.
    _getUserLocation();
    _getUserInfo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);

      circles = Set.from([Circle(
        circleId: CircleId('MyCircle'),
        center: LatLng(currentPostion.latitude, currentPostion.longitude),
        radius: 80,
        fillColor: Color(0x448B6DFF),
        strokeWidth: 1,
        strokeColor: Colors.purple,
      )]);
      _getNearLeafletList();
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
      body: _userInfo == null ? Container() : _buildBody(),
    );
  }

  Widget _buildBody() {
    return  RefreshIndicator(
      backgroundColor: Colors.amberAccent,
      key: refreshKey,
      onRefresh: refreshList,
      child: Padding(
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
                                  color: Colors.black,
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
                                '${_userInfo['point']} Point',
                                style: TextStyle(
                                  color: Colors.black,
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
                                zoom: _zoom,
                              ),
                              onMapCreated: _onMapCreated,
                              myLocationEnabled: true,
                              markers: Set<Marker>.of(_markers),
                              zoomControlsEnabled: true,
                              circles: circles,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),  // 지도 부분
                  Container(
                    height: 240,
                    width: MediaQuery.of(context).size.width,
                    child: _listviewData.length > 0 ? PageView.builder(
                      onPageChanged: (value) {
                        setState(() {
                          _currentPageIndex = value;
                        });
                        _goMarkingAreaAndZoomIn(value);
                      },
                      controller: _pageController,
                      itemBuilder: (context, index) => listviewBuilder(index),
                      itemCount: _listviewData.length,
                      reverse: false,
                      pageSnapping: true,
                    ) : Container(),
                  ),  // 전단지 리스트 부분
                  SizedBox(height: 5,),
                  _listviewData.length > 0 ? SmoothPageIndicator(
                    controller: _pageController,  // PageController
                    count: _listviewData.length,
                    effect: ScrollingDotsEffect(
                        activeDotColor: Color(0xff7C4CFF),
                        dotHeight: 10,
                        dotWidth: 10,
                        fixedCenter: true
                    ),  // your preferred effect
                  ) : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _getUserInfo() async {
    String _token = await FlutterSecureStorage().read(key: 'token');
    final response = await http.get('${MyApp.commonUrl}/token/user',
        headers: {
          'Authorization': 'Bearer $_token'
        }
    );

    setState(() {
      _userInfo = json.decode(response.body)['data'];
      print('userInfo : $_userInfo');
    });
  }

  void _getNearLeafletList() async {
    String _token = await FlutterSecureStorage().read(key: 'token');
    print(_token);
    int _radius = 80;
    final response = await http.get('${MyApp.commonUrl}/token/user/paper/'
        '${currentPostion.latitude}/${currentPostion.longitude}/$_radius',
        headers: {
          'Authorization': 'Bearer $_token'
        }
    );

    print(currentPostion.toString());
    print('leaflet List : ${response.body}');

    var tmp = json.decode(response.body)['data'];
    _listviewData.clear();
    _markers.clear();

    setState(() {
      // print('길이? : ${tmp.length}');
      _listviewData.add(MyArticles('', '', '', 0));
      _markers.add(Marker(
          markerId: MarkerId('0'),
          position: currentPostion,
          infoWindow: InfoWindow(title: '내 위치'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
      for(int i = 1; i <= tmp.length; i++) {
        _markers.add(Marker(
            markerId: MarkerId('$i'),
            position: LatLng(double.parse(tmp[i-1]['lat']), double.parse(tmp[i-1]['lon'])),
            infoWindow: InfoWindow(title: tmp[i-1]['marketname'], snippet: tmp[i-1]['marketaddress']),
            onTap: () async {
              markerBugProtect = true;      // marker가 눌렸을 땐 이게 켜지면서 page가 넘어가면서 마커가 수시로 바뀌지 않도록 한다.
              // print('$i가 눌렸다..');
              await _pageController.animateToPage(
                i,
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
              );
              markerBugProtect = false;
            }
        ));
        _listviewData.add(MyArticles(tmp[i-1]['p_image'], tmp[i-1]['marketname'], tmp[i-1]['marketaddress'], tmp[i-1]['p_id']));
      }

    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller.complete(controller);
    });
  }



  FutureOr refreshPage(Object value) {
    _getUserLocation();
    _getUserInfo();
    _goMarkingAreaAndZoomIn(0);
  }

  listviewBuilder(int index) {
    return new AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 1.0;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
        }

        return new Center(
          child: new SizedBox(
            height: Curves.easeOut.transform(value) * 300,
            width: Curves.easeOut.transform(value) * 400,
            child: child,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 3),
        // heighst: MediaQuery.of(context).size.height*0.30,
        child: GestureDetector(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 10,
            child: index == 0 ? Container(
              child: _listviewData.length - 1 == 0 ? Text('내 주변에 전단지가 없습니다!', style: TextStyle(fontSize: 20),) : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('내 주변에', style: TextStyle(fontSize: 20),),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text:'${_listviewData.length - 1}', style: TextStyle(fontSize: 30)),
                        TextSpan(text:'개의 전단지가 있습니다!', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ],
              ),
              alignment: Alignment.center,
            ) : Stack(
              children: [
                Positioned.fill(child: _listviewData[index]),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                        colors: [
                          const Color(0xaaaaaaaa),
                          const Color(0xbb000000),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.085,
                    child: SizedBox(
                      child: ListTile(
                        title: Text(_listviewData[index]._heading, style: TextStyle(color: Colors.white),),
                        subtitle: Text(_listviewData[index]._subHeading, style: TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis,),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              LeafletDetailPage.routeName,
              arguments: _listviewData[index]._id,
            ).then(refreshPage);
          },
        ),
      ),
    );
  }

  void _goMarkingAreaAndZoomIn(int value) async {
    if(!markerBugProtect) {
      final GoogleMapController googleMapController = await _controller.future;
      if(value > 0) {
        googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: _markers[value].position, zoom: 19)));
        googleMapController.showMarkerInfoWindow(_markers[value].markerId);
      } else {
        googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: currentPostion, zoom: _zoom)));
        googleMapController.showMarkerInfoWindow(_markers[value].markerId);
      }
    }
  }
}
class MyArticles extends StatelessWidget {
  final String _imageVal;
  final String _heading;
  final String _subHeading;
  final int _id;

  @override
  Widget build(BuildContext context) {
    return Image.network(_imageVal, fit: BoxFit.cover,);
  }

  MyArticles(this._imageVal, this._heading, this._subHeading, this._id);
}
