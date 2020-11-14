import 'dart:async';
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:userApp/components/rounded_button.dart';
import 'package:userApp/constants.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:slimy_card/slimy_card.dart';

import 'package:userApp/main.dart';

class CashExchange extends StatefulWidget {
  static const routeName = '/cashexchange';

  @override
  _CashExchange createState() => _CashExchange();
}

class _CashExchange extends State<CashExchange> {
  var _userInfo;
  var detail;
  String _token = null;

  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String _profileImageURL = null;

  final _valueList = ['5000', '10000', '15000', '20000', '25000', '30000'];
  var _selectedValue = '5000';

  final myBank = TextEditingController();
  final myBankNum = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 로그인한 유저의 정보를 가져와 환영 문구와 적립 포인트 들을 초기화 한다.
    _getUserInfo();
    detail;
    // _getPurchaseDetailInfo();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // args = ModalRoute.of(context).settings.arguments;
    // args++;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("현금 인출",
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
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
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
                              height: 150,
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(5),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text('현재 적립 포인트',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30)),
                                    SizedBox(
                                      width: 10,
                                      height: 10,
                                    ),
                                    Text('${_userInfo['point']} Point',
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 45,
                                            fontWeight: FontWeight.bold)),
                                  ]))),
                      Padding(padding: EdgeInsets.all(8.0)),
                      Center(
                          child: Container(
                        height: 500,
                        width: 400,
                        alignment: Alignment.topCenter,
                        child: Column(children: <Widget>[
                          Text('출금할 포인트와',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30)),
                          Text('계좌를 입력하세요.',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30)),
                          SizedBox(
                            width: 20,
                            height: 20,
                          ),

                          TextFormField(
                            controller: myBank,
                            decoration: new InputDecoration(
                              labelText: "은행 정보 입력  ex) 카카오뱅크, 신한은행, ...",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                            height: 20,
                          ),
                          TextFormField(
                            controller: myBankNum,
                            decoration: new InputDecoration(
                              labelText: "'-' 를 제외하고 계좌번호 입력",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                            height: 20,
                          ),
                          DropdownButton(
                            value: _selectedValue,
                            items: _valueList.map(
                              (value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value + ' 원', style: TextStyle(fontSize: 20),),
                                );
                              },
                            ).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedValue = value;
                              });
                            },
                          ),
                          SizedBox(
                            width: 10,
                            height: 10,
                          ),
                          RoundedButton(
                            text: "확인",
                            press: () => {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.INFO,
                                buttonsBorderRadius:
                                BorderRadius.all(
                                    Radius.circular(2)),
                                headerAnimationLoop: false,
                                animType: AnimType.SCALE,
                                title: '현금 인출 확인',
                                desc: myBank.text + '의' +  myBankNum.text + '으로\n포인트 차감 후 현금으로 인출 하시겠습니까?',
                                // btnCancelIcon: Icons.cancel,
                                // btnOkIcon: Icons.check,
                                btnOkColor: kPrimaryColor,
                                btnCancelColor: Colors.grey,
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {
                                  checkWithdraw(int.parse(_selectedValue));
                                },
                              )..show()
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => CashExchange()),
                              // ).then(refreshPage)
                            },
                          ),

                        ]),
                      ))
                    ],
                  ),
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

  void checkWithdraw(int amount) async {
    withdraw(amount);
  }

  Future withdraw(int amount) async {
    _token = await FlutterSecureStorage().read(key: 'token');
    var res;
    final response = await http.post(
      '${MyApp.commonUrl}/token/user/cash/$amount',
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
        title: '요청 전송',
        desc: '관리자에게 요청이 전송 되었습니다!',
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
        title: '요청 실패...',
        desc: '포인트가 부족하지는 않으신가요?',
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red,
      )..show();
    }
    _getUserInfo();
  }

  FutureOr refreshPage(Object value) {
    _getUserInfo();
    // _getPurchaseDetailInfo();
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
