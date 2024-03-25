import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:frontend/api/account/account_list_api.dart';
import 'package:frontend/api/save/goal_add_api.dart';
import 'package:frontend/models/account/account_list_data.dart';
import 'package:frontend/models/save/goal_add.dart';

class GoalAddForm extends StatefulWidget {
  @override
  _GoalAddFormState createState() => _GoalAddFormState();
}

class _GoalAddFormState extends State<GoalAddForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late List<AccountListData> _accountList = [];
  late int _selectedAccountId = 0;
  late String _selectedCategory = '';
  late DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchAccountList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchAccountList() async {
    List<AccountListData>? accountList =
        await getAccountListData('your_access_token_here');
    if (accountList != null) {
      setState(() {
        _accountList = accountList;
        _selectedAccountId =
            _accountList.isNotEmpty ? _accountList[0].account_id : 0;
      });
    } else {
      // Handle error
    }
  }

  Future<void> _submitGoal() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final PostAddGoalBody goalBody = PostAddGoalBody(
        goal_name: _goalName,
        goal_amt: int.parse(_goalAmt),
        goal_date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        category: _selectedCategory,
        account_id: _selectedAccountId,
      );

      try {
        await postGoal(goalBody);
        // Goal added successfully, close the page
        Navigator.of(context).pop();
      } catch (e) {
        Get.snackbar('목표 등록 오류', '다시 시도해 주세요');
      }
    }
  }

  String _goalName = '';
  String _goalAmt = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Goal Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal name';
                  }
                  return null;
                },
                onSaved: (newValue) => _goalName = newValue!,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Goal Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal amount';
                  }
                  return null;
                },
                onSaved: (newValue) => _goalAmt = newValue!,
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  'Goal Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: <String>[
                  '',
                  '선물',
                  '전자기기',
                  '문구류',
                  '의류',
                  '게임',
                  '생활용품',
                  '음식',
                  '도서',
                  '악세사리',
                  '화장품',
                  '기타'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Select Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: _selectedAccountId,
                onChanged: (newValue) {
                  setState(() {
                    _selectedAccountId = newValue!;
                  });
                },
                items: _accountList.map((AccountListData account) {
                  return DropdownMenuItem<int>(
                    value: account.account_id,
                    child: Text(account.account_name),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Select Account'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitGoal,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }
}
