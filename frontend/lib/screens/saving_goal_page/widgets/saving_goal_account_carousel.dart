import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:frontend/models/store/account/account_controller.dart';
import 'package:intl/intl.dart';

class SavingGoalAccountCarousel extends StatefulWidget {
  final Function(String, String, String) onSelectAccount;

  const SavingGoalAccountCarousel({super.key, required this.onSelectAccount});

  @override
  State<SavingGoalAccountCarousel> createState() =>
      _SavingGoalAccountCarouselState();
}

class _SavingGoalAccountCarouselState extends State<SavingGoalAccountCarousel> {
  int _current = 0; // 현재 페이지 인덱스 상태 변수
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final AccountController accountController = Get.find<AccountController>();

    String formatNumber(int number) {
      final formatter = NumberFormat('#,###');
      return formatter.format(number);
    }

    Future<void> showConfirmationDialog(BuildContext context, String accountId,
        String accountName, String accountNum) async {
      bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('계좌 선택'),
            content: const Text('이 계좌를 선택하시겠습니까?'),
            actions: <Widget>[
              TextButton(
                child: const Text('취소'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: const Text('확인'),
                onPressed: () {
                  widget.onSelectAccount(
                      accountId, accountName, accountNum); // 콜백 함수 호출
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
              const SizedBox(height: 20),
              CarouselSlider.builder(
                itemCount: accountController.accountsData.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  var account = accountController.accountsData[itemIndex];
                  return GestureDetector(
                    onTap: () => showConfirmationDialog(
                      context,
                      account['account_id'].toString(),
                      account['account_name'].toString(),
                      account['account_num'].toString(),
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
                                  constraints: const BoxConstraints(),
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
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index; // 현재 페이지 인덱스 업데이트
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    accountController.accountsData.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _carouselController.animateToPage(entry.key),
                    child: Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withOpacity(_current == entry.key ? 0.9 : 0.4),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('닫기'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }
}

void showAccountCarouselDialog(
    BuildContext context, Function(String, String, String) onSelectAccount) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SavingGoalAccountCarousel(onSelectAccount: onSelectAccount);
    },
  );
}
