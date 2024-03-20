import 'package:flutter/material.dart';

class BankCodeButton extends StatefulWidget {
  BankCodeButton(
      {super.key, required this.bankCodeList, required this.dropdownValue});
  final List<String> bankCodeList;
  String dropdownValue;
  @override
  State<BankCodeButton> createState() => _BankCodeButtonState();
}

class _BankCodeButtonState extends State<BankCodeButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.dropdownValue,
      // icon: const Icon(Icons.arrow_downward),
      elevation: 2,
      // style: const TextStyle(color: Colors.deepPurple),
      // underline: Container(
      //   height: 2,
      //   color: Colors.deepPurpleAccent,
      // ),
      onChanged: (String? value) {
        setState(() {
          widget.dropdownValue = value!;
        });
      },
      items: widget.bankCodeList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
