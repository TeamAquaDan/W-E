import 'package:flutter/material.dart';
import 'package:frontend/models/bank_code.dart';

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
    return DropdownButton<String>(
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
    );
  }
}
