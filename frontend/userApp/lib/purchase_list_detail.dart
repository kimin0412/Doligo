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
import 'package:slimy_card/slimy_card.dart';

import 'package:userApp/main.dart';

class PurchaseListDetail extends StatefulWidget {
  static const routeName = '/purchaselistdetail';

  @override
  _PurchaseListDetail createState() => _PurchaseListDetail();
}

class _PurchaseListDetail extends State<PurchaseListDetail> {
  var _userInfo;
  var detail;
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
    detail;
    _getPurchaseDetailInfo();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    args = ModalRoute.of(context).settings.arguments;
    // args++;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("기프티콘 구매 목록",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _buildBody(),
    );
  }

  Widget topCardWidget() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 150.0,
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
                width: 300.0,
                height: 350.0,
                child: detail['gifticon']['image'] == null
                    ? Image.network(
                        'https://plog-image.s3.ap-northeast-2.amazonaws.com/q.png')
                    : Image.network(detail['gifticon']['image'])),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              detail['gifticon']['name'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${detail['gifticon']['validDate']} 까지 사용가능',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          )
        ]);
  }

  Widget bottomCardWidget() {
    return Text(
      detail['code'] == null ? '바코드 정보가 없습니다.' : detail['code'],
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
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
                      width: 400,
                      alignment: Alignment.center,
                      child: ListView(
                        children: <Widget>[
                          SlimyCard(
                            color: kPrimaryColor,
                            width: 280,
                            topCardHeight: 330,
                            bottomCardHeight: 100,
                            borderRadius: 15,
                            topCardWidget: topCardWidget(),
                            bottomCardWidget: bottomCardWidget(),
                            slimeEnabled: true,
                          ),
                          // ),
                        ],
                      ),
                    )),
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
    });
  }

  void _getPurchaseDetailInfo() async {
    _token = await FlutterSecureStorage().read(key: 'token');
    print('token : $_token');
    print('args : $args');
    final response = await http.get(
        '${MyApp.commonUrl}/token/gifticon/purchase/detail/$args',
        headers: {'Authorization': 'Bearer $_token'});

    setState(() {
      // print(json.decode(response.body)['data']);
      detail = json.decode(response.body)['data'];
      print('detail : $detail');
      // print(itemList.length);
    });
  }

  FutureOr refreshPage(Object value) {
    _getUserInfo();
    _getPurchaseDetailInfo();
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
