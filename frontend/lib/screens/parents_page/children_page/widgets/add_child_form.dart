import 'package:flutter/material.dart';
import 'package:frontend/api/account/account_list_api.dart';
import 'package:frontend/api/allowance/add_child_api.dart';
import 'package:frontend/models/account/account_list_data.dart';

class AddChildForm extends StatefulWidget {
  const AddChildForm({super.key});

  @override
  _AddChildFormState createState() => _AddChildFormState();
}

class _AddChildFormState extends State<AddChildForm> {
  final _formKey = GlobalKey<FormState>();

  late int _groupId;
  late String _groupNickname;
  late bool _isMonthly = false;
  late int _allowanceAmt;
  late int _paymentDate = 1;
  late AccountListData _selectedAccount = AccountListData.initial();
  late List<AccountListData> _accountList = [];
  late String _accountPassword;

  @override
  void initState() {
    super.initState();
    _loadAccountList();
  }

  Future<void> _loadAccountList() async {
    List<AccountListData>? accountList = await getAccountListData('a');
    if (accountList != null && accountList.isNotEmpty) {
      setState(() {
        _accountList = accountList;
        _selectedAccount = _accountList[0]; // Add this line
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '아이의 아이디'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '아이의 아이디를 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  _groupId = int.parse(value!);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: '그룹 별칭'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '그룹 별칭을 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  _groupNickname = value!;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '용돈 금액'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '용돈 금액을 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  _allowanceAmt = int.parse(value!);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<bool>(
                value: _isMonthly,
                items: const [
                  DropdownMenuItem(
                    value: true,
                    child: Text('매월'),
                  ),
                  DropdownMenuItem(
                    value: false,
                    child: Text('매주'),
                  ),
                ],
                onChanged: (bool? value) {
                  setState(() {
                    _isMonthly = value!;
                  });
                },
                decoration: const InputDecoration(labelText: '용돈 주기'),
                validator: (value) {
                  if (value == null) {
                    return '용돈 주기를 선택하세요';
                  }
                  return null;
                },
              ),
              if (!_isMonthly) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: _paymentDate,
                  items: List.generate(7, (index) {
                    return DropdownMenuItem(
                      value: index + 1,
                      child: Text('${index + 1}'),
                    );
                  }),
                  onChanged: (int? value) {
                    setState(() {
                      _paymentDate = value!;
                    });
                  },
                  decoration: const InputDecoration(labelText: '용돈 지급일'),
                  validator: (value) {
                    if (value == null) {
                      return '용돈 지급일을 선택하세요';
                    }
                    return null;
                  },
                ),
              ] else ...[
                const SizedBox(height: 12),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: '용돈 지급일'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '용돈 지급일을 입력하세요';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _paymentDate = int.parse(value!);
                  },
                ),
              ],
              const SizedBox(height: 12),
              DropdownButtonFormField<AccountListData>(
                value: _selectedAccount,
                items: _accountList.map((account) {
                  return DropdownMenuItem<AccountListData>(
                    value: account,
                    child: Text(account.account_name),
                  );
                }).toList(),
                onChanged: (AccountListData? value) {
                  setState(() {
                    _selectedAccount = value!;
                  });
                },
                decoration: const InputDecoration(labelText: '출금 계좌'),
                validator: (value) {
                  if (value == null) {
                    return '출금 계좌를 선택하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '출금 계좌 비밀번호'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '출금 계좌 비밀번호를 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  _accountPassword = value!;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _submitForm();
                  }
                },
                child: const Text('제출'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    try {
      await addChild(
        userId: _groupId,
        groupNickname: _groupNickname,
        isMonthly: _isMonthly,
        allowanceAmt: _allowanceAmt,
        paymentDate: _paymentDate,
        accountId: _selectedAccount.account_id,
        accountNum: _selectedAccount.account_num,
        accountPassword: _accountPassword,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이 정보가 성공적으로 추가되었습니다.')),
      );
    } catch (error) {
      print('아이 정보 추가 에러: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이 정보 추가 중 오류가 발생했습니다.')),
      );
    }
  }
}
