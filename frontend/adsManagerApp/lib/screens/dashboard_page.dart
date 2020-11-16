import 'dart:convert';

import 'package:dolligo_ads_manager/constants.dart';
import 'package:dolligo_ads_manager/models/advertiser_model.dart';
import 'package:dolligo_ads_manager/models/dashboard_model.dart';
import 'package:dolligo_ads_manager/models/statatics.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrscan/qrscan.dart';
import 'package:http/http.dart' as http;


class AdvDashboardPage extends StatefulWidget {
  @override
  _AdvDashboardPage createState() => _AdvDashboardPage();
}

class _AdvDashboardPage extends State<AdvDashboardPage>{
  String _output = 'Empty Scan Code';
  String jwt;
  bool isLoading;
  List<charts.Series<Task, String>> _seriesPieData;
  List<charts.Series<Task, String>> _seriesPieData1;
  List<charts.Series<Task, String>> _seriesPieData2;
  List<Task> pieData1 = List();
  List<Task> pieData2 = List();
  List<TimeStack> sl1 = List();
  List<TimeStack> sl2 = List();
  List<TimeStack> sl3 = List();
  List<TimeStack> sl4 = List();
  int byAge = 1;
  int byGender = 1;
  int iMaxAge;
  String maxAge = "";
  String maxGender = "";
  int iMaxTime;
  String maxTime = "";
  Statistic nowLeaflet = new Statistic();
  Dashboard dashboard;
  String pieDropdownValue;
  String timeSeriesDropdownValue;
  Advertiser _advertiser;

  List<charts.Series> _seriesStackListData;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await _getDashboard();

    setState(() {

    });

    return null;
  }

  @override
  void initState(){
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    isLoading = false;
    nowLeaflet.visit = 0;
    nowLeaflet.block = 0;
    nowLeaflet.interest = 0;
    nowLeaflet.distributed = 0;
    _seriesPieData1 = new List<charts.Series<Task, String>>();
    _seriesPieData2 = new List<charts.Series<Task, String>>();
    _seriesStackListData = new List<charts.Series<TimeStack, int>>();

    pieDropdownValue = '연령별';
    timeSeriesDropdownValue = '시간별';

    _seriesPieData1.add(
        charts.Series(
          data: pieData1,
          domainFn: (Task task, _) => task.task,
          measureFn: (Task task, _) => task.taskValue,
          colorFn: (Task task, _) => charts.ColorUtil.fromDartColor(task.color),
          id:'연령별',
          labelAccessorFn: (Task task, _) => '${(task.taskValue * 100 / byAge).toStringAsFixed(1)}%',
        )
    );


    // _seriesPieData2.clear();

    _seriesPieData2.add(
        charts.Series(
          data: pieData2,
          domainFn: (Task task, _) => task.task,
          measureFn: (Task task, _) => task.taskValue,
          colorFn: (Task task, _) => charts.ColorUtil.fromDartColor(task.color),
          id:'성별',
          labelAccessorFn: (Task task, _) => '${(task.taskValue * 100 / byGender).toStringAsFixed(1)}%',
        )
    );

    _getAdvertiser();
    _getDashboard();
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
        heroTag: "qrscan",
        onPressed: () => _scan(),
        tooltip: 'scan',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Widget _buildBody(){
    return Stack(children: [
      RefreshIndicator(
        backgroundColor: kPrimaryColor,
        key: refreshKey,
        onRefresh: refreshList,
        child: Center(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Card(
                margin: EdgeInsets.all(20),
                child: Container(
                  margin: EdgeInsets.all(15),
                  alignment: Alignment.center,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: _advertiser == null ? "marketname" : _advertiser.marketname ?? "marketname",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold, )
                        ),
                        TextSpan(
                          text: '의 대시보드',
                        ),
                      ],
                    ),
                  )
                )
              ),
              Card(
                shape: RoundedRectangleBorder(side: new BorderSide(color: kPrimaryColor, width: 1.0), borderRadius: BorderRadius.circular(5.0)),
                margin: EdgeInsets.fromLTRB(20,0,20,20),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(20,20,20,20),
                      child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: '$maxAge $maxGender',
                                  style: TextStyle(
                                      fontSize: 30, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent)
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
                                text: '효과적인 광고 시간은 ',
                              ),
                              TextSpan(
                                  text: maxTime,
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
                  shape: RoundedRectangleBorder(side: new BorderSide(color: kPrimaryColor, width: 1.0), borderRadius: BorderRadius.circular(5.0)),
                  margin: EdgeInsets.fromLTRB(20,0,20,20),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.all(15),
                        child: Text('최근 배포 전단지', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      )
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text('배포', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  Text('${nowLeaflet.distributed ?? 0}', style: TextStyle(fontSize: 15)),
                              ],
                            ),
                            VerticalDivider(
                              width: 1,
                              color: Colors.grey,
                            ),
                            Column(
                              children: [
                                Text('클릭', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                Text('${nowLeaflet.interest ?? 0}', style: TextStyle(fontSize: 15)),
                              ],
                            ),
                            VerticalDivider(
                              width: 1,
                              color: Colors.grey,
                            ),
                            Column(
                              children: [
                                Text('차단', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                Text('${nowLeaflet.block ?? 0}', style: TextStyle(fontSize: 15)),
                              ],
                            ),
                            VerticalDivider(
                              width: 1,
                              color: Colors.grey,
                            ),
                            Column(
                              children: [
                                Text('방문', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                Text('${nowLeaflet.visit ?? 0}', style: TextStyle(fontSize: 15)),
                              ],
                            ),
                          ],
                        )
                      )
                    )
                  ],
                )
              ),
              _seriesPieData != null ? Card(
                margin: EdgeInsets.fromLTRB(0,0,0,20),
                color: Color(0xfff1f6FF),
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
                            if(newValue == '성별'){
                              setState(() {
                                _seriesPieData = _seriesPieData2;
                              });
                            } else {
                              setState(() {
                                _seriesPieData = _seriesPieData1;
                              });
                            }
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
                                  labelPosition: charts.ArcLabelPosition.inside,
                              )
                            ]
                        ),
                      ),
                    )
                  ],
                ),
              )
              : Card(
                child: Center(
                    child: Container(
                      margin: EdgeInsets.all(30),
                      child: Text('데이터가 없습니다', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    )
                ),
              ),
              _seriesStackListData.length > 0 ? Card(
                margin: EdgeInsets.fromLTRB(0,0,0,60),
                color: Color(0xfff1f6FF),
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
                        items: <String>['시간별']
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
                      child: charts.LineChart(
                        _seriesStackListData,
                        defaultRenderer: new charts.LineRendererConfig(includeArea: true, stacked: false),
                        animate: true,
                        behaviors: [
                          new charts.SeriesLegend(
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
              : Text('')
            ],
          ),
        ),
      ),
      Visibility(
          visible: isLoading,
          child: Container(
            color: Colors.black26,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  child:
                  Text('돌리고 데이터를 불러오는 중...', style: TextStyle(color: kPrimaryColor,fontSize: 18, fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 2.0,
                        color: Color.fromARGB(255, 255, 255, 255)
                    )
                  ]),),
                )
              ],
            )
          )
      ),
    ],);
  }

  Future _scan() async {
    String barcode = await scan();
    //스캔 완료하면 _output 에 문자열 저장하면서 상태 변경 요청.
    setState(() => _output = barcode);

    showToast('qr코드가 인증 되었습니다.');

    var _adv = await http.post('$SERVER_IP/api/token/advertiser/paper/qrcode',
        headers: {'Authorization' : 'Bearer $jwt'},
        body:jsonEncode(barcode));
  }

  void _getAdvertiser() async{
    jwt = await FlutterSecureStorage().read(key: 'jwt');

    var _adv = await http.get('$SERVER_IP/api/token/advertiser',
        headers: {'Authorization' : 'Bearer $jwt'});

    setState(() {
      _advertiser = Advertiser.fromJson(jsonDecode(_adv.body)['data']);
    });
  }

  void _getDashboard() async{
    setState(() {
      isLoading = true;
    });
    if(_advertiser == null){
      await _getAdvertiser();
    }

    print(jwt);
    var response = await http.get('$SERVER_IP/api/token/advertiser/paper/dashboard',
        headers: {'Authorization' : 'Bearer $jwt'});

    if(response.statusCode == 200 || response.statusCode == 202) {
      dashboard = Dashboard.fromJson(json.decode(response.body));

      pieData1.clear();
      pieData2.clear();

      byAge = dashboard.ca.teen + dashboard.ca.second +  dashboard.ca.third + dashboard.ca.forth + dashboard.ca.above;
      byGender = dashboard.cg.m + dashboard.cg.w;
      pieData1.add(Task("10대", dashboard.ca.teen, Colors.red));
      pieData1.add(Task("20대", dashboard.ca.second, Colors.amber));
      pieData1.add(Task("30대", dashboard.ca.third, Colors.lightBlueAccent));
      pieData1.add(Task("40대", dashboard.ca.forth, Colors.green));
      pieData1.add(Task("50대 이상", dashboard.ca.above, Colors.indigo));

      pieData2.add(Task("남성", dashboard.cg.m, Colors.blue));
      pieData2.add(Task("여성", dashboard.cg.w, Colors.red));

      pieDropdownValue = '연령별';

      List<TimeStack> sl1 = List();
      List<TimeStack> sl2 = List();
      List<TimeStack> sl3 = List();
      List<TimeStack> sl4 = List();

      iMaxTime = 0;
      dashboard.tg.asMap().forEach((index, _tg) {
        if (iMaxTime < _tg.pointCnt) {
          iMaxTime = _tg.pointCnt;
          maxTime = "$index - ${index + 1}시";
        }
        sl1.add(TimeStack(index, _tg.pointCnt));
        sl2.add(TimeStack(index, _tg.blockCnt));
        sl3.add(TimeStack(index, _tg.deleteCnt));
        sl4.add(TimeStack(index, _tg.visitCnt));
      });

      if (mounted) {
        setState(() {
          iMaxAge = dashboard.ca.teen;
          maxAge = "10대";
          if (iMaxAge < dashboard.ca.second) {
            iMaxAge = dashboard.ca.second;
            maxAge = "20대";
          }
          if (iMaxAge < dashboard.ca.third) {
            iMaxAge = dashboard.ca.third;
            maxAge = "30대";
          }
          if (iMaxAge < dashboard.ca.forth) {
            iMaxAge = dashboard.ca.forth;
            maxAge = "40대";
          }
          if (iMaxAge < dashboard.ca.above) {
            iMaxAge = dashboard.ca.above;
            maxAge = "50대 이상";
          }

          if (dashboard.cg.m > dashboard.cg.w) {
            maxGender = "남성";
          } else {
            maxGender = "여성";
          }

          _seriesPieData = _seriesPieData1;

          _seriesStackListData.clear();
          _seriesStackListData.add(
              charts.Series<TimeStack, int>(
                data: sl1,
                id: '클릭',
                domainFn: (TimeStack task, _) => task.time,
                measureFn: (TimeStack task, _) => task.value,
                colorFn: (datum, index) =>
                    charts.ColorUtil.fromDartColor(Colors.black45),
              ));
          _seriesStackListData.add(
              charts.Series<TimeStack, int>(
                data: sl4,
                id: '방문',
                domainFn: (TimeStack task, _) => task.time,
                measureFn: (TimeStack task, _) => task.value,
              ));
          _seriesStackListData.add(
              charts.Series<TimeStack, int>(
                data: sl3,
                id: '무시',
                domainFn: (TimeStack task, _) => task.time,
                measureFn: (TimeStack task, _) => task.value,
              ));
          _seriesStackListData.add(
              charts.Series<TimeStack, int>(
                data: sl2,
                id: '차단',
                domainFn: (TimeStack task, _) => task.time,
                measureFn: (TimeStack task, _) => task.value,
              ));
          nowLeaflet = dashboard.recent;
        });
      }
    } else {
      showToast('서버 오류로 정보를 가져오지 못했습니다.');
    }

    setState(() {
      isLoading = false;
    });
  }

  void showToast(String message){
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT
    );
  }
}




class Task{
  String task;
  int taskValue;
  Color color;

  Task(this.task, this.taskValue, this.color);
}

class TimeStack{
  int time;
  int value;

  TimeStack(this.time, this.value);
}

