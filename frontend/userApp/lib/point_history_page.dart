import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'main.dart';

class PointHistoryPage extends StatefulWidget {
  @override
  _PointHistoryPage createState() => _PointHistoryPage();
}

class PointHistoryItem {
  final DateTime dateTime;
  final String detail;
  final int type;     // 1:  전단지 받기,   2: 기프티콘 구매,   3: 현금화
  final int accumulation;
  final int total;

  PointHistoryItem(this.dateTime, this.detail, this.accumulation, this.total, this.type);

  @override
  String toString() {
    return 'PointHistoryItem{dateTime: $dateTime, detail: $detail, accumulation: $accumulation, total: $total}';
  }
}

class User {
  final String name;
  final int totalPoint;

  User(this.name, this.totalPoint);


}

class _PointHistoryPage extends State<PointHistoryPage> {
  List<PointHistoryItem> items = [];
  User user;
  String _token = null;

  var _userInfo = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getUserInfo();
    _getUserPointHistory('0');

  }

  @override
  Widget build(BuildContext context) {

    return _userInfo == null ? Scaffold() : Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("포인트 적립내역",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _buildBody(),
    );
  }

  String newValue = '0';
  _buildBody() {

    List<String> choices = ['0', '${DateTime.now().month.toString()}',
      '${(DateTime.now().month - 1 < 1 ? DateTime.now().month - 1 + 12 : DateTime.now().month - 1).toString()}',
      '${(DateTime.now().month - 2 < 1 ? DateTime.now().month - 2 + 12 : DateTime.now().month - 2).toString()}',
    ];


    return Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Text.rich(
                      TextSpan(
                          children: [
                            TextSpan(
                                text: '${user.name}',
                                style: TextStyle(fontSize: 20)
                            ),
                          ],
                          style: TextStyle(color: Colors.black)
                      )
                  ),
                  Text.rich(
                      TextSpan(
                          children: [
                            TextSpan(
                                text: '${user.totalPoint}',
                                style: TextStyle(fontSize: 30)
                            ),
                            TextSpan(
                                text: ' point'
                            ),
                          ],
                          style: TextStyle(color: Colors.black)
                      )
                  ),
                ],
              ),
            ),
            Container(
              height: 20,
              color: Colors.black12,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(20, 2, 2, 2),
              child: DropdownButton<String>(
                value: newValue,
                icon: Icon(Icons.keyboard_arrow_down),
                onChanged: (String changedValue) {
                  newValue = changedValue;
                  setState(() {
                    newValue;
                    print('val : $newValue');
                    _getUserPointHistory(newValue);
                  });
                },
                items: choices
                    .map<DropdownMenuItem<String>>((String _value) {
                  return DropdownMenuItem<String>(
                    value: _value,
                    child: Text(_value == '0' ? '전체' : _value + '월', style: TextStyle(fontWeight: FontWeight.bold)),
                  );
                }).toList(),
              ),
            ),
            Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return  ListTile(
                        leading: Text('${items[index].dateTime.month}'.padLeft(2, '0') + '.' + '${items[index].dateTime.day}'.padLeft(2, '0'),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        title: Text('${items[index].detail}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${items[index].dateTime.hour}'.padLeft(2, '0') + ':' + '${items[index].dateTime.minute}'.padLeft(2, '0')),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text.rich(
                                TextSpan(
                                    children: [
                                      if(items[index].accumulation > 0)
                                        TextSpan(
                                            text: '+'
                                        ),
                                      TextSpan(
                                          text: '${items[index].accumulation} Point'
                                      ),
                                    ],
                                    style: TextStyle(fontWeight: FontWeight.bold, color: items[index].accumulation > 0 ? Colors.lightBlue : Colors.red)
                                )
                            ),
                            Text('${items[index].total} Point')
                          ],
                        )
                    );
                  },
                )
            )
          ],
        )
    );
  }

  Future<String> _point_fetch() async {
    await Future.delayed(Duration(seconds: 2));
    return 'Call Data';
  }

  void _getUserInfo() async {
    _token = _token == null ? await FlutterSecureStorage().read(key: 'token') : _token;
    print('token : $_token');
    final response = await http.get('${MyApp.commonUrl}/token/user',
        headers: {
          'Authorization' : 'Bearer $_token'
        }
    );
    _userInfo = json.decode(response.body)['data'];
    print('userInfo : $_userInfo');

    setState(() {
      user = new User(_userInfo['nickname'], _userInfo['point']);
    });
  }

  void _getUserPointHistory(String newValue) async {
    _token = _token == null ? await FlutterSecureStorage().read(key: 'token') : _token;
    final response = await http.get('${MyApp.commonUrl}/token/user/point/$newValue',
        headers: {
          'Authorization' : 'Bearer $_token'
        }
    );

    if(response.statusCode == 200) {
      var tmp = jsonDecode(response.body)['data'];
      // print('tmp : $tmp');
      items.clear();
      setState(() {
        for(int i = 0; i < tmp.length; i++) {
          int type = tmp[i]['sid'];
          int point = type == 1 ? tmp[i]['point'] : -tmp[i]['point'];
          String content = type == 1 ? '전단지 받기' : (type == 2 ? '기프티콘 구매' : (type == 3 ? '현금화(인출)' : '관리자가 주는 선물'));

          items.add(PointHistoryItem(DateFormat("yyyy-MM-ddTHH:mm").parse('${tmp[i]['created']}'.substring(0, 16)).add(new Duration(hours: 9)), content, point, tmp[i]['totalPoint'], type));
          print('$i번째 : ${items[i].toString()}');
        }
      });
    }
  }

}





class PointHistoryTile extends StatelessWidget {
  PointHistoryTile(this._name);

  final String _name;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          _name,
          style: TextStyle(fontWeight: FontWeight.bold)
      ),
      trailing: Wrap(
        spacing: 12,
        children: <Widget>[
          SizedBox(
              child: Icon(Icons.chevron_right,
                  color: Colors.deepPurpleAccent,
                  size: 30.0)
          ),
        ],
      ),
    );
  }
}
