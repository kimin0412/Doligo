import 'package:dolligo_ads_manager/components/already_have_an_account_acheck.dart';
import 'package:dolligo_ads_manager/components/rounded_button.dart';
import 'package:dolligo_ads_manager/components/rounded_input_field.dart';
import 'package:dolligo_ads_manager/components/rounded_password_field.dart';
import 'package:dolligo_ads_manager/components/rounded_password_field_check.dart';
import 'package:dolligo_ads_manager/screens/login/login_screen.dart';
import 'package:dolligo_ads_manager/screens/signup/components/background.dart';
import 'package:dolligo_ads_manager/screens/signup/components/or_divider.dart';
import 'package:dolligo_ads_manager/screens/signup/components/social_icon.dart';
import 'package:dolligo_ads_manager/screens/signup/signup_screen_2.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {


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
              hintText: "이메일을 입력해주세요.",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedPasswordFieldCheck(
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "다음",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen2();
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
