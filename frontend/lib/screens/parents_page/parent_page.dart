import 'package:flutter/material.dart';
import 'package:frontend/screens/account_book/account_book_home_page.dart';
import 'package:frontend/screens/alarm_page.dart';
import 'package:frontend/screens/menu_page.dart';
import 'package:frontend/screens/mission_page/my_mission_page.dart';
import 'package:frontend/screens/parents_page/parent_home_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../chat_page/chat_page.dart';

class ParentPage extends StatefulWidget {
  const ParentPage({super.key});

  @override
  State<ParentPage> createState() => _ParentPageState();
}

class _ParentPageState extends State<ParentPage> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    // const MyHomePage(title: 'Whale 서비스명'),
    const ParentHomePage(), //ChildHomePage
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
          // 여기에 버튼을 눌렀을 때 실행할 작업을 추가합니다.
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ChatPage()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
