import 'dart:convert';

import 'package:dolligo_ads_manager/constants.dart';
import 'package:dolligo_ads_manager/models/advertiser_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ReviseAdvPage extends StatefulWidget {
  @override
  _ReviseAdvPageState createState() => _ReviseAdvPageState();
}

class _ReviseAdvPageState extends State<ReviseAdvPage> {
  Advertiser _advertiser = Advertiser();
  TextEditingController _marketnameController;
  TextEditingController _marketaddressController;

  @override
  void initState(){
    super.initState();
    _getAdvertiserInfo();
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
  Widget _buildBody() {
    Size size = MediaQuery.of(context).size;
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: size.height * 0.03),
              Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
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
                      Text('${_advertiser.marketname.length}/100')
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 5)
              ),
              Container(
                  decoration: new BoxDecoration(color: Colors.white),
                  child: TextField(
                    controller: _marketnameController,
                    cursorColor: kPrimaryColor,
                    style: TextStyle(fontSize: 15),
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.all(15.0),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _advertiser.marketname = value;
                      });
                    },
                  )
              ),
              Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
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
                      Text('${_advertiser.marketaddress.length}/100')
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 5)
              ),
              Container(
                  decoration: new BoxDecoration(color: Colors.white),
                  child: TextField(
                    controller: _marketaddressController,
                    cursorColor: kPrimaryColor,
                    style: TextStyle(fontSize: 15),
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.all(15.0),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _advertiser.marketaddress = value;
                      });
                    },
                  )
              ),
            ]
        )
    );
  }

  void _getAdvertiserInfo() async{
    String jwt = await FlutterSecureStorage().read(key: 'jwt');

    var response = await http.get('$SERVER_IP/api/token/advertiser',
        headers: {'Authorization' : 'Bearer $jwt'});

    _advertiser = Advertiser.fromJson(jsonDecode(response.body)['data']);

    setState(() {
      _marketnameController = TextEditingController(text: _advertiser.marketname);
      _marketaddressController = TextEditingController(text: _advertiser.marketaddress);
    });

    print(jwt);
  }
}

