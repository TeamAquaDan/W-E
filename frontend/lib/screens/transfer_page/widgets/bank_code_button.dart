import 'package:flutter/material.dart';

const Map<String, String> bankCodeObj = {
  '웨일뱅크': "103",
  '경남은행': "039",
  '광주은행': "034",
  '부산은행': "032",
  '신한은행': "088",
  '씨티은행': "027",
  '우리은행': "020",
  '제주은행': "037",
  '카카오뱅크': "090",
  '토스뱅크': "092",
  '하나은행': "081",
  'KB국민은행': "004",
  'DGB대구은행': "031",
  'NH농협은행': "011",
};

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
