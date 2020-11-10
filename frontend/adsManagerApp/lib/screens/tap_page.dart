import 'package:dolligo_ads_manager/screens/dashboard_page.dart';
import 'package:dolligo_ads_manager/screens/leaflet_page.dart';
import 'package:dolligo_ads_manager/screens/setting_page.dart';
import 'package:flutter/material.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPage createState() => _TabPage();
}

class _TabPage extends State<TabPage> {
  int _selectedIndex = 0;

  List<Widget> _pages = [
    AdvDashboardPage(),
    Leafletpage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Center(child: _pages[_selectedIndex]),\
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
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
