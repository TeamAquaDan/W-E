import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:frontend/models/store/account/account_controller.dart';
import 'package:intl/intl.dart';

class SavingGoalAccountCarousel extends StatelessWidget {
  final Function(String, String) onSelectAccount;

  SavingGoalAccountCarousel({required this.onSelectAccount});

  @override
  Widget build(BuildContext context) {
    final AccountController accountController = Get.find<AccountController>();

    String formatNumber(int number) {
      final formatter = NumberFormat('#,###');
      return formatter.format(number);
    }

    Future<void> _showConfirmationDialog(
        BuildContext context, String accountId, String accountName) async {
      bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('계좌 선택'),
            content: Text('이 계좌를 선택하시겠습니까?'),
            actions: <Widget>[
              TextButton(
                child: Text('취소'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  onSelectAccount(accountId, accountName); // 콜백 함수 호출
                  Navigator.of(context).pop(true); // 확인 후 다이얼로그 닫기
                },
              ),
            ],
          );
        },
      );

      if (confirmed ?? false) {
        Navigator.pop(context); // 계좌 선택 다이얼로그 닫기
      }
    }

    return Obx(() {
      if (accountController.accountsData.isNotEmpty) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              CarouselSlider.builder(
                itemCount: accountController.accountsData.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  var account = accountController.accountsData[itemIndex];
                  return GestureDetector(
                    onTap: () => _showConfirmationDialog(
                      context,
                      account['account_id'].toString(),
                      account['account_name'].toString(),
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1, color: Color(0xFFC1C7CE)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: const Color(0xFFA0CAFD),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${account['account_name']}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.more_horiz),
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                              ],
                            ),
                            Text('${account['account_num']}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black)),
                            Center(
                              child: Text(
                                  '${formatNumber(account['balance_amt'])}원',
                                  style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 200,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.85,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('닫기'),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      } else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }
}

void showAccountCarouselDialog(
    BuildContext context, Function(String, String) onSelectAccount) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SavingGoalAccountCarousel(onSelectAccount: onSelectAccount);
    },
  );
}
