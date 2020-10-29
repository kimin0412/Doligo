import 'package:dolligo_ads_manager/constants.dart';
import 'package:dolligo_ads_manager/models/category_model.dart';
import 'package:dolligo_ads_manager/screens/signup/components/background.dart';
import 'package:dolligo_ads_manager/screens/signup/components/body_3.dart';
import 'package:dolligo_ads_manager/screens/signup/signup_screen_4.dart';
import 'package:flutter/material.dart';


class SignUpScreen3 extends StatefulWidget {
  static const routeName = '/signUp3';

  @override
  _SignUpScreen3State createState() => _SignUpScreen3State();
}

class _SignUpScreen3State extends State<SignUpScreen3> {
  LargeCategoryItem lci;
  List<MediumCategoryItem> mci;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    lci = ModalRoute.of(context).settings.arguments;
    mci = lci.mediumItems;

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
            Text(
              "${lci.name}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: size.height * 0.03),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: mci.length,
              itemBuilder: (context, index) {
                return Card(
                    elevation: 4.0,
                    shadowColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.5),
                    child: InkWell(
                        splashColor: kPrimaryLightColor,
                        onTap: () =>{
                          Navigator.pushNamed(context, SignUpScreen4.routeName, arguments: mci[index])
                        },
                        child: ListTile(
                          title: Text('${mci[index].name}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          trailing: Icon(Icons.chevron_right),
                        )
                    )
                );
              },
            ),
            SizedBox(height: size.height * 0.1),
          ],
        ),
      )
    );
  }
}
