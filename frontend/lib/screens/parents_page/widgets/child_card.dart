import 'package:flutter/material.dart';
import 'package:frontend/api/allowance/child_model.dart';
import 'package:frontend/api/allowance/children_api.dart';

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
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('요청 User ID: ${widget.groupId}'),
                  Text('요청 Group ID: ${widget.userId}'),
                  Text('User ID: ${childDetail.userId}'),
                  Text('Group ID: ${childDetail.groupId}'),
                  Text('${widget.groupNickname} 용돈'),
                  Text('Account Number: ${childDetail.accountNum}'),
                  Text('Is Monthly: ${childDetail.isMonthly}'),
                  Text('Allowance Amount: ${childDetail.allowanceAmt}'),
                  Text('Payment Date: ${childDetail.paymentDate}'),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
