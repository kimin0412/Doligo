import 'package:flutter/material.dart';

class PointHistoryPage extends StatefulWidget {
  @override
  _PointHistoryPage createState() => _PointHistoryPage();
}

class _PointHistoryPage extends State<PointHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("모바일 전단지",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
          child: Column(
            children: <Widget>[
              Text('포인트 내역 페이지')
            ],
          )
      ),
    );
  }
}
