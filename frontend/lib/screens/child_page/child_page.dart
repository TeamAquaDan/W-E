import 'package:flutter/material.dart';
import 'package:frontend/screens/account_book/account_book_home_page.dart';
import 'package:frontend/screens/alarm_page.dart';
import 'package:frontend/screens/child_menu_page.dart';
import 'package:frontend/screens/child_page/child_home_page.dart';
import 'package:frontend/screens/dutchpay_page/dutchpay_page.dart';
import 'package:frontend/screens/menu_page.dart';
import '../chat_page/chat_page.dart';

class ChildPage extends StatefulWidget {
  const ChildPage({super.key});

  @override
  State<ChildPage> createState() => _ChildPageState();
}

class _ChildPageState extends State<ChildPage> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const ChildHomePage(),
    const AccountBookHomePage(),
    const DutchPayPage(),
    const AlarmPage(),
    ChildMenuPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _onRefreshTapped() async {
    int oldIndex = _selectedIndex;
    setState(() {
      _selectedIndex = 4;
    });
    await Future.delayed(Duration(microseconds: 1));
    setState(() {
      _selectedIndex = oldIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefreshTapped,
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: '가계부',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_2),
            label: '더치 페이',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '알림',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: '전체 메뉴',
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