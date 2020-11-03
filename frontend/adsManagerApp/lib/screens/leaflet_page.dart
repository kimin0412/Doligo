import 'package:dolligo_ads_manager/constants.dart';
import 'package:dolligo_ads_manager/screens/create_leaflet_page.dart';
import 'package:flutter/material.dart';


class Leafletpage extends StatefulWidget {
  @override
  _Leafletpage createState() => _Leafletpage();
}

class _Leafletpage extends State<Leafletpage> {
  @override
  void initState(){
    super.initState();
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
    return Container(
      child: Center(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [

          ],
        ),
      ),
    );
  }
}

