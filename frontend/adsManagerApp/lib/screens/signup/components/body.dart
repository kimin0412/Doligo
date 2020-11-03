import 'package:dolligo_ads_manager/components/already_have_an_account_acheck.dart';
import 'package:dolligo_ads_manager/components/rounded_button.dart';
import 'package:dolligo_ads_manager/components/rounded_input_field.dart';
import 'package:dolligo_ads_manager/components/rounded_password_field.dart';
import 'package:dolligo_ads_manager/components/rounded_password_field_check.dart';
import 'package:dolligo_ads_manager/models/advertiser_model.dart';
import 'package:dolligo_ads_manager/screens/login/login_screen.dart';
import 'package:dolligo_ads_manager/screens/signup/components/background.dart';
import 'package:dolligo_ads_manager/screens/signup/components/or_divider.dart';
import 'package:dolligo_ads_manager/screens/signup/components/social_icon.dart';
import 'package:dolligo_ads_manager/screens/signup/signup_screen_2.dart';
import 'package:dolligo_ads_manager/screens/signup/signup_screen_4.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Advertiser advertiser = Advertiser();
  final emailController = TextEditingController();
  final pw1Controller = TextEditingController();
  final pw2Controller = TextEditingController();
  bool emailBool = false;
  bool pw1Bool = false;
  bool pw2Bool = false;
  bool pw2Bool2 = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              controller: emailController,
              hintText: "이메일을 입력해주세요.",
              onChanged: (value) {
                if(emailBool) {
                  setState(() {
                    emailBool = false;
                  });
                }
              },
            ),
            Visibility(
              child: Text('필수 입력 항목입니다.',  style: TextStyle(color: Colors.red)),
              visible: emailBool,
            ),
            RoundedPasswordField(
              controller: pw1Controller,
              onChanged: (value) {
                if(pw1Bool) {
                  setState(() {
                    pw1Bool = false;
                  });
                }
              },
            ),
            Visibility(
              child: Text('필수 입력 항목입니다.',  style: TextStyle(color: Colors.red)),
              visible: pw1Bool,
            ),
            RoundedPasswordFieldCheck(
              controller: pw2Controller,
              onChanged: (value) {
                if(pw2Bool) {
                  setState(() {
                    pw2Bool = false;
                  });
                }
              },
            ),
            Visibility(
              child: Text('필수 입력 항목입니다.',  style: TextStyle(color: Colors.red)),
              visible: pw2Bool,
            ),
            Visibility(
              child: Text('비밀번호가 일치하지 않습니다.',  style: TextStyle(color: Colors.red)),
              visible: pw2Bool2,
            ),
            RoundedButton(
              text: "다음",
              press: () {
                if(emailController.text.isEmpty || pw1Controller.text.isEmpty || pw2Controller.text.isEmpty){
                  setState(() {
                    emailBool = emailController.text.isEmpty;
                    pw1Bool = pw1Controller.text.isEmpty;
                    pw2Bool = pw2Controller.text.isEmpty;
                    pw2Bool2 = false;
                  });
                  return;
                }

                if(pw1Controller.text == pw2Controller.text) {
                  advertiser.email = emailController.text;
                  advertiser.password = pw2Controller.text;
                  Navigator.pushNamed(
                      context, SignUpScreen4.routeName, arguments: advertiser);
                } else {
                  setState(() {
                    pw2Bool2 = true;
                  });
                }
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
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/icons/facebook_logo.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/kakao_logo.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/google_logo.svg",
                  press: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
