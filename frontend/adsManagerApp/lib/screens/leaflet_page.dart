import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dolligo_ads_manager/constants.dart';
import 'package:dolligo_ads_manager/models/advertiser_model.dart';
import 'package:dolligo_ads_manager/models/statatics.dart';
import 'package:dolligo_ads_manager/screens/create_leaflet_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class Leafletpage extends StatefulWidget {
  @override
  _Leafletpage createState() => _Leafletpage();
}

class _Leafletpage extends State<Leafletpage> {
  List<Statistic> leafletList = List();
  Advertiser advertiser = Advertiser();
  final DateFormat formatter = DateFormat('MM.dd hh시');
  var refreshKey = GlobalKey<RefreshIndicatorState>();


  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await _getLeafletList();

    setState(() {

    });

    return null;
  }

  @override
  void initState(){
    super.initState();
    _getLeafletList();
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
        heroTag: "create_leaflet",
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateLeafletPage()),
          )
        },
        tooltip: '전단지 추가',
        child: const Icon(Icons.add, color: kPrimaryColor,),
      ),
    );
  }

  Widget _buildBody(){
    return RefreshIndicator(
      backgroundColor: kPrimaryColor,
      key: refreshKey,
      onRefresh: refreshList,
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: leafletList.length,
          itemBuilder: (context, index){
            Statistic leaflet = leafletList[index];

            return leaflet.paper.p_image != null ? Stack(
              children: [
                Card(
                  margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    side: new BorderSide(color: kPrimaryColor, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: InkWell(
                    onTap: (){
                      print(leaflet.paper.p_image);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: leaflet.paper.p_image,
                            height: 150,
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        ),
                        ListTile(
                          title: Text(advertiser.marketname, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text.rich(TextSpan(
                            children: [
                              TextSpan(
                                text: formatter.format(leaflet.paper.starttime),
                              ),
                              TextSpan(
                                text: ' ~ '
                              ),
                              TextSpan(
                                  text: formatter.format(leaflet.paper.endtime)
                              ),
                            ]
                          )),
                          trailing: ButtonTheme(
                            minWidth: 40.0,
                            height: 40.0,
                            buttonColor: kPrimaryLightColor,
                            child: RaisedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            title : Text(advertiser.marketname, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                            subtitle: Text(leaflet.paper.p_coupon ?? "쿠폰 없음", style: TextStyle(color: Colors.lightBlue)),
                                            contentPadding: EdgeInsets.all(0),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text('배포 전단지', style: TextStyle(fontWeight: FontWeight.bold),),
                                              Text(leaflet.distributed.toString() + ' / ' + leaflet.paper.sheets.toString())
                                            ],
                                          ),
                                          // SizedBox(height: 10),
                                          DataTable(
                                            columns: [
                                              DataColumn(label: Center()),
                                              DataColumn(label: Center()),
                                              DataColumn(label: Center()),
                                            ],
                                            rows: [
                                              DataRow(
                                                  cells: [
                                                    DataCell(Center(child: Text('관심', style: TextStyle(fontWeight: FontWeight.bold),))),
                                                    DataCell(Center(child: Text('방문', style: TextStyle(fontWeight: FontWeight.bold),))),
                                                    DataCell(Center(child: Text('무시', style: TextStyle(fontWeight: FontWeight.bold),))),
                                                  ]
                                              ),
                                              DataRow(
                                                  cells: [
                                                    DataCell(
                                                        Center(
                                                            child: Text(leaflet.interest.toString())
                                                        )
                                                    ),
                                                    DataCell(
                                                        Center(
                                                            child: Text(leaflet.visit.toString())
                                                        )
                                                    ),
                                                    DataCell(
                                                        Center(
                                                            child: Text(leaflet.block.toString())
                                                        )
                                                    ),
                                                  ]
                                              ),
                                              DataRow(
                                                  cells: [
                                                    DataCell(
                                                        Center(
                                                            child: leaflet.distributed != 0 ? Text((leaflet.interest * 100 / leaflet.distributed).toStringAsFixed(1) + '%', style: TextStyle(color: Colors.lightBlue),) : Text('0.0%')
                                                        )
                                                    ),
                                                    DataCell(
                                                        Center(
                                                            child: leaflet.distributed != 0 ? Text((leaflet.visit * 100  / leaflet.distributed).toStringAsFixed(1) + '%', style: TextStyle(color: Colors.lightBlue),) : Text('0.0%')
                                                        )
                                                    ),
                                                    DataCell(
                                                        Center(
                                                            child: leaflet.distributed != 0 ? Text((leaflet.block * 100  / leaflet.distributed).toStringAsFixed(1) + '%', style: TextStyle(color: Colors.red),) : Text('0.0%')
                                                        )
                                                    ),
                                                  ]
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        RaisedButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text("닫기", style: TextStyle(color: Colors.black),),
                                          color: kPrimaryLightColor,
                                        )
                                      ],
                                      elevation: 24.0,
                                    );
                                  }
                                );
                              },
                              child: Text("전단지 확인", style: TextStyle(color: Colors.black),),
                            ),
                          )
                        ),
                      ],
                    ),
                  )
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 20.0, 0),
                  alignment: Alignment.topRight,
                  child: ButtonTheme(
                    minWidth: 40.0,
                    height: 40.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: RaisedButton(
                      onPressed: () {},
                      child: Text("${leaflet.paper.sheets}매", style: TextStyle(color: Colors.white),),
                    ),
                  )
                )
              ],
            ) : Container();
          },
        ),
      ),
    );
  }

  void _getLeafletList() async{
    String jwt = await FlutterSecureStorage().read(key: 'jwt');

    var response = await http.get('$SERVER_IP/api/token/advertiser/paper/statistic',
        headers: {'Authorization' : 'Bearer $jwt'});

    setState(() {
      leafletList = List<Map>.from(json.decode(response.body)['data']).map((m)=> Statistic.fromJson(m)).toList();
      advertiser = Advertiser.fromJson(json.decode(response.body)['data'][0]['paper']['advertiser']);
    });
  }
}




