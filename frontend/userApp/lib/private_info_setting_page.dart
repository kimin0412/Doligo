import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'Screens/Signup/signup_screen_2.dart';
import 'constants.dart';
import 'main.dart';

import 'package:firebase_storage/firebase_storage.dart';

class PrivateInfoSettingPage extends StatefulWidget {
  static const String routeName = '/privateInfoSetting';

  @override
  _PrivateInfoSettingPageState createState() => _PrivateInfoSettingPageState();
}

class _PrivateInfoSettingPageState extends State<PrivateInfoSettingPage> {
  var _userInfo;
  String _token;

  bool isChanged;
  bool isProfileChanged;

  String _nickname;

  List<Gender> genders = new List<Gender>();

  bool _isFemale;

  int check;

  int _selectedYear;

  List<int> userYears = <int>[
    1960, 1961, 1962, 1963, 1964, 1965, 1966, 1967, 1968, 1969,
    1970, 1971, 1972, 1973, 1974, 1975, 1976, 1977, 1978, 1979,
    1980, 1981, 1982, 1983, 1984, 1985, 1986, 1987, 1988, 1989,
    1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999,
    2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009
  ];


  File _image;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String _profileImageURL = null;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isChanged = false;
    isProfileChanged = false;

    _getUserInfo();

    genders.add(new Gender("Male", MdiIcons.genderMale, false));
    genders.add(new Gender("Female", MdiIcons.genderFemale, false));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('내 정보 수정'),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_outlined),
          onTap: () {
            if (isChanged) {
              showAlertDialog(context, 'exit');
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: GestureDetector(
              child: Icon(Icons.save, color: Color(isDisabled()),),
              onTap: isChanged && _nickname.length > 0 ? () {
                showAlertDialog(context, 'save');
              } : null,
            ),
          )
        ],
      ),
      body: _userInfo == null ? Container() : _buildBody(),
    );
  }

  int isDisabled() =>
      isChanged && _nickname.length > 0 ? 0xffffffff : 0x77ffffff;

  void showAlertDialog(BuildContext context, String s) async {
    String _title = '내 정보 수정';
    String _content = s == 'exit' ? '저장하지 않고 나가시겠습니까?' : '저장하시겠습니까?';

    AwesomeDialog(
      context: context,
      animType: AnimType.SCALE,
      headerAnimationLoop: false,
      dialogType: DialogType.INFO,
      title: _title,
      desc: _content,
      btnOkIcon: Icons.check_circle,
      btnCancelOnPress: () {
        check = 400;
        print('check : $check');
        debugPrint('cancelClcik');
      },
      btnOkOnPress: () {
        check = 200;
        print('check : $check');
        debugPrint('OnClcik');
      },
    )..show().then((value) async {
      if(check == 200) {
        if(s == 'save') {
          final response = await http.put('${MyApp.commonUrl}/token/user',
            headers: {
              'Authorization' : 'Bearer $_token',
              'Content-Type' : "application/json"
            },
            body: jsonEncode(
                {
                  "age": _selectedYear,
                  "email": _userInfo['email'],
                  "gender": _isFemale,
                  "id": _userInfo['id'],
                  "nickname": _nickname,
                  "password": null,
                  "point": _userInfo['point'],
                  "prefercode": _userInfo['prefercode'],
                  "preferences": _userInfo['preferences']
                }
            ),
          );

          if(response.statusCode == 200 || response.statusCode == 202) {
            await _uploadProfileImage();    // 파이어베이스에 이미지 반영
            Fluttertoast.showToast(
                msg: '저장되었습니다.',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0
            );
          } else {
            print('Code : ${response.statusCode}');
          }
        }
        Navigator.pop(context);
      }
    });
  }

  Widget _buildBody() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 70,
                        child: ClipOval(
                          child: isProfileChanged ? Image.file(_image, width: 140, height: 140, fit: BoxFit.cover,) :
                          _profileImageURL == null ?
                          Image.network(
                            'https://i.pinimg.com/474x/7d/56/56/7d5656879b5d6ed45779f89c4e89c91a.jpg', height: 140,
                            width: 140,
                            fit: BoxFit.cover,
                          ) :
                          Image.network(
                            _profileImageURL, height: 140,
                            width: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(bottom: 1, right: 1, child: Container(
                        height: 40, width: 40,
                        child: GestureDetector(
                          child: Icon(Icons.add_a_photo, color: Colors.white,),
                          onTap: _getProfileImage,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                      ))
                    ],
                  ),
                  SizedBox(height: 5,),
                  Text(_nickname, style: TextStyle(fontSize: 20),),
                  SizedBox(height: 5,),
                  Text(_userInfo['email'], style: TextStyle(fontSize: 15),),
                  SizedBox(height: 15,),
                  Container(
                    child: Text('기본정보 변경'),
                    alignment: Alignment.centerLeft,
                  ),
                  TextFormField(
                    initialValue: _nickname,
                    onChanged: (value) {
                      _nickname = value;
                      isChanged = true;
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: '닉네임',
                    ),
                    validator: (String value) {
                      return value.contains('@')
                          ? 'Do not use the @ char.'
                          : null;
                    },
                  ),
                  SizedBox(height: 15,),
                  Container(
                    child: Text('성별'),
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                      height: 100,
                      width: 600,
                      alignment: Alignment.center,
                      child:
                      ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: genders.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              splashColor: kPrimaryColor,
                              onTap: () {
                                setState(() {
                                  if (index == 2) {
                                    Fluttertoast.showToast(
                                        msg: '추후에 업데이트 될 예정입니다!\n현재는 데이터의 수집을 위해\n남/여 중에 선택해주세요! 😢',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.grey,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  } else {
                                    genders.forEach((gender) =>
                                    gender.isSelected = false);
                                    genders[index].isSelected = true;
                                    if (index == 0) {
                                      _isFemale = false; // 남자면 false
                                      isChanged = true;
                                    }
                                    else if (index == 1) {
                                      _isFemale = true; // 여자면 true
                                      isChanged = true;
                                    }
                                  }
                                });
                              },
                              child: CustomRadio(genders[index]),
                            );
                          }
                      )
                  ), // gender selector
                  SizedBox(height: 15,),
                  Container(
                    child: Text('출생년도 변경'),
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                      height: 100,
                      width: 600,
                      alignment: Alignment.center,
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DropdownButton<int>(
                            hint: Text("출생년도를 골라주세요."),
                            value: _selectedYear,
                            onChanged: (int Value) {
                              setState(() {
                                _selectedYear = Value;
                                isChanged = true;
                              });
                            },
                            items: userYears.map((int year) {
                              return DropdownMenuItem<int>(
                                value: year,
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(width: 10,),
                                    Text(
                                      year.toString(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          // SizedBox(width: 10,),
                          Text('* 나이 : ${DateTime.now().year - _selectedYear + 1}살')
                        ],
                      )), // year choice
                  // SizedBox(height: 15,),
                  // Container(
                  //   child: Text('비밀번호 변경'),
                  //   alignment: Alignment.centerLeft,
                  // ),
                  // TextFormField(
                  //   decoration: const InputDecoration(
                  //     icon: Icon(Icons.vpn_key),
                  //     labelText: '현재 비밀번호',
                  //   ),
                  //   onSaved: (String value) {
                  //     // This optional block of code can be used to run
                  //     // code when the user saves the form.
                  //   },
                  //   validator: (String value) {
                  //     return value.contains('@')
                  //         ? 'Do not use the @ char.'
                  //         : null;
                  //   },
                  // ),
                  // TextFormField(
                  //   decoration: const InputDecoration(
                  //     icon: Icon(Icons.vpn_key),
                  //     labelText: '새로운 비밀번호',
                  //   ),
                  //   onSaved: (String value) {
                  //     // This optional block of code can be used to run
                  //     // code when the user saves the form.
                  //   },
                  //   validator: (String value) {
                  //     return value.contains('@')
                  //         ? 'Do not use the @ char.'
                  //         : null;
                  //   },
                  // ),
                  // TextFormField(
                  //   decoration: const InputDecoration(
                  //     icon: Icon(Icons.vpn_key),
                  //     labelText: '새로운 비밀번호 체크',
                  //   ),
                  //   onSaved: (String value) {
                  //     // This optional block of code can be used to run
                  //     // code when the user saves the form.
                  //   },
                  //   validator: (String value) {
                  //     return value.contains('@')
                  //         ? 'Do not use the @ char.'
                  //         : null;
                  //   },
                  // ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFirebase() {
    // return StreamBuilder(
    //   stream: Firestore.instance.collection('post').snapshots(),
    //   builder: (context, snapshot) {
    //     if (!snapshot.hasData) {
    //       return Center(child: CircularProgressIndicator());
    //     }
    //
    //     var items = snapshot.data.documents ?? []; // null이 안되게끔 처리하는 기법
    //
    //     return GridView.builder(gridDelegate: null, itemBuilder: null);
    //   },
    // );
  }


  void _getUserInfo() async {
    _token = _token == null ? await FlutterSecureStorage().read(key: 'token') : _token;
    final response = await http.get('${MyApp.commonUrl}/token/user',
        headers: {
          'Authorization': 'Bearer $_token'
        }
    );

    setState(() {
      _userInfo = json.decode(response.body)['data'];
      print('userInfo : $_userInfo');
      _nickname = _userInfo['nickname'];
      genders[_userInfo['gender'] ? 1 : 0].isSelected = true;
      _selectedYear = _userInfo['age'];
    });

    _downloadProfileImage();
  }

  Future<String> _downloadProfileImage() async {
    StorageReference storageReference = _firebaseStorage.ref().child("profile/${_userInfo['id']}");

    try {
      String _src = await storageReference.getDownloadURL();

      setState(() {
        _profileImageURL = _src;
      });
      return _src;
    } on Exception catch (e) {
      // TODO
      print('프로필 사진을 파이어베이스에서 가져오는 걸 실패하였습니다..!');
      return null;
    }

  }

  Future _getProfileImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if(image != null) {
      setState(() {
        _image = image;
        isProfileChanged = true;
        isChanged = true;
      });
    } else {
      print('이미지가 선택되지 않음');
    }
  }

  Future _uploadProfileImage() async {
    if(isProfileChanged) {
      // 프로필 사진을 업로드할 경로와 파일명을 정의. 사용자의 uid를 이용하여 파일명의 중복 가능성 제거
      StorageReference storageReference =
      _firebaseStorage.ref().child("profile/${_userInfo['id']}");

      // 파일 업로드
      StorageUploadTask storageUploadTask = storageReference.putFile(_image);

      // 파일 업로드 완료까지 대기
      await storageUploadTask.onComplete;

      // 업로드한 사진의 URL 획득
      String downloadURL = await storageReference.getDownloadURL();

      // 업로드된 사진의 URL을 페이지에 반영
      setState(() {
        _profileImageURL = downloadURL;
      });
      return _profileImageURL;
    }
    return _profileImageURL;
  }
}
