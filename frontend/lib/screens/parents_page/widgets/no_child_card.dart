import 'package:flutter/material.dart';
import 'package:frontend/api/allowance/allowance_patch_api.dart';
import 'package:frontend/api/allowance/child_model.dart';
import 'package:frontend/api/allowance/children_api.dart';
import 'package:frontend/screens/parents_page/children_page/widgets/add_child_form.dart';
import 'package:frontend/screens/parents_page/widgets/allowance_info_form.dart';
import 'package:frontend/screens/transfer_page/gruop_transfer_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NoChildCard extends StatefulWidget {
  NoChildCard({
    super.key,
  });

  @override
  _NoChildCardState createState() => _NoChildCardState();
}

class _NoChildCardState extends State<NoChildCard> {
  var moneyFormat = NumberFormat('###,###,###,### 원');
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) => const AddChildForm(),
          isScrollControlled: true,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFC1C7CE)),
          borderRadius: BorderRadius.circular(20),
        ),
        color: const Color(0xFF7A97FF),
        margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 100,
          ),
          child: Column(
            children: [
              Icon(
                Icons.add,
                size: 50,
              ),
              SizedBox(height: 12),
              Text(
                '아이 추가하기',
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
