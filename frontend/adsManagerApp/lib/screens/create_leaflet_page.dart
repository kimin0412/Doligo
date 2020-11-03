import 'dart:async';
import 'dart:io';

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
  Set<Marker> _markers = Set();
  LatLng currentPosition;


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
              trailing: Wrap(
                children: [
                  Text('0/20')
                ],
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
              trailing: Wrap(
                children: [
                  Text('0/100')
                ],
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
                      markers: _markers,
                      zoomControlsEnabled: false,
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
          ) : Text('이미지를 등록해 주세요')
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
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: RaisedButton(
              child: Text('결제하기'),
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

    print(position);
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);

      _markers.add(Marker(
        markerId: MarkerId('현재 위치'),
        position: currentPosition
      ));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller.complete(controller);
    });
  }

  Future _getImage() async{
    PickedFile image = await imagePicker.getImage(source: ImageSource.gallery);

    setState(() {
      _leafletImage = image;
    });
  }


}
