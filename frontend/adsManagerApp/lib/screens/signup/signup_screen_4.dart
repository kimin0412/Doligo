import 'package:dolligo_ads_manager/components/rounded_button.dart';
import 'package:dolligo_ads_manager/constants.dart';
import 'package:dolligo_ads_manager/models/advertiser_model.dart';
import 'package:dolligo_ads_manager/models/category_model.dart';
import 'package:dolligo_ads_manager/screens/signup/signup_screen_5.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen4 extends StatefulWidget {
  static const routeName = '/signUp4';

  @override
  _SignUpScreen4 createState() => _SignUpScreen4();
}

class _SignUpScreen4 extends State<SignUpScreen4> {
  Advertiser advertiser;
  String _marketaddress = "";
  String _marketname = "";
  LargeCategoryItem _largeCategory;
  MediumCategoryItem _mediumCategory;
  String _marketnumber = "";
  LatLng currentPosition;
  ImagePicker imagePicker;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    advertiser = ModalRoute.of(context).settings.arguments;

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
    return Container(
      height: size.height,
      width: double.infinity,
      color: kPrimaryLightColor,
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: size.height * 0.03),
            Container(
              child: Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
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
                        Text('${_marketaddress.length}/100')
                      ],
                    ),
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 5)
                  ),
                  Container(
                    decoration: new BoxDecoration(color: Colors.white),
                    child: TextField(
                      // controller: _controller,
                      cursorColor: kPrimaryColor,
                      style: TextStyle(fontSize: 15),
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.all(15.0),
                        hintText: "점포 주소를 입력해주세요.(100자 이내)",
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _marketaddress = value;
                        });
                      },
                    )
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '점포 이름',
                              ),
                              TextSpan(
                                  text: '*',
                                  style: TextStyle(color: Colors.red)
                              ),
                            ],
                          ),
                        ),
                        Text('${_marketname.length}/100')
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 5)
                  ),
                  Container(
                    decoration: new BoxDecoration(color: Colors.white),
                    child: TextField(
                      cursorColor: kPrimaryColor,
                      style: TextStyle(fontSize: 15),
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.all(15.0),
                        hintText: "점포 이름를 입력해주세요.",
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _marketname = value;
                        });
                      },
                    )
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '사업자등록번호',
                              ),
                              TextSpan(
                                  text: '*',
                                  style: TextStyle(color: Colors.red)
                              ),
                            ],
                          ),
                        ),
                        Text('${_marketnumber.length}/100')
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 5)
                  ),
                  Container(
                    decoration: new BoxDecoration(color: Colors.white),
                    child: TextField(
                      cursorColor: kPrimaryColor,
                      style: TextStyle(fontSize: 15),
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.all(15.0),
                        hintText: "사업자 등록번호를 입력해주세요",
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _marketnumber = value;
                        });
                      },
                    )
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '카테고리',
                              ),
                              TextSpan(
                                  text: '*',
                                  style: TextStyle(color: Colors.red)
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                    Container(
                      decoration: new BoxDecoration(color: Colors.white),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                        child: DropdownButtonFormField<LargeCategoryItem>(
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                          ),
                          isExpanded: true,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          hint: Text("1차 카테고리"),
                          value: _largeCategory,
                          onChanged: (LargeCategoryItem lci) {
                            setState(() {
                              _largeCategory = lci;
                              _mediumCategory = null;
                            });
                          },
                          items: largeCategoryItems.map((LargeCategoryItem lci) {
                            return DropdownMenuItem<LargeCategoryItem>(
                              value: lci,
                              child: Text(lci.name, style: TextStyle(fontWeight: FontWeight.bold)),
                            );
                          }).toList(),
                        ),
                    ),
                  _largeCategory != null ?
                  Container(
                    decoration: new BoxDecoration(color: Colors.white),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: DropdownButtonFormField<MediumCategoryItem>(
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                      ),
                      isExpanded: true,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      hint: Text("2차 카테고리"),
                      value: _mediumCategory,
                      onChanged: (MediumCategoryItem mci) {
                        setState(() {
                          _mediumCategory = mci;
                        });
                      },
                      items: _largeCategory.mediumItems.map((MediumCategoryItem mci) {
                        return DropdownMenuItem<MediumCategoryItem>(
                          value: mci,
                          child: Text(mci.name, style: TextStyle(fontWeight: FontWeight.bold)),
                        );
                      }).toList(),
                    ),
                  )
              : Text(''),
                  RoundedButton(
                    text: "다음",
                    press: () {
                      advertiser.mtid = _mediumCategory.mtid;
                      advertiser.marketaddress = _marketaddress;
                      advertiser.marketname = _marketname;
                      advertiser.marketnumber = _marketnumber;

                      Navigator.pushNamed(
                          context, SignUpScreen5.routeName, arguments: advertiser);
                    },
                  )
                ]
              )
            ),
          ],
        ),
      )
    );
  }
}
