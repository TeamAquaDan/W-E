import 'package:flutter/material.dart';
import 'package:frontend/models/account/bank_code.dart';

class BankCodeButton extends StatefulWidget {
  const BankCodeButton(
      {super.key, required this.bankCode, required this.setBankCode});
  final String bankCode;
  final void Function(String?) setBankCode;
  @override
  State<BankCodeButton> createState() => _BankCodeButtonState();
}

class _BankCodeButtonState extends State<BankCodeButton> {
  @override
  Widget build(BuildContext context) {
    var dropdownValue = widget.bankCode;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // 테두리 추가
        borderRadius: BorderRadius.circular(5.0), // 테두리 모서리를 둥글게 만듦
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        child: DropdownButton<String>(
          value: dropdownValue,
          elevation: 2,
          onChanged: (String? value) {
            setState(() {
              dropdownValue = value!;
            });
            // String code = bankCodeObj[value!];
            widget.setBankCode(value);
          },
          items: bankCodeList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
