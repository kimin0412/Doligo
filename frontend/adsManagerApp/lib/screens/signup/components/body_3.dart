import 'package:dolligo_ads_manager/components/already_have_an_account_acheck.dart';
import 'package:dolligo_ads_manager/components/rounded_button.dart';
import 'package:dolligo_ads_manager/constants.dart';
import 'package:dolligo_ads_manager/screens/login/login_screen.dart';
import 'package:dolligo_ads_manager/screens/signup/components/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Body3 extends StatefulWidget {
  State createState() => Body3State();
}

class Body3State extends State<Body3> {
  // const ChoiceCard({Key key, this.choice, this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("돌리Go!",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        body: Background(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: size.height * 0.03),
                  Text(
                    "어떤 분야의 점포를 운영하고 계신가요?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: size.height * 0.03),

                ],
              ),
            )
        )
    );
  }
}
