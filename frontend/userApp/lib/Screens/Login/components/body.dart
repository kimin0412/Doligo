import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:userApp/Screens/Login/components/background.dart';
import 'package:userApp/Screens/Signup/signup_screen.dart';
import 'package:userApp/components/already_have_an_account_acheck.dart';
import 'package:userApp/components/rounded_button.dart';
import 'package:userApp/components/rounded_input_field.dart';
import 'package:userApp/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:userApp/home_page.dart';
import 'package:userApp/main.dart';
import 'package:userApp/tap_page.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "LOGIN",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                //"assets/icons/login.svg",
                "assets/icons/logo_4.svg",
                height: size.height * 0.3,
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "이메일을 입력해주세요.",
                onChanged: (value) {
                  _email = value;
                },
              ),
              RoundedPasswordField(
                onChanged: (value) {
                  _password = value;
                },
              ),
              RoundedButton(
                text: "LOGIN",
                press: signIn,
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignUpScreen();
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

  Future<int> signIn() async {
    final response = await http.post('${MyApp.commonUrl}/user/signin',
      body: jsonEncode(
          {
            'email' : _email,
            'password' : _password
          }
      ),
      headers: {'Content-Type' : "application/json"},
    );

    final body = json.decode(response.body);
    final header = response.headers['token'];

    print('response : $body');
    print('response : $header');


    if(response.statusCode == 200 || response.statusCode == 202) {
      FlutterSecureStorage().write(key: 'token', value: response.headers['token']); // 토큰 저장
    }

    final responseCode = response.statusCode;
    if(responseCode == 202 || responseCode == 200) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) => TabPage()), (route) => false
      );
    } else if(responseCode == 400) {
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        headerAnimationLoop: false,
        dialogType: DialogType.WARNING,
        title: '비밀번호가 일치하지 않습니다!',
        desc: '비밀번호를 확인해주세요.',
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
        dialogType: DialogType.WARNING,
        title: '해당 아이디가 존재하지 않습니다!',
        desc: '아이디를 확인해주세요.',
        btnOkIcon: Icons.check_circle,
        btnOkOnPress: () {
          debugPrint('OnClcik');
        },
      )..show();
    }

    return response.statusCode;
  }


}

