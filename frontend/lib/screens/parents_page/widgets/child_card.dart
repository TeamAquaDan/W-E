import 'package:flutter/material.dart';
import 'package:frontend/api/allowance/child_model.dart';
import 'package:frontend/api/allowance/children_api.dart';
import 'package:intl/intl.dart';

class ChildCard extends StatefulWidget {
  final int groupId;
  final int userId;
  final String groupNickname;
  const ChildCard(
      {Key? key,
      required this.groupId,
      required this.userId,
      required this.groupNickname})
      : super(key: key);

  @override
  _ChildCardState createState() => _ChildCardState();
}

class _ChildCardState extends State<ChildCard> {
  late Future<ChildDetail> _childDetailFuture;

  @override
  void initState() {
    super.initState();
    _childDetailFuture = getChildDetail(widget.groupId, widget.userId);
  }

  var moneyFormat = NumberFormat('###,###,###,### 원');
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ChildDetail>(
      future: _childDetailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // 로딩 중이면 로딩 표시
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // 에러가 발생하면 에러 메시지 출력
        } else {
          // 데이터가 성공적으로 로드되면 카드를 출력
          ChildDetail childDetail = snapshot.data!;
          return Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFC1C7CE)),
              borderRadius: BorderRadius.circular(20),
            ),
            color: const Color(0xFF7A97FF),
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text('요청 User ID: ${widget.groupId}'),
                  // Text('요청 Group ID: ${widget.userId}'),
                  // Text('User ID: ${childDetail.userId}'),
                  // Text('Group ID: ${childDetail.groupId}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.groupNickname} 용돈',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          '수정하기',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text('자녀 계좌 번호: ${childDetail.accountNum}'),
                  Text(
                    '${childDetail.isMonthly //
                        ? '매달 ${childDetail.paymentDate}일' //
                        : '매주 ${_convertToDayOfWeek(childDetail.paymentDate)}요일'}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        moneyFormat.format(childDetail.allowanceAmt),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      FilledButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFF3F62DE)),
                        ),
                        onPressed: () {},
                        child: const Text(
                          '이체',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  String _convertToDayOfWeek(int day) {
    switch (day) {
      case 1:
        return '월';
      case 2:
        return '화';
      case 3:
        return '수';
      case 4:
        return '목';
      case 5:
        return '금';
      case 6:
        return '토';
      case 7:
        return '일';
      default:
        return '';
    }
  }
}
