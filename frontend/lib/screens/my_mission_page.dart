import 'package:flutter/material.dart';

class MyMissionPage extends StatefulWidget {
  const MyMissionPage({super.key});

  @override
  State<MyMissionPage> createState() {
    return _MyMissionPageState();
  }
}

class _MyMissionPageState extends State<MyMissionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20), // Spacing
              Row(
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
                  Text(
                    '미션 목록',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 38), // Spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 70), // Align as needed
                    child: Text(
                      '진행 중',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Spacer(), // Use Spacer for flexible spacing
                  Padding(
                    padding: EdgeInsets.only(right: 70), // Align as needed
                    child: Text(
                      '완료 됨',
                      style: TextStyle(
                        color: Color(0xFF8C8C8C),
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 22), // Spacing
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '미션으로 35,000원을 얻을 수 있어요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 22), // Spacing

              SizedBox(height: 20), // Spacing
              Text(
                '스크롤',
                style: TextStyle(
                  color: Color(0xFF6E6363),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
