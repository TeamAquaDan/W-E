import 'package:flutter/material.dart';
import 'package:frontend/screens/account_book/account_book_home_page.dart';
import 'package:frontend/screens/alarm_page.dart';
import 'package:frontend/screens/parent_menu_page.dart';
import 'package:frontend/screens/parents_page/children_page/children_carousel.dart';
import 'package:frontend/screens/parents_page/parent_home_page.dart';

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
    const ChildrenManagePage2(),
    const AlarmPage(),
    ParentMenuPage(),
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
            label: '홈',
            // backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: '가계부',
            // backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.family_restroom),
            label: '아이 관리',
            // backgroundColor: Colors.pink,
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
            MaterialPageRoute(builder: (context) => const ChatPage()),
          );
        },
        backgroundColor: Colors.blue,
        child: Transform(
          transform: Matrix4.identity()..scale(-1.0, 1.0),
          alignment: Alignment.center,
          child: Icon(
            Icons.chat_bubble,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
