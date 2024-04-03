import 'package:flutter/material.dart';
import 'package:frontend/api/allowance/allowance_patch_api.dart';

class AllowanceInfoForm extends StatefulWidget {
  final int groupId;
  final String groupNickname;
  final String accountNum;
  final bool isMonthly;
  final int allowanceAmt;
  final int paymentDate;
  final Function setData;
  const AllowanceInfoForm({
    super.key,
    required this.groupId,
    required this.groupNickname,
    required this.accountNum,
    required this.isMonthly,
    required this.allowanceAmt,
    required this.paymentDate,
    required this.setData,
  });

  @override
  _AllowanceInfoFormState createState() => _AllowanceInfoFormState();
}

class _AllowanceInfoFormState extends State<AllowanceInfoForm> {
  final _formKey = GlobalKey<FormState>();

  late bool _isMonthly;
  late int _allowanceAmt;
  late int _paymentDate = 1;

  late TextEditingController _allowanceAmtController;
  late TextEditingController _paymentDateController;
  late TextEditingController groupNameController;

  @override
  void initState() {
    super.initState();
    _isMonthly = widget.isMonthly;
    _allowanceAmt = widget.allowanceAmt;
    _paymentDate = widget.paymentDate;

    _allowanceAmtController =
        TextEditingController(text: _allowanceAmt.toString());
    _paymentDateController =
        TextEditingController(text: _paymentDate.toString());
    // groupNameController.text = widget.groupNickname;
    groupNameController = TextEditingController(text: widget.groupNickname);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController accountNum =
        TextEditingController(text: widget.accountNum);
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
              const SizedBox(height: 16),
              const Text(
                '아이 정보 수정하기',
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Aggro',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: groupNameController,
                decoration: const InputDecoration(labelText: '아이 이름'),
              ),
              const SizedBox(height: 12),
              TextField(
                // controller: groupNameController,
                controller: accountNum,
                readOnly: true,
                decoration: const InputDecoration(labelText: '계좌번호'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<bool>(
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
                          _paymentDate = 1;
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
                  ),
                  // const SizedBox(height: 12),
                  Expanded(
                    flex: 1,
                    child: _isMonthly
                        ? TextFormField(
                            controller: _paymentDateController,
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(labelText: '용돈 지급일'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '용돈 지급일을 입력하세요';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _paymentDate = int.parse(value!);
                            },
                          )
                        : DropdownButtonFormField<int>(
                            value: _paymentDate,
                            items: [
                              for (int i = 1; i <= 7; i++)
                                DropdownMenuItem(
                                  value: i,
                                  child: Text(
                                    {
                                      1: '월요일',
                                      2: '화요일',
                                      3: '수요일',
                                      4: '목요일',
                                      5: '금요일',
                                      6: '토요일',
                                      7: '일요일',
                                    }[i]!,
                                  ),
                                ),
                            ],
                            onChanged: (int? value) {
                              setState(() {
                                _paymentDate = value!;
                              });
                            },
                            decoration:
                                const InputDecoration(labelText: '용돈 지급일'),
                            validator: (value) {
                              if (value == null) {
                                return '용돈 지급일을 선택하세요';
                              }
                              return null;
                            },
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _allowanceAmtController,
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
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color(0xFF568EF8)), // 버튼 색상 변경
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // 테두리 반경 설정
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _submitForm();
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '정보 수정',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: 'GangwonEduPower',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    try {
      await patchAllowanceInfo(
        groupId: widget.groupId,
        isMonthly: _isMonthly,
        allowanceAmt: _allowanceAmt,
        paymentDate: _paymentDate,
      );
      if (groupNameController.text != widget.groupNickname) {
        await patchAllowanceNickname(
          groupId: widget.groupId,
          groupNickname: groupNameController.text,
        );
      }

      await widget.setData();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('용돈 정보가 성공적으로 수정되었습니다.')),
      );
    } catch (error) {
      print('용돈 정보 수정 에러: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('용돈 정보 수정 중 오류가 발생했습니다.')),
      );
    }
  }
}
