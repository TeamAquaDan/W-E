import 'package:flutter/material.dart';
import 'package:frontend/api/nego/nego_list_api.dart';
import 'package:frontend/screens/parents_page/widgets/nego/nego_card.dart';

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
  void didUpdateWidget(NegoListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.groupId != oldWidget.groupId) {
      setState(() {
        _negoListFuture = getNegoList(groupId: widget.groupId);
      });
    }
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
          List<dynamic>? negoList = snapshot.data;
          negoList?.sort((a, b) {
            if (a['status'] == 0 && b['status'] != 0) {
              return -1;
            } else if (a['status'] != 0 && b['status'] == 0) {
              return 1;
            } else {
              // 'create_dtm' 필드를 DateTime 객체로 변환합니다.
              DateTime aTime = DateTime.parse(a['create_dtm']);
              DateTime bTime = DateTime.parse(b['create_dtm']);
              return bTime.compareTo(aTime);
            }
          });
          return ListView.builder(
            shrinkWrap: true,
            itemCount: negoList!.length,
            itemBuilder: (context, index) {
              // 각 인상 요청 항목을 표시
              Map<String, dynamic> nego = negoList[index];
              return NegoCard(nego: nego);
              // ListTile(
              //   title: Text('요청 금액: ${nego}'),
              //   subtitle: Text('요청 일시: ${nego['create_dtm']}'),
              //   onTap: () {
              //     // 인상 요청을 눌렀을 때 처리할 작업 추가
              //     _editNego(context, nego);
              //   },
              // );
            },
          );
        } else {
          return const Text('No data available');
        }
      },
    );
  }
}
