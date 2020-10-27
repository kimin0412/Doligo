import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class CreateLeafletPage extends StatefulWidget {
  @override
  _CreateLeafletPage createState() => _CreateLeafletPage();
}

class _CreateLeafletPage extends State<CreateLeafletPage> {
  PickedFile _leafletImage;
  ImagePicker imagePicker;

  @override
  void initState(){
    super.initState();
    imagePicker = new ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("돌리Go!",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _buildBody(),
      backgroundColor: Color(0xffeeeeee),
    );
  }

  Widget _buildBody(){
    return Center(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            child: ListTile(
              title: Text.rich(
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
              trailing: Wrap(
                children: [
                  Text('0/20')
                ],
              ),
            ),
          ),
          Container(
            decoration: new BoxDecoration(color: Colors.white),
            child: TextField(
              style: TextStyle(fontSize: 15),
              decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(15.0),
                  hintText: "20자 이내(한글/영문/숫자)"
              ),
            ),
          ),
          Container(
            child: ListTile(
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
                  Text('0/100')
                ],
              ),
            ),
          ),
          Container(
            decoration: new BoxDecoration(color: Colors.white),
            child: TextField(
              style: TextStyle(fontSize: 15),
              decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(15.0),
                  hintText: "점포 주소를 입력해주세요.(100자 이내)"
              ),
            ),
          ),
          Container(
            child: ListTile(
              title: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '배포 날짜/시간',
                    ),
                    TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red)
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(

          ),
          Container(
            child: ListTile(
              title: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '전단지 이미지 등록',
                    ),
                    TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red)
                    ),
                  ],
                ),
              ),
            ),
          ),
          _leafletImage != null ? Card(
            margin: EdgeInsets.fromLTRB(20,0,20,20),
            child: Image.file(File(_leafletImage.path))
          ) : Text('이미지를 등록해 주세요')
          ,
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Colors.deepPurpleAccent, width: 3)
              ),
              child: Text('이미지 올리기'),
              color: Colors.white,
              onPressed: _getImage,
            ),
          ),
          Container(
            child: ListTile(
              title: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '배포 매수',
                    ),
                    TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red)
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: new BoxDecoration(color: Colors.white),
            child: TextField(
              style: TextStyle(fontSize: 15),
              decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(15.0),
                  hintText: "배포 매수를 입력해주세요."
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: RaisedButton(
              child: Text('결제하기'),
              color: Colors.deepPurpleAccent,
              onPressed: _getImage,
            ),
          ),
        ],
      )
    );
  }

  void _ee(){

    print("dd");
  }

  Future _getImage() async{
    print("dd");
    PickedFile image = await imagePicker.getImage(source: ImageSource.gallery);

    setState(() {
      _leafletImage = image;
    });
  }
}
