import 'package:dolligo_ads_manager/components/already_have_an_account_acheck.dart';
import 'package:dolligo_ads_manager/components/rounded_button.dart';
import 'package:dolligo_ads_manager/constants.dart';
import 'package:dolligo_ads_manager/screens/login/login_screen.dart';
import 'package:dolligo_ads_manager/screens/signup/components/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Choice {
  Choice({this.title, this.icon, this.isSelected});
  String title;
  IconData icon;
  bool isSelected;
}

List<Choice> choices = [
  Choice(title: '소매', icon: Icons.local_grocery_store, isSelected:false),
  Choice(title: '생활 서비스', icon: Icons.local_laundry_service, isSelected:false),
  Choice(title: '부동산', icon: Icons.house, isSelected:false),
  Choice(title: '관광/여가/오락', icon: Icons.airplanemode_active, isSelected:false),
  Choice(title: '숙박', icon: Icons.hotel, isSelected:false),
  Choice(title: '스포츠', icon: Icons.directions_run, isSelected:false),
  Choice(title: '음식', icon: Icons.fastfood, isSelected:false),
  Choice(title: '학문/교육', icon: Icons.school, isSelected:false)
];

class Body3 extends StatefulWidget {
  State createState() => Body3State();
}

class Body3State extends State<Body3> {
  // const ChoiceCard({Key key, this.choice, this.selected}) : super(key: key);
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
    Size size = MediaQuery.of(context).size;
    final TextStyle textStyle = Theme.of(context).textTheme.display1;

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "추가정보 입력",
              style: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}
