import 'package:flutter/material.dart';

class PointHistoryPage extends StatefulWidget {
  @override
  _PointHistoryPage createState() => _PointHistoryPage();
}

class PointHistoryItem {
  final DateTime dateTime;
  final String detail;
  final int accumulation;
  final int total;

  PointHistoryItem(this.dateTime, this.detail, this.accumulation, this.total);
}

class User {
  final String name;
  final int totalPoint;

  User(this.name, this.totalPoint);
}

class _PointHistoryPage extends State<PointHistoryPage> {
  List<PointHistoryItem> items;
  User user;

  @override
  Widget build(BuildContext context) {
    items = [
      PointHistoryItem(new DateTime.now(), '전단지 받기', 50, 100),
      PointHistoryItem(new DateTime.now(), '기프티콘 구입', -1000, 100),
      PointHistoryItem(new DateTime.now(), '기프티콘 구입', -1000, 100),
      PointHistoryItem(new DateTime.now(), '전단지 받기', 50, 100),
      PointHistoryItem(new DateTime.now(), '전단지 받기', 50, 100),
      PointHistoryItem(new DateTime.now(), '전단지 받기', 50, 100),
      PointHistoryItem(new DateTime.now(), '전단지 받기', 50, 100),
      PointHistoryItem(new DateTime.now(), '전단지 받기', 50, 100),
      PointHistoryItem(new DateTime.now(), '전단지 받기', 50, 100),
    ];

    user = new User('김민지', 12000);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("포인트 적립내역",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
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
                      style: TextStyle(color: Colors.lightBlue)
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
                      style: TextStyle(color: Colors.lightBlue)
                    )
                  ),
                ],
              ),
            ),
            Container(
              height: 20,
              color: Colors.black12,
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return  ListTile(
                    leading: Text('${items[index].dateTime.month}.${items[index].dateTime.day}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    title: Text('${items[index].detail}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${items[index].dateTime.hour}:${items[index].dateTime.minute}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
