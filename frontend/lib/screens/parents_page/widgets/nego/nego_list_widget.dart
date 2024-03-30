import 'package:flutter/material.dart';
import 'package:frontend/api/nego/nego_list_api.dart';
import 'package:frontend/screens/parents_page/parent_page.dart';
import 'package:get/get.dart';

class NegoListWidget extends StatefulWidget {
  final int groupId;

  const NegoListWidget({super.key, required this.groupId});

  @override
  _NegoListWidgetState createState() => _NegoListWidgetState();
}

class _NegoListWidgetState extends State<NegoListWidget> {
  late Future<List<dynamic>?> _negoListFuture;

  @override
  void initState() {
    super.initState();
    _negoListFuture = getNegoList(groupId: widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>?>(
      future: _negoListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // 로딩 중이면 로딩 표시
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // 에러가 발생하면 에러 메시지 출력
        } else if (snapshot.hasData) {
          List<dynamic>? negoList =
              snapshot.data?.where((item) => item['status'] == 0).toList();
          return ListView.builder(
            shrinkWrap: true,
            itemCount: negoList!.length,
            itemBuilder: (context, index) {
              // 각 인상 요청 항목을 표시
              Map<String, dynamic> nego = negoList[index];
              return ListTile(
                title: Text('요청 금액: ${nego['nego_amt']}'),
                subtitle: Text('요청 일시: ${nego['create_dtm']}'),
                onTap: () {
                  // 인상 요청을 눌렀을 때 처리할 작업 추가
                  _editNego(context, nego);
                },
              );
            },
          );
        } else {
          return const Text('No data available');
        }
      },
    );
  }

  void _editNego(BuildContext context, Map<String, dynamic> nego) async {
    // 현재 그룹 닉네임으로 텍스트 필드 초기화
    List<dynamic>? negoDetail = await getNegoDetail(
        groupId: widget.groupId,
        negoId: nego['nego_id']); // 여기에 적절한 groupId와 negoId를 입력하세요.

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        String comment = '';

        return AlertDialog(
          title: const Text("용돈 승인 요청"),
          content: Column(
            children: <Widget>[
              Text(nego.toString()),
              TextField(
                onChanged: (value) {
                  comment = value;
                },
                decoration: const InputDecoration(
                  labelText: "Comment",
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("거절"),
              onPressed: () {
                patchNego(negoId: nego['nego_id'], result: 2, comment: comment);
                Get.offAll(const ParentPage());
              },
            ),
            TextButton(
              child: const Text("승인"),
              onPressed: () {
                // 변경된 그룹 닉네임을 서버로 전송
                patchNego(negoId: nego['nego_id'], result: 1, comment: comment);
                Get.offAll(const ParentPage());
              },
            ),
          ],
        );
      },
    );
  }
}
