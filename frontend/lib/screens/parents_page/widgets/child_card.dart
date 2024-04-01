import 'package:flutter/material.dart';
import 'package:frontend/api/allowance/allowance_patch_api.dart';
import 'package:frontend/api/allowance/child_model.dart';
import 'package:frontend/api/allowance/children_api.dart';
import 'package:frontend/screens/parents_page/widgets/allowance_info_form.dart';
import 'package:frontend/screens/transfer_page/gruop_transfer_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChildCard extends StatefulWidget {
  final int groupId;
  final int userId;
  String groupNickname;
  ChildCard(
      {super.key,
      required this.groupId,
      required this.userId,
      required this.groupNickname});

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

  void setData() {
    Future<ChildDetail> newChildDetailFuture =
        getChildDetail(widget.groupId, widget.userId);
    newChildDetailFuture.then((newChildDetail) {
      setState(() {
        _childDetailFuture = Future.value(newChildDetail);
      });
    });
  }

  var moneyFormat = NumberFormat('###,###,###,### 원');
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ChildDetail>(
      future: _childDetailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator()); // 로딩 중이면 로딩 표시
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
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(
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
                      Row(
                        children: [
                          Text(
                            widget.groupNickname,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: 'SB Aggro',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          // IconButton(
                          //     onPressed: () {
                          //       _editGroupName(context);
                          //     },
                          //     icon: const Icon(
                          //       Icons.edit,
                          //       color: Colors.white,
                          //     ))
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) =>
                                  AllowanceInfoForm(
                                    groupId: widget.groupId,
                                    groupNickname: widget.groupNickname,
                                    accountNum: childDetail.accountNum,
                                    isMonthly: childDetail.isMonthly,
                                    allowanceAmt: childDetail.allowanceAmt,
                                    paymentDate: childDetail.paymentDate,
                                    setData: setData,
                                  ),
                              isScrollControlled: true);
                        },
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    childDetail.accountNum,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: 'SB Aggro',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '용돈 지급 : ${childDetail.isMonthly //
                        ? '매달 ${childDetail.paymentDate}일' //
                        : '매주 ${_convertToDayOfWeek(childDetail.paymentDate)}요일'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'SB Aggro',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        moneyFormat.format(childDetail.allowanceAmt),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'SB Aggro',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.all(8),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          Get.to(GroupTransferPage(
                            accountNum: childDetail.accountNum,
                          ));
                        },
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

  void _editGroupName(BuildContext context) async {
    TextEditingController groupNameController = TextEditingController();
    groupNameController.text = widget.groupNickname; // 현재 그룹 닉네임으로 텍스트 필드 초기화

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("그룹 닉네임 수정"),
          content: TextField(
            controller: groupNameController,
            decoration: const InputDecoration(
              hintText: "새로운 그룹 닉네임 입력",
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("취소"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("저장"),
              onPressed: () {
                // 변경된 그룹 닉네임을 서버로 전송
                _updateGroupName(groupNameController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateGroupName(String newGroupName) async {
    try {
      print('그룹별칭 수정 ${widget.groupId} $newGroupName');
      await patchAllowanceNickname(
        groupId: widget.groupId,
        groupNickname: newGroupName,
      );
      setState(() {
        widget.groupNickname = newGroupName; // 그룹 닉네임을 업데이트합니다.
      });
      // 성공적으로 서버로 그룹 닉네임을 업데이트한 경우
      // 여기에 필요한 작업을 수행할 수 있습니다.
      // 예: 화면 갱신 또는 다른 작업 수행
    } catch (error) {
      // 서버 통신 중 오류가 발생한 경우
      print('그룹 닉네임 업데이트 오류: $error');
      // 오류 처리를 위한 추가적인 작업 수행 가능
    }
  }
}
