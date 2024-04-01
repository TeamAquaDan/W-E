import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/screens/account_book/widgets/account_book_card2.dart';
import 'package:intl/intl.dart';

class AccountBookTable extends StatefulWidget {
  const AccountBookTable(
      {super.key, required this.data, required this.setData});
  final Map<String, dynamic> data;
  final Function setData;

  @override
  _AccountBookTableState createState() => _AccountBookTableState();
}

class _AccountBookTableState extends State<AccountBookTable>
    with TickerProviderStateMixin {
  final formatter = NumberFormat('###,###,###,### 원');
  late TabController _tabController;

  @override
  void initState() {
    // 선택된 탭과 컨텐츠 섹션이 동기화를 TabController 가 수행해 줌.
    _tabController = TabController(
      length: 3, // 탭의 전체 길이
      vsync: this, // TickerProvider 가 widget 을 다시 그리기 위한 파라미터임.
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.data.isEmpty
        ? const SizedBox(
            width: 100, height: 100, child: CircularProgressIndicator())
        : Column(
            children: [
              TabBar(
                labelColor: const Color(0xFF4EACF8), // 선택된 탭의 색상
                unselectedLabelColor: Colors.black, // 선택되지 않은 택의 색상
                controller: _tabController,
                tabs: [
                  Container(
                    // 탭의 크기를 위해 Container로 감쌈
                    alignment: Alignment.center,
                    height: 40,
                    // 탭의 크기를 위해 Container로 감쌈
                    child: const Text("정보"),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 40,
                    child: const Text("리뷰"),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 40,
                    child: const Text("리뷰"),
                  ),
                ],
              ),
              Expanded(
                // 페이지가 Column 의 남은 공간을 모두 사용할 수 있도록 Expanded로 TabBarView 를 감쌉니다.
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                              width: 200, height: 300, child: Text('data')),
                        ],
                      ),
                    ),
                    Container(),
                    Container(),
                  ],
                ),
              ),
            ],
          );
  }
}
