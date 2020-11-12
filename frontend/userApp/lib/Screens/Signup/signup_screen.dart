import 'package:flutter/material.dart';
import 'package:userApp/Screens/Login/login_screen.dart';
import 'package:userApp/Screens/Signup/signup_screen_2.dart';
import 'package:userApp/components/already_have_an_account_acheck.dart';
import 'package:userApp/components/rounded_button.dart';
import 'package:userApp/components/rounded_input_field.dart';
import 'package:userApp/components/rounded_password_field.dart';
import 'package:userApp/components/rounded_password_field_check.dart';

import 'components/background.dart';
import 'components/or_divider.dart';
import 'components/social_icon.dart';

class SignUpScreen extends StatelessWidget {
  String _email;
  String _nickname;
  String _password;
  String _passwordCheck;

  SignupArgument arg = SignupArgument();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Background(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "SIGNUP",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.03),
                //SvgPicture.asset(
                //  "assets/icons/signup.svg",
                //  height: size.height * 0.35,
                //),
                RoundedInputField(
                  hintText: "이메일을 입력해주세요.",
                  onChanged: (value) {_email = value;},
                ),
                RoundedInputField(
                  hintText: "닉네임을 입력해주세요.",
                  onChanged: (value) {_nickname = value;},
                ),
                RoundedPasswordField(
                  onChanged: (value) {_password = value;},
                ),
                RoundedPasswordFieldCheck(
                  onChanged: (value) {_passwordCheck = value;},
                ),
                RoundedButton(
                  text: "다음",
                  press: () {
                    arg.email = _email;
                    arg.nickname = _nickname;
                    arg.password = _password;
                    arg.passwordCheck = _passwordCheck;
                    Navigator.pushNamed(
                      context,
                      SignUpScreen2.routeName,
                      arguments: arg
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
        ),
      ),
    );
  }
}


class SignupArgument {
  // First step (input)
  String email;
  String nickname;
  String password;
  String passwordCheck;

  // Second step (input)
  bool isFemail;
  int selectedYear;
  String selectedSi;
  String selectedGu;

  // Last step (input)
  List<String> list = new List<String>();

  @override
  String toString() {
    return 'SignupArgument{email: $email, nickname: $nickname, password: $password, passwordCheck: $passwordCheck, isFemail: $isFemail, selectedYear: $selectedYear, selectedSi: $selectedSi, selectedGu: $selectedGu, list: $list}';
  }
}
