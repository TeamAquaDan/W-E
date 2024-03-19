import 'package:flutter/material.dart';

const List<String> trans_type_list = <String>['전체', '지출', '수입'];

class DropdownButtonHistory extends StatefulWidget {
  const DropdownButtonHistory({super.key});

  @override
  State<DropdownButtonHistory> createState() => _DropdownButtonHistoryState();
}

class _DropdownButtonHistoryState extends State<DropdownButtonHistory> {
  String dropdownValue = trans_type_list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      // icon: const Icon(Icons.arrow_downward),
      elevation: 2,
      // style: const TextStyle(color: Colors.deepPurple),
      // underline: Container(
      //   height: 2,
      //   color: Colors.deepPurpleAccent,
      // ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: trans_type_list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
