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
  final pageController = PageController(viewportFraction: 0.8);

  Set<Circle> circles;


  List _listviewData = [];
  var _userInfo;

  int _currentIndex = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }



  Completer<GoogleMapController> _controller = Completer(); // ?
  MapType _googleMapType = MapType.normal;
  int _mapType = 0;
  Set<Marker> _markers = Set();
  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  LatLng currentPostion;

  @override
  void initState() {
    super.initState();

    // 현재 위치를 얻어와 초기화 한다.
    _getUserLocation();
    _getUserInfo();
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
                              zoom: 17,
                            ),
                            onMapCreated: _onMapCreated,
                            myLocationEnabled: true,
                            markers: _markers,
                            zoomControlsEnabled: true,
                            circles: circles,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),  // 지도 부분
                // Container(
                //   margin: EdgeInsets.symmetric(vertical: 10),
                //   height: 250,
                //   child: ListView.builder(
                //     scrollDirection: Axis.horizontal,
                //     itemCount: _listviewData == null ? 0 : _listviewData.length,
                //     itemBuilder: (BuildContext context, int index) {
                //       return GestureDetector(
                //         child: MyArticles(_listviewData[index]['p_image'], _listviewData[index]['marketname'], _listviewData[index]['marketaddress']),
                //         onTap: () {
                //           Navigator.pushNamed(
                //             context,
                //             LeafletDetailPage.routeName,
                //             arguments: _listviewData[index]['p_id'],
                //           ).then(refreshPage);
                //         },
                //       );
                //     },
                //
                //   ),
                // ),  // 전단지 리스트뷰
                Column(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 230.0,
                        enlargeCenterPage: true,
                        autoPlay: false,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        pauseAutoPlayOnTouch: true,
                        aspectRatio: 2.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                      items: _listviewData.map((card){
                        return Builder(
                            builder:(BuildContext context){
                              return Container(
                                height: MediaQuery.of(context).size.height*0.30,
                                width: MediaQuery.of(context).size.width,
                                child: GestureDetector(
                                  child: Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    elevation: 10,
                                    child: Stack(
                                      children: [
                                        Positioned.fill(child: card),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            alignment: Alignment.center,
                                            color: Color(0x99000000),
                                            width: MediaQuery.of(context).size.width,
                                            height: MediaQuery.of(context).size.height*0.085,
                                            child: SizedBox(
                                              child: ListTile(
                                                title: Text(card._heading, style: TextStyle(color: Colors.white),),
                                                subtitle: Text(card._subHeading, style: TextStyle(color: Colors.white),),
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
                                      arguments: card._id,
                                    ).then(refreshPage);
                                  },
                                ),
                              );
                            }
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 5,),
                    SmoothPageIndicator(
                        controller: pageController,  // PageController
                        count:  6,
                        effect: ScrollingDotsEffect(
                          activeDotColor: Color(0xff7C4CFF),
                          dotHeight: 10,
                          dotWidth: 10,
                        ),  // your preferred effect
                    ),
                    AnimatedSmoothInidcator(
                      activeIndex: _currentIndex,
                      count:  6,
                      effect:  WormEffect(),
                    )
                  ],
                ),
              ],
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

    setState(() {
      // print('길이? : ${tmp.length}');
      for(int i = 0; i < tmp.length; i++) {
        _markers.add(Marker(
          markerId: MarkerId('$i'),
          position: LatLng(double.parse(tmp[i]['lat']), double.parse(tmp[i]['lon'])),
          infoWindow: InfoWindow(title: tmp[i]['marketname']),
        ));
        _listviewData.add(MyArticles(tmp[i]['p_image'], tmp[i]['marketname'], tmp[i]['marketaddress'], tmp[i]['p_id']));
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
    _getNearLeafletList();
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