import 'package:dolligo_ads_manager/screens/create_leaflet_page.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class AdvDashboardPage extends StatefulWidget {
  @override
  _AdvDashboardPage createState() => _AdvDashboardPage();
}

class _AdvDashboardPage extends State<AdvDashboardPage> {
  List<charts.Series<Task, String>> _seriesPieData;
  String pieDropdownValue;
  String timeSeriesDropdownValue;

  List<charts.Series<TimeStack, DateTime>> _seriesStackListData;

  void _generateData() {
    pieDropdownValue = '연령별';
    timeSeriesDropdownValue = '시간별';

    var pieData = [
      Task('10대', 33.3, Colors.red),
      Task('20대', 12.0, Colors.deepPurpleAccent),
      Task('30대', 11.3, Colors.amber),
      Task('40대', 28.9, Colors.lightBlueAccent),
      Task('50대 이상', 10.4, Colors.black12),
    ];

    var stackListData1 = [
      TimeStack(DateTime.utc(1989, 11, 9, 14), 70),
      TimeStack(DateTime.utc(1989, 11, 9, 15), 70),
      TimeStack(DateTime.utc(1989, 11, 9, 16), 82),
      TimeStack(DateTime.utc(1989, 11, 9, 17), 100),
      TimeStack(DateTime.utc(1989, 11, 9, 18), 120),
      TimeStack(DateTime.utc(1989, 11, 9, 19), 135),
      TimeStack(DateTime.utc(1989, 11, 9, 20), 142),
      TimeStack(DateTime.utc(1989, 11, 9, 21), 88),
      TimeStack(DateTime.utc(1989, 11, 9, 22), 60),
    ];

    var stackListData2 = [
      TimeStack(DateTime.utc(1989, 11, 9, 14), 30),
      TimeStack(DateTime.utc(1989, 11, 9, 15), 40),
      TimeStack(DateTime.utc(1989, 11, 9, 16), 66),
      TimeStack(DateTime.utc(1989, 11, 9, 17), 58),
      TimeStack(DateTime.utc(1989, 11, 9, 18), 37),
      TimeStack(DateTime.utc(1989, 11, 9, 19), 60),
      TimeStack(DateTime.utc(1989, 11, 9, 20), 60),
      TimeStack(DateTime.utc(1989, 11, 9, 21), 10),
      TimeStack(DateTime.utc(1989, 11, 9, 22), 30),
    ];

    var stackListData3 = [
      TimeStack(DateTime.utc(1989, 11, 9, 14), 4),
      TimeStack(DateTime.utc(1989, 11, 9, 15), 11),
      TimeStack(DateTime.utc(1989, 11, 9, 16), 5),
      TimeStack(DateTime.utc(1989, 11, 9, 17), 8),
      TimeStack(DateTime.utc(1989, 11, 9, 18), 2),
      TimeStack(DateTime.utc(1989, 11, 9, 19), 4),
      TimeStack(DateTime.utc(1989, 11, 9, 20), 1),
      TimeStack(DateTime.utc(1989, 11, 9, 21), 1),
      TimeStack(DateTime.utc(1989, 11, 9, 22), 3),
    ];

    _seriesPieData.add(
      charts.Series(
        data: pieData,
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskValue,
        colorFn: (Task task, _) => charts.ColorUtil.fromDartColor(task.color),
        id:'Daily Task',
        labelAccessorFn: (Task task, _) => '${task.taskValue}',
      )
    );

    _seriesStackListData.add(
        charts.Series<TimeStack, DateTime>(
          data: stackListData1,
          id: '배포수',
          domainFn: (TimeStack task, _) => task.time,
          measureFn: (TimeStack task, _) => task.value,
          colorFn: (datum, index) => charts.ColorUtil.fromDartColor(Colors.black45),
        ));
    _seriesStackListData.add(
        charts.Series<TimeStack, DateTime>(
          data: stackListData2,
          id: '클릭수',
          domainFn: (TimeStack task, _) => task.time,
          measureFn: (TimeStack task, _) => task.value,
        ));
    _seriesStackListData.add(
        charts.Series<TimeStack, DateTime>(
          data: stackListData3,
          id: '클릭수',
          domainFn: (TimeStack task, _) => task.time,
          measureFn: (TimeStack task, _) => task.value,
        ));

  }

  @override
  void initState(){
    super.initState();
    _seriesPieData = new List<charts.Series<Task, String>>();
    _seriesStackListData = new List<charts.Series<TimeStack, DateTime>>();
    _generateData();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateLeafletPage()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.deepPurpleAccent,
      )
    );
  }

  Widget _buildBody(){
    return Container(
      child: Center(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Card(
              margin: EdgeInsets.all(20),
              child: ListTile(
                leading: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: Icon(Icons.account_circle,
                        color: Colors.deepPurpleAccent,
                        size: 50.0)
                ),
                title: Text('이건수님의 대시보드'),
                subtitle: Text('dddd'),
              ),
            ),
            Card(
              margin: EdgeInsets.fromLTRB(20,0,20,20),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(20,20,20,20),
                    child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: '20대 여성',
                                style: TextStyle(
                                    decoration: TextDecoration.underline, fontSize: 30, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent)
                            ),
                            TextSpan(
                              text: '에게 인기가 많습니다',
                            ),
                          ],
                        )
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(20,0,20,20),
                    child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '효과적인 광고 시간은',
                            ),
                            TextSpan(
                                text: '17 - 18시',
                                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent)
                            ),
                            TextSpan(
                              text: '입니다',
                            ),
                          ],
                        )
                    ),
                  )
                ],

              ),
            ),
            Card(
              margin: EdgeInsets.fromLTRB(20,0,20,20),
              child: Column(
                children: [
                  ListTile(
                    title: Text('현재 배포 중인 전단지', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    trailing: Wrap(
                      spacing: 12,
                      children: <Widget>[
                        SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: Icon(Icons.double_arrow,
                                color: Colors.deepPurpleAccent,
                                size: 50.0)
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text('배포', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Text('1350', style: TextStyle(fontSize: 15)),
                            ],
                          ),
                          VerticalDivider(
                            width: 1,
                            color: Colors.grey,
                          ),
                          Column(
                            children: [
                              Text('클릭', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Text('700', style: TextStyle(fontSize: 15)),
                            ],
                          ),
                          VerticalDivider(
                            width: 1,
                            color: Colors.grey,
                          ),
                          Column(
                            children: [
                              Text('총 매수', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Text('2000', style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        ],
                      )
                    )
                  )
                ],
              )
            ),
            Card(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(20, 2, 2, 2),
                    child: DropdownButton<String>(
                      value: pieDropdownValue,
                      onChanged: (String newValue) {
                        setState(() {
                          pieDropdownValue = newValue;
                        });
                      },
                      items: <String>['연령별', '성별']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 300.0,
                    child: charts.PieChart(
                      _seriesPieData,
                      animate: true,
                      animationDuration: Duration(seconds: 1),
                      behaviors: [
                        new charts.DatumLegend(
                            position: charts.BehaviorPosition.end,
                            outsideJustification: charts.OutsideJustification.endDrawArea,
                            horizontalFirst: false,
                            cellPadding: EdgeInsets.all(4.0),
                            entryTextStyle: charts.TextStyleSpec(
                                fontSize: 15
                            )
                        )
                      ],
                      defaultRenderer: new charts.ArcRendererConfig(
                          arcWidth: 65,
                          arcRendererDecorators: [
                            charts.ArcLabelDecorator(
                                labelPosition: charts.ArcLabelPosition.inside
                            )
                          ]
                      ),
                    ),
                  )
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(20, 2, 2, 2),
                    child: DropdownButton<String>(
                      value: timeSeriesDropdownValue,
                      onChanged: (String newValue) {
                        setState(() {
                          timeSeriesDropdownValue = newValue;
                        });
                      },
                      items: <String>['시간별', '날짜별']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 300.0,
                    child: charts.TimeSeriesChart(
                      _seriesStackListData,
                      defaultRenderer: new charts.LineRendererConfig(includeArea: true, stacked: false),
                      animate: true,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Task{
  String task;
  double taskValue;
  Color color;

  Task(this.task, this.taskValue, this.color);
}

class TimeStack{
  DateTime time;
  int value;

  TimeStack(this.time, this.value);
}
