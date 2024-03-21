import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MySavingGoalForm extends StatefulWidget {
  const MySavingGoalForm({super.key});

  @override
  State<MySavingGoalForm> createState() => _MySavingGoalFormState();
}

class _MySavingGoalFormState extends State<MySavingGoalForm> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedAccount;
  final List<String> _accounts = ['계좌 A', '계좌 B', '계좌 C']; // 예시 계좌 목록
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

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_updateAmount);
  }

  void _updateAmount() {
    String plainNumber =
        _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    int? number = int.tryParse(plainNumber);
    if (number != null) {
      String formattedNumber = '${_numberFormat.format(number)}원';
      _amountController.value = TextEditingValue(
        text: formattedNumber,
        selection: TextSelection.collapsed(offset: formattedNumber.length),
      );
    }
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
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2, // 목표명 필드에 더 많은 공간을 할당
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: '목표명',
                    ),
                  ),
                ),
                const SizedBox(width: 10), // 필드 사이의 간격
                Expanded(
                  flex: 1, // 카테고리 드롭다운에 할당된 공간
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedCategoryCode,
                    hint: const Text('카테고리 선택'),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCategoryCode = newValue;
                      });
                    },
                    items: _categories.entries
                        .map<DropdownMenuItem<String>>((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    underline: Container(
                      // height: 1,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: '금액',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: DropdownButton<String>(
                    value: _selectedAccount,
                    isExpanded: true,
                    hint: const Text('출금계좌 선택'),
                    items: _accounts.map((account) {
                      return DropdownMenuItem(
                        value: account,
                        child: Text(account),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAccount = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate == null
                      ? '목표 기간을 선택하세요'
                      : '목표 기간: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                ),
                TextButton(
                  onPressed: _presentDatePicker,
                  child: const Text('날짜 선택'),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('취소'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 저장 api 구현 예정

                    Navigator.pop(context);
                  },
                  child: const Text('등록'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
