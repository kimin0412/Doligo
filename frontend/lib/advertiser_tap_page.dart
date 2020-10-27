import 'package:flutter/material.dart';
import 'package:frontend/advertiser_dashboard.dart';
import 'package:frontend/home_page.dart';
import 'package:frontend/leaflet_page.dart';
import 'package:frontend/setting_page.dart';

class AdvertiserTabPage extends StatefulWidget {
  @override
  _AdvertiserTabPage createState() => _AdvertiserTabPage();
}

class _AdvertiserTabPage extends State<AdvertiserTabPage> {
  int _selectedIndex = 0;

  List _pages = [
    AdvertiserDashboardPage(),
    AdvertiserDashboardPage(),
    AdvertiserDashboardPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '대시보드'),
            BottomNavigationBarItem(icon: Icon(Icons.ballot), label: '전단지 관리'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정')
          ]),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
