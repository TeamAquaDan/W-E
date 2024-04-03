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
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 1.4),
        ),
      ),
      margin: EdgeInsets.only(right: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        child: DropdownButtonHideUnderline(
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
      ),
    );
  }
}
