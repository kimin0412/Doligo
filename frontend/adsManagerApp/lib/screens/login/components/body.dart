import 'package:dolligo_ads_manager/components/already_have_an_account_acheck.dart';
import 'package:dolligo_ads_manager/components/rounded_button.dart';
import 'package:dolligo_ads_manager/components/rounded_input_field.dart';
import 'package:dolligo_ads_manager/components/rounded_password_field.dart';
import 'package:dolligo_ads_manager/screens/login/components/background.dart';
import 'package:dolligo_ads_manager/screens/signup/signup_screen.dart';
import 'package:dolligo_ads_manager/screens/tap_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

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
              hintText: "이메일을 입력해주세요.",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (BuildContext context) => TabPage()), (route) => false
                );
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
}