import 'dart:convert';

import 'package:dolligo_ads_manager/components/already_have_an_account_acheck.dart';
import 'package:dolligo_ads_manager/components/rounded_button.dart';
import 'package:dolligo_ads_manager/components/rounded_input_field.dart';
import 'package:dolligo_ads_manager/components/rounded_password_field.dart';
import 'package:dolligo_ads_manager/constants.dart';
import 'package:dolligo_ads_manager/screens/login/components/background.dart';
import 'package:dolligo_ads_manager/screens/signup/signup_screen.dart';
import 'package:dolligo_ads_manager/screens/tap_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
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
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              controller: emailController,
              hintText: "이메일을 입력해주세요.",
              onChanged: (value) {

              },
            ),
            RoundedPasswordField(
              controller: pwController,
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                String a = pwController.text;
                print(a);
                login();
              },
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
    );
  }

  void login() async{
    print(emailController.text);

    final response = await http.post(
      "$SERVER_IP/api/advertiser/signin",
      body: jsonEncode(
        {
          'email': emailController.text,
          'password': pwController.text,
        },
      ),
      headers: {'Content-Type': "application/json"},
    );

    if(200 <= response.statusCode && response.statusCode < 300){
      await FlutterSecureStorage().write(key: 'jwt', value: response.headers['token']);

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return TabPage();
        },
      ), (r) => false);

    } else if(response.statusCode == 400) {
      showToast('올바르지 않은 로그인 정보입니다. 다시 입력해주세요.');
    } else {
      showToast('네트워크 상태를 확인해주세요.');
    }
  }

  void showToast(String message){
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT
    );
  }
}
