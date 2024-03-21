import 'package:flutter/material.dart';

class Friends extends StatelessWidget {
  const Friends({
    super.key,
    required this.friendLoginId,
    required this.friendName,
    required this.friendProfileImg,
    required this.friendNickname,
  });

  final String friendName;
  final String friendLoginId;
  final String friendProfileImg;
  final String friendNickname;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
          color: Color.fromARGB(255, 255, 255, 255),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 16), // 왼쪽 패딩 조정
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage(friendProfileImg),
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),
              Expanded(
                // 첫 번째 텍스트와 두 번째 텍스트를 담을 공간 확장
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      friendNickname,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      '($friendName)',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '@$friendLoginId',
                style: TextStyle(
                  color: Color.fromARGB(255, 101, 92, 92),
                  fontSize: 12,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 24), // 오른쪽 여백 조정
            ],
          ),
        ),
      ],
    );
  }
}
