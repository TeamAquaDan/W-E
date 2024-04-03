import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/api/save/goal_add_api.dart';
import 'package:frontend/models/save/goal_add.dart';
import 'package:frontend/models/store/account/account_controller.dart';
import 'package:frontend/screens/saving_goal_page/widgets/saving_goal_account_carousel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MySavingGoalForm extends StatefulWidget {
  const MySavingGoalForm({super.key, required this.onAddGoal});

  final VoidCallback onAddGoal;

  @override
  State<MySavingGoalForm> createState() => _MySavingGoalFormState();
}

class _MySavingGoalFormState extends State<MySavingGoalForm> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedAccount;
  String? _selectedAccountName;
  String? _selectedAccountNum;
  String? _selectedCategoryCode; // 선택된 카테고리 코드
  final NumberFormat _numberFormat = NumberFormat.decimalPattern('ko');

  // 카테고리 코드와 이름 매핑
  final Map<String, String> _categories = {
    "001": "선물",
    "002": "전자기기",
    "003": "문구류",
    "004": "의류",
    "005": "게임",
    "006": "생활용품",
    "007": "음식",
    "008": "도서",
    "009": "악세사리",
    "010": "화장품",
    "000": "기타"
  };

  final Map<String, dynamic> _categoryImoge = {
    "001": "🎁",
    "002": "📱",
    "003": "📎",
    "004": "👕",
    "005": "🎮",
    "006": "🏠",
    "007": "🍔",
    "008": "📚",
    "009": "💍",
    "010": "💄",
    "000": "🐳"
  };

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_updateAmount);
    Get.put(AccountController()).fetchAccounts();
  }

  void _updateAmount() {
    // 사용자 입력에서 숫자만 추출합니다.
    String plainNumber =
        _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    // 추출된 숫자에 대해 콤마를 포함한 포맷을 적용합니다.
    String formattedNumber =
        plainNumber.isEmpty ? '' : _numberFormat.format(int.parse(plainNumber));

    // 커서의 현재 위치를 계산합니다.
    int cursorPosition = _amountController.selection.start;
    // 콤마를 추가하기 전과 후의 숫자 길이 차이를 계산합니다.
    int offset = formattedNumber.length - plainNumber.length;

    // 포맷된 텍스트를 설정하고, 커서 위치를 조정합니다.
    // 이는 사용자가 숫자를 입력하거나 삭제할 때 커서가 적절한 위치에 있도록 합니다.
    _amountController.value = TextEditingValue(
      text: formattedNumber,
      // 사용자가 텍스트를 수정할 때 커서 위치를 유지하도록 조정합니다.
      selection: TextSelection.collapsed(
          offset: max(0, min(cursorPosition + offset, formattedNumber.length))),
    );
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _showAccountSelection() {
    showAccountCarouselDialog(context,
        (String accountId, String accountName, String accountNum) {
      // 계좌 ID와 이름을 상태 변수에 저장
      print("Selected Account ID: $accountId, Account Name: $accountName");
      setState(() {
        _selectedAccount = accountId;
        _selectedAccountName = accountName; // 계좌 이름 저장
        _selectedAccountNum = accountNum;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 20.0,
        top: 20.0,
        right: 20.0,
        bottom: 20.0 + bottomPadding,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '저축 목표 등록하기',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2, // 목표명 필드에 더 많은 공간을 할당
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '목표 이름',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff777777),
                        ),
                      ),
                      TextField(
                        controller: _controller,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10), // 필드 사이의 간격
                Expanded(
                  flex: 1, // 카테고리 드롭다운에 할당된 공간
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '카테고리',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff777777),
                        ),
                      ),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedCategoryCode,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategoryCode = newValue;
                          });
                        },
                        items: _categories.entries
                            .map<DropdownMenuItem<String>>((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.key,
                            child: Text(
                              entry.value,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        }).toList(),
                        underline: Container(
                          // height: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('계좌선택',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff777777),
                          )),
                      Row(
                        children: [
                          _selectedAccountNum == null
                              ? TextButton(
                                  onPressed: _showAccountSelection,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.payment,
                                        color: Colors.black,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        '계좌를 선택하세요',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : TextButton(
                                  onPressed: _showAccountSelection,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.payment,
                                        color: Colors.black,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        '${_selectedAccountNum}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          // IconButton(
                          //   onPressed: _showAccountSelection,
                          //   icon: Icon(Icons.payment),
                          // ),
                          // Text(
                          //   _selectedAccountNum ?? '계좌를 선택하세요',
                          //   style: TextStyle(
                          //     fontSize: 15,
                          //     fontWeight: FontWeight.w700,
                          //   ),
                          // ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '목표 기간',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff777777),
                        ),
                      ),
                      Row(
                        children: [
                          _selectedDate == null
                              ? TextButton(
                                  onPressed: _presentDatePicker,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.date_range,
                                        color: Colors.black,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        '목표 기간을 선택하세요',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : TextButton(
                                  onPressed: _presentDatePicker,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.date_range,
                                        color: Colors.black,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        '목표 기간: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                )
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '금액',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff777777),
                        ),
                      ),
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xff568EF8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () async {
                      int goalAmt = int.parse(_amountController.text
                          .replaceAll(RegExp(r'[^0-9]'), ''));
                      String categoryCode = _selectedCategoryCode ?? '';
                      int accountId = int.parse(_selectedAccount ?? '');

                      // _selectedDate를 "yyyy-MM-dd" 형식의 문자열로 변환합니다.
                      String formattedGoalDate = _selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                          : '';

                      PostAddGoalBody goalBody = PostAddGoalBody(
                        goal_name: _controller.text,
                        goal_amt: goalAmt,
                        goal_date: formattedGoalDate, // 변환된 날짜 문자열을 사용합니다.
                        category: categoryCode,
                        account_id: accountId,
                      );

                      try {
                        print(
                            'Goal Name: ${goalBody.goal_name}, Type: ${goalBody.goal_name.runtimeType}');
                        print(
                            'Goal Amount: ${goalBody.goal_amt}, Type: ${goalBody.goal_amt.runtimeType}');
                        print(
                            'Goal Date: ${goalBody.goal_date}, Type: ${goalBody.goal_date.runtimeType}');
                        print(
                            'Category: ${goalBody.category}, Type: ${goalBody.category.runtimeType}');
                        print(
                            'Account ID: ${goalBody.account_id}, Type: ${goalBody.account_id.runtimeType}');

                        var response = await postGoal(goalBody);
                        if (response != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("목표가 성공적으로 등록되었습니다!")),
                          );
                          widget.onAddGoal();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("목표 등록에 실패했습니다.")),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("오류가 발생했습니다: $e")),
                        );
                      }
                      Navigator.pop(context);
                    },
                    child: const Text(
                      '등록하기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
