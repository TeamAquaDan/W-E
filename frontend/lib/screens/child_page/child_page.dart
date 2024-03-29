import 'package:flutter/material.dart';
import 'package:frontend/screens/account_book/account_book_home_page.dart';
import 'package:frontend/screens/alarm_page.dart';
import 'package:frontend/screens/child_page/child_home_page.dart';
import 'package:frontend/screens/menu_page.dart';
import 'package:frontend/screens/mission_page/my_mission_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../chat_page/chat_page.dart';

// import 'package:frontend/screens/statistics_page.dart';

class ChildPage extends StatefulWidget {
  const ChildPage({super.key});

  @override
  State<ChildPage> createState() => _ChildPageState();
}

class _ChildPageState extends State<ChildPage> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    // const MyHomePage(title: 'Whale 서비스명'),
    const ChildHomePage(), //ChildHomePage
    const AccountBookHomePage(),
    const AlarmPage(),
    const MenuPage(),
    const MyMissionPage(),
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
        selectedItemColor: const Color(0xFF3F62DE),
        unselectedItemColor: const Color(0xFF7A97FF),
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 챗봇 페이지로 이동
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ChatPage()),
          );
        },
        child: const Icon(Icons.chat_bubble_outline_rounded),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
