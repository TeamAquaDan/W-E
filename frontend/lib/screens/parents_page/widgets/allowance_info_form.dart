import 'package:flutter/material.dart';
import 'package:frontend/api/allowance/allowance_patch_api.dart';

class AllowanceInfoForm extends StatefulWidget {
  final int groupId;
  final bool isMonthly;
  final int allowanceAmt;
  final int paymentDate;

  AllowanceInfoForm({
    required this.groupId,
    required this.isMonthly,
    required this.allowanceAmt,
    required this.paymentDate,
  });

  @override
  _AllowanceInfoFormState createState() => _AllowanceInfoFormState();
}

class _AllowanceInfoFormState extends State<AllowanceInfoForm> {
  final _formKey = GlobalKey<FormState>();

  late bool _isMonthly;
  late int _allowanceAmt;
  late int _paymentDate;

  late TextEditingController _allowanceAmtController;
  late TextEditingController _paymentDateController;

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
              DropdownButtonFormField<bool>(
                value: _isMonthly,
                items: [
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
                decoration: InputDecoration(labelText: '용돈 주기'),
                validator: (value) {
                  if (value == null) {
                    return '용돈 주기를 선택하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _allowanceAmtController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: '용돈 금액'),
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
              TextFormField(
                controller: _paymentDateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: '용돈 지급일'),
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
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _submitForm();
                  }
                },
                child: Text('정보 수정'),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('용돈 정보가 성공적으로 수정되었습니다.')),
      );
    } catch (error) {
      print('용돈 정보 수정 에러: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('용돈 정보 수정 중 오류가 발생했습니다.')),
      );
    }
  }
}
