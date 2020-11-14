import 'dart:async';
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:userApp/cash_exchange.dart';
import 'package:userApp/constants.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:userApp/main.dart';

class Item {
  Item({this.title, this.icon, this.isSelected});

  String title;
  String icon;
  bool isSelected;
}

class MarketPageDetail extends StatefulWidget {
  static const routeName = '/marketDetail';

  @override
  _MarketPageDetail createState() => _MarketPageDetail();
}

class _MarketPageDetail extends State<MarketPageDetail> {
  var _userInfo;
  var itemList = [];
  String _token = null;
  int args = -1;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String _profileImageURL = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 로그인한 유저의 정보를 가져와 환영 문구와 적립 포인트 들을 초기화 한다.
    _getUserInfo();
    itemList = [];
    _getGiftInfo();
    // itemList
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    args = ModalRoute.of(context).settings.arguments;
    args++;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("쇼핑하기",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;

    return _userInfo == null
        ? Container()
        : Container(
            child: Padding(
            padding: EdgeInsets.all(15.0),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Container(
                          height: 80,
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(5),
                          child: ListTile(
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CashExchange()),
                              ).then(refreshPage)
                            },
                            leading: SizedBox(
                              width: 50.0,
                              height: 50.0,
                              child: CircleAvatar(
                                radius: 70,
                                child: ClipOval(
                                  child: _profileImageURL == null
                                      ? Image.network(
                                          'https://i.pinimg.com/474x/7d/56/56/7d5656879b5d6ed45779f89c4e89c91a.jpg',
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          _profileImageURL,
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                            title: Text('${_userInfo['nickname']}님의 적립 포인트',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text('${_userInfo['point']} Point',
                                style: TextStyle(color: Colors.black87)),
                            trailing: Wrap(
                              spacing: 12,
                              children: <Widget>[
                                SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: Icon(Icons.import_export_rounded,
                                        color: Colors.black54, size: 50.0)),
                              ],
                            ),
                          ),
                        )),
                    Padding(padding: EdgeInsets.all(8.0)),
                    Center(
                        child: Container(
                            height: 500,
                            width: 350,
                            alignment: Alignment.center,
                            child: GridView.count(
                              crossAxisCount: 1,
                              childAspectRatio:
                                  MediaQuery.of(context).size.width /
                                      (MediaQuery.of(context).size.height / 8),
                              children: List.generate(itemList.length, (index) {
                                return Center(
                                    child: Card(
                                  color: Colors.white,
                                  elevation: 5.0,
                                  child: InkWell(
                                      splashColor: kPrimaryColor,
                                      onTap: () => {
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.INFO,
                                              buttonsBorderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(2)),
                                              headerAnimationLoop: false,
                                              animType: AnimType.SCALE,
                                              title: '구매 확인',
                                              desc: '포인트로 구매하시겠습니까?',
                                              // btnCancelIcon: Icons.cancel,
                                              // btnOkIcon: Icons.check,
                                              btnOkColor: kPrimaryColor,
                                              btnCancelColor: Colors.grey,
                                              btnCancelOnPress: () {},
                                              btnOkOnPress: () {
                                                payGift(itemList[index]['id']);
                                              },
                                            )..show()
                                          },
                                      child: Center(
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ListTile(
                                                  leading: SizedBox(
                                                      width: 60.0,
                                                      height: 60.0,
                                                      child: itemList[index]
                                                                  ['image'] ==
                                                              null
                                                          ? Image.network(
                                                              'https://plog-image.s3.ap-northeast-2.amazonaws.com/q.png',
                                                              fit: BoxFit.cover,
                                                              height: 80)
                                                          : Image.network(
                                                              itemList[index]
                                                                  ['image'],
                                                              fit: BoxFit.cover,
                                                              height: 80)),
                                                  title: Text(
                                                      itemList[index]['name'],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  subtitle:
                                                      Row(children: <Widget>[
                                                    Text(
                                                      itemList[index]['price']
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  ])),
                                            ]),
                                      )),
                                ));
                              }),
                            ))),
                  ],
                ),
              ),
            ),
          ));
  }

  void _getUserInfo() async {
    _token = _token == null
        ? await FlutterSecureStorage().read(key: 'token')
        : _token;
    print('token : $_token');
    final response = await http.get('${MyApp.commonUrl}/token/user',
        headers: {'Authorization': 'Bearer $_token'});

    setState(() {
      _userInfo = json.decode(response.body)['data'];
      // print('userInfo : $_userInfo');
    });

    _getProfileImage();
  }

  void _getGiftInfo() async {
    _token = await FlutterSecureStorage().read(key: 'token');
    print('token : $_token');
    final response = await http.get('${MyApp.commonUrl}/token/gifticon/$args',
        headers: {'Authorization': 'Bearer $_token'});

    setState(() {
      itemList = json.decode(response.body)['data'];
      // print('itemList : $itemList');
      // print(itemList.length);
    });
  }

  FutureOr refreshPage(Object value) {
    _getUserInfo();
    _getGiftInfo();
  }

  void payGift(int gid) async {
    pay(gid);
  }

  Future pay(int gid) async {
    _token = await FlutterSecureStorage().read(key: 'token');
    var res;
    final response = await http.post(
      '${MyApp.commonUrl}/token/gifticon/$gid',
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
    setState(() {
      res = json.decode(response.body)['data'];
    });
    if (res != null) {
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        title: '구매 성공!',
        desc: '구매가 확인되었습니다!',
        btnOkIcon: Icons.check_circle,
        btnOkOnPress: () {
          debugPrint('OnClcik');
        },
      )..show();
    }
    else{
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        headerAnimationLoop: false,
        dialogType: DialogType.ERROR,
        title: '구매 실패...',
        desc: '포인트가 부족하지는 않으신가요?',
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red,
      )..show();
    }
    _getGiftInfo();
    _getUserInfo();
    // print('구매됨');
  }

  Future<String> _getProfileImage() async {
    StorageReference storageReference =
        _firebaseStorage.ref().child("profile/${_userInfo['id']}");

    try {
      String _src = await storageReference.getDownloadURL();

      setState(() {
        _profileImageURL = _src;
      });
      return _src;
    } on Exception catch (e) {
      // TODO
      print('에러가 났어요.');
      return null;
    }
  }
}
