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
import 'package:userApp/market_page_detail.dart';
import 'package:userApp/point_history_page.dart';
import 'package:userApp/purchase_list.dart';

import 'main.dart';

class Menus {
  static const String purchaseList = '구매 목록'; // 삭제
  static const String pointLog = '포인트 적립 내역'; // 차단

  static const List<String> choices = <String>[purchaseList, pointLog];
}

class Category {
  Category({this.title, this.icon, this.isSelected});

  String title;
  String icon;
  bool isSelected;
}

class MarketPage extends StatefulWidget {
  static const routeName = '/market';

  @override
  _MarketPage createState() => _MarketPage();
}

class _MarketPage extends State<MarketPage> {
  var _userInfo;
  List<Category> categoryList;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String _profileImageURL = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 로그인한 유저의 정보를 가져와 환영 문구와 적립 포인트 들을 초기화 한다.
    _getUserInfo();

    categoryList = [
      Category(
          title: '카페/베이커리',
          icon: "assets/icons/category/cafe.svg",
          isSelected: false),
      Category(
          title: '외식쿠폰',
          icon: "assets/icons/category/dinner.svg",
          isSelected: false),
      Category(
          title: '편의점',
          icon: "assets/icons/category/24.svg",
          isSelected: false),
      Category(
          title: '뷰티',
          icon: "assets/icons/category/cosmetic.svg",
          isSelected: false),
      Category(
          title: '문화생활',
          icon: "assets/icons/category/ticket.svg",
          isSelected: false),
      Category(
          title: '여행',
          icon: "assets/icons/category/travel.svg",
          isSelected: false),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("쇼핑하기",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Menus.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            icon: Icon(Icons.menu),
          )
        ],
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
                          height: 100,
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
                            crossAxisCount: 2,
                            children:
                                List.generate(categoryList.length, (index) {
                              return Center(
                                  child: Card(
                                color: Colors.white,
                                elevation: 10.0,
                                child: InkWell(
                                    splashColor: kPrimaryColor,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        MarketPageDetail.routeName,
                                        arguments: index,
                                      ).then(refreshPage);
                                    },
                                    child: Center(
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                width: 80.0,
                                                height: 80.0,
                                                child: categoryList[index]
                                                        .isSelected
                                                    ? SvgPicture.asset(
                                                        categoryList[index]
                                                            .icon,
                                                        height: 80)
                                                    : SvgPicture.asset(
                                                        categoryList[index]
                                                            .icon,
                                                        height: 80)),
                                            Text(categoryList[index].title,
                                                style: new TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ]),
                                    )),
                              ));
                            }),
                          )),
                    ), // 쿠폰 ListView
                  ],
                ),
              ),
            ),
          ));
  }

  void _getUserInfo() async {
    String _token = await FlutterSecureStorage().read(key: 'token');
    print('token : $_token');
    final response = await http.get('${MyApp.commonUrl}/token/user',
        headers: {'Authorization': 'Bearer $_token'});

    setState(() {
      _userInfo = json.decode(response.body)['data'];
      // print('userInfo : $_userInfo');
    });

    _getProfileImage();
  }

  FutureOr refreshPage(Object value) {
    _getUserInfo();
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

  void choiceAction(String choice) async {
    switch (choice) {
      case Menus.purchaseList:
        print('$choice WORKING');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PurchaseList()),
        );
        // await dislike(choice);
        break;
      case Menus.pointLog:
        print('$choice WORKING');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PointHistoryPage()),
        );
        // await dislike(choice);
        break;
    }
  }
}
