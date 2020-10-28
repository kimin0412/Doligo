import 'package:flutter/material.dart';

class MarketPage extends StatefulWidget {
  @override
  _MarketPage createState() => _MarketPage();
}

class _MarketPage extends State<MarketPage> {
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
              Text('쇼핑하기 페이지')
            ],
          )
      ),
    );
  }
}
