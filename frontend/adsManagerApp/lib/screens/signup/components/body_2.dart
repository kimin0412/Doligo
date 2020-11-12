import 'package:dolligo_ads_manager/constants.dart';
import 'package:dolligo_ads_manager/models/category_model.dart';
import 'package:dolligo_ads_manager/screens/signup/components/background.dart';
import 'package:dolligo_ads_manager/screens/signup/signup_screen_3.dart';
import 'package:flutter/material.dart';

class Body2 extends StatefulWidget {
  State createState() => Body2State();
}

class Body2State extends State<Body2> {
  @override
  void initState() {
    super.initState();
  }

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
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: largeCategoryItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4.0,
                    shadowColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.5),
                    child: InkWell(
                      splashColor: kPrimaryLightColor,
                      onTap: () =>{
                        Navigator.pushNamed(context, SignUpScreen3.routeName, arguments: largeCategoryItems[index])
                      },
                      child: ListTile(
                        title: Text('${largeCategoryItems[index].name}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        // subtitle: Text('${largeCategoryItems[index].subject}'),
                        trailing: Icon(largeCategoryItems[index].icon,size: 40, color: kPrimaryColor),
                      )
                    )
                  );
                },
              ),
              SizedBox(height: size.height * 0.1),
            ],
          ),
        )
      )
    );
  }
}

class LargeCategoryTile extends StatelessWidget {
  final String _title;
  final String _subTitle;
  final Icon _icon;

  LargeCategoryTile(this._title, this._subTitle, this._icon);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        _title,
        style: TextStyle(fontWeight: FontWeight.bold)
      ),
      subtitle: Text(
        _subTitle
      ),
      trailing: Wrap(
        spacing: 12,
        children: <Widget>[
          SizedBox(
              child: _icon
          ),
        ],
      ),
    );
  }
}
