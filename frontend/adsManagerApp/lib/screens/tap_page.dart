import 'package:dolligo_ads_manager/screens/dashboard_page.dart';
import 'package:flutter/material.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPage createState() => _TabPage();
}

class _TabPage extends State<TabPage> {
  int _selectedIndex = 0;

  List _pages = [
    AdvDashboardPage(),
    AdvDashboardPage(),
    AdvDashboardPage(),
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
