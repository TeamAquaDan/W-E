import 'package:flutter/material.dart';

class DropdownButtonHistory extends StatefulWidget {
  DropdownButtonHistory(
      {super.key, required this.trans_type_list, required this.dropdownValue});
  final List<String> trans_type_list;
  String dropdownValue;
  @override
  State<DropdownButtonHistory> createState() => _DropdownButtonHistoryState();
}

class _DropdownButtonHistoryState extends State<DropdownButtonHistory> {
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
      items:
          widget.trans_type_list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
