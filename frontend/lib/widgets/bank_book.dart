import 'package:flutter/material.dart';
import 'package:frontend/api/account/main_account.dart';
import 'package:frontend/models/account/account_list_data.dart';
import 'package:frontend/screens/bank_history_page/bank_history_page.dart';
import 'package:frontend/screens/transfer_page/transfer_page.dart';
import 'package:frontend/widgets/bank_detail.dart';
import 'package:intl/intl.dart';

class BankBook extends StatefulWidget {
  BankBook({Key? key, required this.bankData, this.setChange})
      : super(key: key);

  final AccountListData bankData;
  void Function()? setChange;
  @override
  State<BankBook> createState() => _BankBook();
}

class _BankBook extends State<BankBook> {
  var moneyFormat = NumberFormat('###,###,###,### 원');
  @override
  Widget build(BuildContext context) {
    bool isMain = widget.bankData.is_mainAccount;
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Color(0xFFC1C7CE)),
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFFA0CAFD),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Row(
              children: [
                IconButton(
                  style: IconButton.styleFrom(padding: const EdgeInsets.all(0)),
                  onPressed: () async {
                    bool res = await patchMainAccount(
                        widget.bankData.account_id,
                        widget.bankData.account_num);
                    setState(() {
                      isMain = res;
                      if (widget.setChange != null) {
                        widget.setChange!();
                      }
                    });
                    print('스테이트 변경 $isMain, ${widget.setChange}');
                  },
                  icon: isMain ? Icon(Icons.star) : Icon(Icons.star_border),
                ),
                IconButton(
                  style: IconButton.styleFrom(padding: const EdgeInsets.all(0)),
                  onPressed: () {
                    toBankDetailPage(context);
                  },
                  icon: const Icon(Icons.more_horiz),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.bankData.account_name,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  widget.bankData.account_num,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                Center(
                  child: Text(
                    moneyFormat.format(widget.bankData.balance_amt),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF264CB2)),
                      ),
                      onPressed: () {
                        toBankHistoryPage(context);
                      },
                      child: const Text(
                        '내역',
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF264CB2)),
                      ),
                      onPressed: () {
                        toTransferPage(context);
                      },
                      child: const Text(
                        '이체',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void toBankDetailPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BankDetail(
                bankData: widget.bankData,
              )),
    );
  }

  void toBankHistoryPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BankHistoryPage(
                bankData: widget.bankData,
              )),
    );
  }

  void toTransferPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TransferPage(
                bankData: widget.bankData,
              )),
    );
  }
}
