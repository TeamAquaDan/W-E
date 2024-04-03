import 'package:flutter/material.dart';
import 'package:frontend/api/account_book/account_book_api.dart';
import 'package:frontend/screens/account_book/form_account_book.dart';
import 'package:frontend/screens/account_book/widgets/account_book_card.dart';
import 'package:frontend/screens/chart_page/chart_page.dart';
import 'package:frontend/widgets/custom_tab_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class AccountBookHomePage extends StatefulWidget {
  const AccountBookHomePage({super.key});

  @override
  State<AccountBookHomePage> createState() => _AccountBookHomePageState();
}

class _AccountBookHomePageState extends State<AccountBookHomePage> {
  Map<String, dynamic> responseChartData = {};
  Map<String, dynamic> responseData = {};
  int year = DateTime.now().year;
  int month = DateTime.now().month;
  final formatter = NumberFormat('###,###,###,### 원');
  bool _isLoading = true;
  int tabState = 0;
  List<dynamic>? filteredData;
  int selectedTabIndex = 0;
  @override
  void initState() {
    super.initState();
    fetchData(year, month);
  }

  void fetchData(int year, int month) async {
    try {
      var response = await getAccountBookChart(year, month);
      var response2 = await getAccountBook(year, month);

      if (response != null && response['data'] != null) {
        var incomeAmt = response['data']['income_amt'];
        // 여기에 incomeAmt를 처리하는 코드를 추가하세요.
      }

      setState(() {
        responseChartData = response;
        responseData = response2;
      });
      // debugPrint('데이터 통신 결과 $responseChartData');
      // debugPrint('데이터 통신 결과 $responseData');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void refreshData() {
    fetchData(year, month);
  }

  void onTabChanged(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (responseData['data'] != null) {
      filteredData = responseData['data']['account_book_list'];
      switch (tabState) {
        case 0:
          filteredData = responseData['data']['account_book_list'];
          break;
        case 1:
          filteredData = responseData['data']['account_book_list']
              .where((item) => item['account_book_category'] == '100')
              .toList();
          break;
        case 2:
          filteredData = responseData['data']['account_book_list']
              .where((item) => item['account_book_category'] != '100')
              .toList();
          break;
        default:
          filteredData = responseData['data']['account_book_list'];
      }
    }
    return _isLoading
        ? Container()
        : Scaffold(
            appBar: AppBar(
                // automaticallyImplyLeading: false,
                centerTitle: true,
                title: selectedTabIndex == 0
                    ? const Text('가계부')
                    : const Text('통계')),
            body: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    CustomTabBar(
                        selectedTabIndex: selectedTabIndex,
                        onTabChanged: onTabChanged,
                        tabLabels: ['가계부', '통계']),
                    selectedTabIndex == 0
                        ? Column(
                            children: [
                              Card(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                color: const Color(0xFF568EF8),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showMonthPicker(
                                          context: context,
                                          firstDate: DateTime(
                                              DateTime.now().year - 1, 1),
                                          lastDate: DateTime(
                                              DateTime.now().year + 1, 12),
                                          initialDate: DateTime.now(),
                                        ).then((date) {
                                          if (date != null) {
                                            year = date.year;
                                            month = date.month;
                                            refreshData(); // 데이터 갱신
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 24),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '$year년',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontFamily: 'Aggro',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              '$month월',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 33,
                                                fontFamily: 'Aggro',
                                                fontWeight: FontWeight.w700,
                                                height: 0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 1.5, // 원하는 너비로 설정
                                      height: 70,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '수입: ${formatter.format(responseData['data']['income_amt'])}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontFamily: 'Aggro',
                                              fontWeight: FontWeight.w400,
                                              height: 0,
                                            ),
                                          ),
                                          Text(
                                            '지출: ${formatter.format(responseData['data']['expense_amt'])}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontFamily: 'Aggro',
                                              fontWeight: FontWeight.w400,
                                              height: 0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // AccountBookChart(data: responseChartData),
                              const SizedBox(height: 8),
                              // Text(responseData.toString()),
                              // AccountBookTable(
                              //   data: responseData,
                              //   setData: refreshData,
                              // ),
                              Container(
                                height: 41,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                padding: const EdgeInsets.all(0),
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFD9D9D9),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: FilledButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .all<Color>(tabState == 0
                                                  ? const Color(0xFF568EF8)
                                                  : const Color(0xFFD9D9D9)),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      14), // 원하는 반경으로 변경
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            tabState = 0;
                                          });
                                        },
                                        child: Text(
                                          '전체 내역',
                                          style: TextStyle(
                                            color: tabState == 0
                                                ? Colors.white
                                                : const Color(0xFF3c3c3c),
                                            fontSize: 15,
                                            fontFamily: 'Aggro',
                                            fontWeight: FontWeight.w700,
                                            height: 0.07,
                                            letterSpacing: 0.40,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: FilledButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .all<Color>(tabState == 1
                                                  ? const Color(0xFF568EF8)
                                                  : const Color(0xFFD9D9D9)),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      14), // 원하는 반경으로 변경
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            tabState = 1;
                                          });
                                        },
                                        child: Text(
                                          '수입',
                                          style: TextStyle(
                                            color: tabState == 1
                                                ? Colors.white
                                                : const Color(0xFF3c3c3c),
                                            fontSize: 15,
                                            fontFamily: 'Aggro',
                                            fontWeight: FontWeight.w700,
                                            height: 0.07,
                                            letterSpacing: 0.40,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: FilledButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .all<Color>(tabState == 2
                                                  ? const Color(0xFF568EF8)
                                                  : const Color(0xFFD9D9D9)),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      14), // 원하는 반경으로 변경
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            tabState = 2;
                                          });
                                        },
                                        child: Text(
                                          '지출',
                                          style: TextStyle(
                                            color: tabState == 2
                                                ? Colors.white
                                                : const Color(0xFF3c3c3c),
                                            fontSize: 15,
                                            fontFamily: 'Aggro',
                                            fontWeight: FontWeight.w700,
                                            height: 0.07,
                                            letterSpacing: 0.40,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              AccountBookCard(
                                data: filteredData ?? [],
                              )
                            ],
                          )
                        : ChartPage(),
                  ],
                )),
          );
  }
}
