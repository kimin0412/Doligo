import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:userApp/Screens/Signup/signup_screen.dart';
import 'package:userApp/Screens/Login/login_screen.dart';
import 'package:userApp/Screens/Signup/components/background.dart';
import 'package:userApp/components/already_have_an_account_acheck.dart';
import 'package:userApp/components/rounded_button.dart';
import 'package:userApp/constants.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

class Choice {
  Choice({this.title, this.icon, this.isSelected});
  String title;
  IconData icon;
  bool isSelected;
}

class SignUpScreen3 extends StatefulWidget {
  static const String routeName = '/signUp3';

  @override
  _SignUpScreen3State createState() => _SignUpScreen3State();
}

class _SignUpScreen3State extends State<SignUpScreen3> {
  bool selected = false;
  List<Choice> choices;

  @override
  void initState() {
    super.initState();
    choices = [
      Choice(title: '소매', icon: Icons.local_grocery_store, isSelected:false),
      Choice(title: '생활 서비스', icon: Icons.local_laundry_service, isSelected:false),
      Choice(title: '부동산', icon: Icons.house, isSelected:false),
      Choice(title: '관광/여가/오락', icon: Icons.airplanemode_active, isSelected:false),
      Choice(title: '숙박', icon: Icons.hotel, isSelected:false),
      Choice(title: '스포츠', icon: Icons.directions_run, isSelected:false),
      Choice(title: '음식', icon: Icons.fastfood, isSelected:false),
      Choice(title: '학문/교육', icon: Icons.school, isSelected:false)
    ];
  }

  @override
  Widget build(BuildContext context) {
    final SignupArgument args = ModalRoute.of(context).settings.arguments;
    Size size = MediaQuery.of(context).size;
    final TextStyle textStyle = Theme.of(context).textTheme.display1;

    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "관심 있는 전단지 종류를\n선택해주세요",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.03),

              Container(
                  height: 400,
                  width: 300,
                  alignment: Alignment.center,
                  child:
                  GridView.count(
                    crossAxisCount: 2 ,
                    children: List.generate(choices.length, (index) {
                      return Center(
                          child:
                          Card(
                            color: Colors.white,
                            elevation: 10.0,
                            child: InkWell(
                                splashColor: kPrimaryColor,
                                onTap: () => setState(() => choices[index].isSelected = !choices[index].isSelected),
                                child: Center(
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child:
                                            choices[index].isSelected ? Icon(choices[index].icon, size: 80.0, color: kPrimaryColor) : Icon(choices[index].icon, size: 80.0, color: textStyle.color)),
                                        Text(choices[index].title, style: new TextStyle(fontWeight: FontWeight.bold)),
                                      ]),
                                )
                            ),
                          ));
                    }),
                  )
              ),

              RoundedButton(
                text: "회원가입",
                press: () {


                  // choice 상태 확인
                  List<String> prefercode = List<String>();
                  prefercode.add('D');
                  prefercode.add('F');
                  prefercode.add('L');
                  prefercode.add('N');
                  prefercode.add('O');
                  prefercode.add('P');
                  prefercode.add('Q');
                  prefercode.add('R');

                  for(int i = 0, j = 0; i < choices.length; i++, j++) {
                    if(!choices[i].isSelected) {
                      prefercode.removeAt(j--);
                    }
                  }

                  // http 통신 요청
                  signUp(args, prefercode);

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

  Future<int> signUp(SignupArgument args, List<String> prefercode) async {
    final response = await http.post('${MyApp.commonUrl}/user/signup',
      body: jsonEncode(
          {
            "age": DateTime.now().year - args.selectedYear + 1,
            "email": args.email,
            "gender": args.isFemail,
            "id": 0,
            "nickname": args.nickname,
            "password": args.passwordCheck,
            "point": 0,
            "prefercode": prefercode,
            "preferences": [
              {
                "id": 0,
                "isprefer": 0,
                "mid": 0,
                "mname": "string",
                "uid": 0
              }
            ]
          }
      ),
      headers: {'Content-Type' : "application/json"},
    );

    final body = json.decode(response.body);
    final header = response.headers['token'];

    print('response : $body');
    print('response : $header');

    if(response.statusCode == 200 || response.statusCode == 202) {
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        title: '회원가입 성공!',
        desc: '${args.nickname}님 회원가입을 축하합니다!',
        btnOkIcon: Icons.check_circle,
        btnOkOnPress: () {
          debugPrint('OnClcik');
        },
      )..show();
    } else {
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        headerAnimationLoop: false,
        dialogType: DialogType.ERROR,
        title: '회원가입 실패...',
        desc: '회원가입에 실패하였습니다.\n잠시 후 다시 시도해주세요!',
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red,
      )..show();
    }

    return response.statusCode;
  }
}
