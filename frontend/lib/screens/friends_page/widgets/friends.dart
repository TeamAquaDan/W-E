import 'package:flutter/material.dart';
import 'package:frontend/screens/friends_page/widgets/change_nickname_friends.dart';

class Friends extends StatelessWidget {
  const Friends({
    super.key,
    required this.friendId,
    required this.friendLoginId,
    required this.friendName,
    required this.friendProfileImg,
    required this.friendNickname,
    required this.loadFriendsCallback,
  });

  final int friendId;
  final String friendName;
  final String friendLoginId;
  final String friendProfileImg;
  final String friendNickname;
  final Function loadFriendsCallback;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFF568EF8),
          ),
          height: 70,
          margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 16), // 왼쪽 패딩 조정
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage(friendProfileImg.isNotEmpty
                          ? friendProfileImg
                          : 'https://example.com/default-image.png'),
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                // 첫 번째 텍스트와 두 번째 텍스트를 담을 공간 확장
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      friendNickname.isEmpty ? friendName : friendNickname,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '($friendName)',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showChangeNicknameFriendsDialog(context, friendNickname,
                            friendId, loadFriendsCallback);
                      },
                      icon: const Icon(Icons.edit),
                      color: Colors.white38,
                    )
                  ],
                ),
              ),

              const SizedBox(width: 24), // 오른쪽 여백 조정
            ],
          ),
        ),
      ],
    );
  }
}
