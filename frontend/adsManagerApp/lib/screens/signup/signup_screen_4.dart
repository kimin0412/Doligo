import 'package:dolligo_ads_manager/constants.dart';
import 'package:dolligo_ads_manager/models/category_model.dart';
import 'package:dolligo_ads_manager/screens/signup/components/background.dart';
import 'package:dolligo_ads_manager/screens/signup/components/body_3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class SignUpScreen4 extends StatefulWidget {
  static const routeName = '/signUp4';

  @override
  _SignUpScreen4 createState() => _SignUpScreen4();
}

class _SignUpScreen4 extends State<SignUpScreen4> {
  MediumCategoryItem mci;
  int address = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mci = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("돌리Go!",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody(){
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: size.height * 0.03),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.5),
              child: Column(
                children: [
                  ListTile(
                    title: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '점포 주소',
                          ),
                          TextSpan(
                              text: '*',
                              style: TextStyle(color: Colors.red)
                          ),
                        ],
                      ),
                    ),
                    trailing: Wrap(
                      children: [
                        Text('${address}/100')
                      ],
                    ),
                  ),
                  TextField(
                        style: TextStyle(fontSize: 15),
                        decoration: new InputDecoration(
                            contentPadding: EdgeInsets.all(15.0),
                            hintText: "점포 주소를 입력해주세요.(100자 이내)"
                        ),
                    onChanged: (value) {
                          
                      print("First text field: ${value}");
                    },
                  ),

                ]
              )
            ),

          ],
        ),
      )
    );
  }
}



class ScreenArguments{
  final MediumCategoryItem mediumCategoryItem;

  ScreenArguments(this.mediumCategoryItem);
}
