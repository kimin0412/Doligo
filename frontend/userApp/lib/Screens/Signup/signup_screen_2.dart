import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:userApp/Screens/Login/login_screen.dart';
import 'package:userApp/Screens/Signup/components/background.dart';
import 'package:userApp/components/already_have_an_account_acheck.dart';
import 'package:userApp/components/rounded_button.dart';
import 'package:userApp/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'signup_screen.dart';
import 'signup_screen_3.dart';

class SignUpScreen2 extends StatefulWidget {
  static const String routeName = '/signUp2';

  @override
  _SignUpScreen2State createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {

  bool _isFemale;    // true : 여자, false : 남자

  int _selectedYear;
  String _selectedSi;
  String _selectedGu;

  List<int> userYears = <int>[
    1960, 1961, 1962, 1963, 1964, 1965, 1966, 1967, 1968, 1969,
    1970, 1971, 1972, 1973, 1974, 1975, 1976, 1977, 1978, 1979,
    1980, 1981, 1982, 1983, 1984, 1985, 1986, 1987, 1988, 1989,
    1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999,
    2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009
  ];

  List<String> userSi = <String>[
    '서울'
  ];

  List<String> userGu = <String>[
    '종로구', '중구', '용산구', '성동구', '광진구', '동대문구', '중랑구', '성북구', '강북구', '도봉구', '노원구', '은평구',
    '서대문구', '마포구', '양천구', '강서구', '구로구', '금천구', '영등포구', '동작구', '관악구', '서초구', '강남구', '송파구', '강동구'
  ];


  List<Gender> genders = new List<Gender>();

  @override
  void initState() {
    super.initState();
    genders.add(new Gender("Male", MdiIcons.genderMale, false));
    genders.add(new Gender("Female", MdiIcons.genderFemale, false));
    genders.add(new Gender("Others", MdiIcons.genderTransgender, false));
  }


  @override
  Widget build(BuildContext context) {
    final SignupArgument args = ModalRoute.of(context).settings.arguments;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "추가정보 입력",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              // Text('성별을 입력해주세요.', textAlign: TextAlign.left,),
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
                              if(index == 2) {
                                Fluttertoast.showToast(
                                    msg: '당신은 사람이 아닙니까?',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              } else {
                                genders.forEach((gender) => gender.isSelected = false);
                                genders[index].isSelected = true;
                                if(index == 0) _isFemale = false;      // 남자면 false
                                else if(index == 1) _isFemale = true;  // 여자면 true
                              }
                            });
                          },
                          child: CustomRadio(genders[index]),
                        );
                      }
                  )
              ),

              Container(
                  height: 100,
                  width: 600,
                  alignment: Alignment.center,
                  child:
                  DropdownButton<int>(
                    hint:  Text("출생년도를 골라주세요."),
                    value: _selectedYear,
                    onChanged: (int Value) {
                      setState(() {
                        _selectedYear = Value;
                      });
                    },
                    items: userYears.map((int year) {
                      return  DropdownMenuItem<int>(
                        value: year,
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 10,),
                            Text(
                              year.toString(),
                              style:  TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  )),

              Container(
                  height: 100,
                  width: 600,
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DropdownButton<String>(
                          hint:  Text("시"),
                          value: _selectedSi,
                          onChanged: (String Value) {
                            setState(() {
                              _selectedSi = Value;
                            });
                          },
                          items: userSi.map((String si) {
                            return  DropdownMenuItem<String>(
                              value: si,
                              child: Row(
                                children: <Widget>[
                                  SizedBox(width: 10,),
                                  Text(
                                    si,
                                    style:  TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        DropdownButton<String>(
                          hint:  Text("구"),
                          value: _selectedGu,
                          onChanged: (String Value) {
                            setState(() {
                              _selectedGu = Value;
                            });
                          },
                          items: userGu.map((String gu) {
                            return  DropdownMenuItem<String>(
                              value: gu,
                              child: Row(
                                children: <Widget>[
                                  SizedBox(width: 10,),
                                  Text(
                                    gu,
                                    style:  TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                      ])
              ),

              RoundedButton(
                text: "다음",
                press: () {
                  args.isFemail = _isFemale;
                  args.selectedYear = _selectedYear;
                  args.selectedGu = _selectedGu;
                  args.selectedSi = _selectedSi;
                  print('args : ${args.toString()}');
                  Navigator.pushNamed(
                    context,
                    SignUpScreen3.routeName,
                    arguments: args,
                  );
                },
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class Gender {
  String name;
  IconData icon;
  bool isSelected;

  Gender(this.name, this.icon, this.isSelected);
}

class CustomRadio extends StatelessWidget {
  Gender _gender;
  CustomRadio(this._gender);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: _gender.isSelected ? Color(0xFF8B6DFF) : Colors.white,
        child: Container(
          height: 80,
          width: 80,
          alignment: Alignment.center,
          margin: new EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                _gender.icon,
                color: _gender.isSelected ? Colors.white : Colors.grey,
                size: 40,
              ),
              SizedBox(height: 10),
              Text(
                _gender.name,
                style: TextStyle(
                    color: _gender.isSelected ? Colors.white : Colors.grey),
              )
            ],
          ),
        ));
  }
}