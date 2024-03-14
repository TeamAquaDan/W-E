import 'package:flutter/material.dart';
import 'package:frontend/screens/alarm_page.dart';
import 'package:frontend/screens/menu_page.dart';
import 'package:frontend/screens/my_home_page.dart';
import 'package:frontend/screens/my_mission_page.dart';
import 'package:frontend/screens/parents_page/parents_home_page.dart';
// import 'package:frontend/screens/statistics_page.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    MyHomePage(title: 'Whale 서비스명'),
    // StatisticsPage(),
    ParentsHomePage(),
    AlarmPage(),
    MenuPage(),
    MyMissionPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            // backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph),
            label: '통계',
            // backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '알림',
            // backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: '전체 메뉴',
            // backgroundColor: Colors.pink,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: '미션 페이지',
            // backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF3F62DE),
        unselectedItemColor: Color(0xFF7A97FF),
        onTap: _onItemTapped,
      ),
    );
  }
}
