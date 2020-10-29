import 'package:flutter/material.dart';

class MyCouponQRCodePage extends StatefulWidget {
  static const routeName = '/myCouponQRCode';

  @override
  _MyCouponQRCodePageState createState() => _MyCouponQRCodePageState();
}

class _MyCouponQRCodePageState extends State<MyCouponQRCodePage> {

  var _listviewData = [
    {'heading' : '사이다 무료', 'storeName' : '우리집 국밥 쿠폰',
      'content1' : '삼계탕 주문시', 'content2' : '최소주문금액 300,000원', 'expirationDate' : '2020. 10. 10 - 2020. 10. 23', 'isDisable' : 'false'},
    {'heading' : '사이다 무료', 'storeName' : '우리집 국밥 쿠폰',
      'content1' : '삼계탕 주문시', 'content2' : '최소주문금액 300,000원', 'expirationDate' : '2020. 10. 10 - 2020. 10. 23', 'isDisable' : 'false'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("쿠폰함",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50,),
              Center(
                child: Container(
                  height: 900,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _listviewData == null ? 0 : _listviewData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: SizedBox(
                          width: 10,
                          height: 180,
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 16, left: 20, bottom: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        child: Text(_listviewData[index]['heading'],
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff7C4CFF),
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        width: 200,
                                      ),  // 메인혜택내용
                                      SizedBox(height: 25,),
                                      Container(
                                        width: 200,
                                        child: Text(_listviewData[index]['storeName'],
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),  // 가게이름
                                      Container(
                                        width: 200,
                                        child: Text(_listviewData[index]['content1'],
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xffEA9836),
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),  // 내용1
                                      Container(
                                        width: 200,
                                        alignment: Alignment.bottomLeft,
                                        child: Text(_listviewData[index]['content2'] + '\n사용기간 ' + _listviewData[index]['expirationDate'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xffA1A1A1),
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),  // 내용2 및 사용기간
                                    ],
                                  ),  // 쿠폰 내용
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),  // 쿠폰 ListView
            ],
          ),
        ),
      ),
    );
  }
}
