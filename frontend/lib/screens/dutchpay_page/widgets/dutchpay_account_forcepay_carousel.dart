import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/services/dio_service.dart';
import 'package:get/get.dart';
import 'package:frontend/models/store/account/account_controller.dart';
import 'package:intl/intl.dart';

class DutchPayAccountForcepayCarousel extends StatefulWidget {
  final int dutchpayId;
  final Function callback;

  const DutchPayAccountForcepayCarousel({
    super.key,
    required this.dutchpayId,
    required this.callback,
  });

  @override
  State<DutchPayAccountForcepayCarousel> createState() =>
      _DutchPayAccountForcepayCarouselState();
}

class _DutchPayAccountForcepayCarouselState
    extends State<DutchPayAccountForcepayCarousel> {
  int _current = 0; // 현재 페이지 인덱스 상태 변수
  final CarouselController _carouselController = CarouselController();
  final TextEditingController _accountPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _accountPasswordController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AccountController accountController = Get.find<AccountController>();

    String formatNumber(int number) {
      final formatter = NumberFormat('#,###');
      return formatter.format(number);
    }

    void selectAccountAndCloseDialog() async {
      if (_current < accountController.accountsData.length) {
        var selectedAccount = accountController.accountsData[_current];
        String accountId = selectedAccount['account_id'].toString();
        String accountName = selectedAccount['account_name'].toString();
        String accountNum = selectedAccount['account_num'].toString();
        String accountPassword = _accountPasswordController.text; // 비밀번호 필드의 값

        final DioService dioService = DioService();
        try {
          print(int.parse(accountId));
          print(int.parse(accountId).runtimeType);
          print(accountNum);
          print(accountNum.runtimeType);
          print(accountPassword);
          print(accountPassword.runtimeType);
          var response = await dioService.dio.patch(
            '${baseURL}api/dutchpay/self/${widget.dutchpayId}',
            data: {
              'account_num': accountNum,
              'account_password': accountPassword,
            },
          );
          print(response);
          widget.callback();
          print('내역 추가 완료');
        } catch (err) {
          print(err);
        }
        Navigator.pop(context); // 다이얼로그 닫기
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
                  return Card(
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFFC1C7CE)),
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
                                    fontSize: 32, fontWeight: FontWeight.w700)),
                          ),
                        ],
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: TextField(
                  controller: _accountPasswordController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '계좌 비밀번호',
                    hintText: '비밀번호 입력',
                  ),
                  obscureText: true, // 비밀번호를 별표처럼 표시
                ),
              ),
              const SizedBox(height: 20),

              // "통장 선택" 버튼 추가
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Color(0xff568ef8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: selectAccountAndCloseDialog, // 계좌 선택 및 다이얼로그 닫기
                  child: const Text(
                    '통장 선택',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
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

void showAccountCarouselDialogForcePay(
    BuildContext context, int dutchpayId, Function callback) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DutchPayAccountForcepayCarousel(
        dutchpayId: dutchpayId,
        callback: callback,
      );
    },
  );
}
