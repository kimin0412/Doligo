import 'package:flutter/material.dart';
import 'package:frontend/leaflet_page.dart';
import 'package:frontend/market_page.dart';
import 'package:frontend/point_history_page.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
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
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: SafeArea(
              child: SingleChildScrollView(
                  child: Center(
                      child: Column(
                        children: <Widget>[
                          Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: InkWell(
                                onTap: () =>{
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => PointHistoryPage()),
                                  )
                                },
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                  height: 100,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(5),
                                  child: ListTile(
                                    leading: SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child: Icon(Icons.account_circle,
                                            color: Colors.lightBlue,
                                            size: 50.0)
                                    ),
                                    title: Text('김민지님 어서오세요!',
                                        style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold)),
                                    subtitle: Text('브론즈?',
                                        style: TextStyle(color: Colors.lightBlue)),
                                    trailing: Wrap(
                                      spacing: 12,
                                      children: <Widget>[
                                        SizedBox(
                                            width: 50.0,
                                            height: 50.0,
                                            child: Icon(Icons.swap_vert_circle,
                                                color: Colors.lightBlue,
                                                size: 50.0)
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Padding(padding: EdgeInsets.all(8.0)),
                          Card(
                            margin: EdgeInsets.all(5),
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: InkWell(
                              onTap: () =>{
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PointHistoryPage()),
                                )
                              },
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Padding(padding: EdgeInsets.all(8.0)),
                                    ListTile(
                                      title: Text(
                                          '오늘의 잔여 횟수',
                                          style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold)
                                      ),
                                      subtitle: Text('2/10회',
                                        style: TextStyle(color: Colors.lightBlue, fontSize: 30),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                          '내 적립포인트',
                                          style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold)
                                      ),
                                      subtitle: Text('12,000 Point',
                                        style: TextStyle(color: Colors.lightBlue, fontSize: 30),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.all(8.0)),
                                  ],
                                ),
                              ),
                            )
                          ),
                          Padding(padding: EdgeInsets.all(8.0)),
                          Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: InkWell(
                              onTap: () =>{
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LeafletPage()),
                                )
                              },
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        title: Text('포인트 바로 받기 >',
                                            style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold)),
                                        subtitle: Text('원하는 전단지만 보고 바로 적립',
                                            style: TextStyle(color: Colors.lightBlue)),
                                        trailing: Wrap(
                                          spacing: 12,
                                          children: <Widget>[
                                            SizedBox(
                                                width: 50.0,
                                                height: 50.0,
                                                child: Icon(Icons.swap_vert_circle,
                                                    color: Colors.lightBlue,
                                                    size: 50.0)
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(8.0)),
                          Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text('내 쿠폰 확인하기 >',
                                        style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold)),
                                    trailing: Wrap(
                                      spacing: 12,
                                      children: <Widget>[
                                        SizedBox(
                                            width: 50.0,
                                            height: 50.0,
                                            child: Icon(Icons.swap_vert_circle,
                                                color: Colors.lightBlue,
                                                size: 50.0)
                                        ),
                                      ],
                                    ),
                                  ),
                                ]
                            ),
                          ), Padding(padding: EdgeInsets.all(8.0)),
                          Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: InkWell(
                                  onTap: () =>{
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MarketPage()),
                                    )
                                  },
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            title: Text('쇼핑하기 >',
                                                style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold)),
                                            trailing: Wrap(
                                              spacing: 12,
                                              children: <Widget>[
                                                SizedBox(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    child: Icon(Icons.swap_vert_circle,
                                                        color: Colors.lightBlue,
                                                        size: 50.0)
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]
                                    ),
                                  )
                              )
                          ),
                        ],
                      )
                  )
              ),)
        )
    );
  }
}
