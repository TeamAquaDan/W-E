import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/models/account_list_data.dart';
import 'package:frontend/screens/transfer_page/widgets/bank_code_button.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:frontend/screens/transfer_page/widgets/input_format.dart';

const List<String> bankCodeList = <String>[
  '웨일뱅크',
  '경남은행',
  '광주은행',
  '부산은행',
  '신한은행',
  '씨티은행',
  '우리은행',
  '제주은행',
  '카카오뱅크',
  '토스뱅크',
  '하나은행',
  'KB국민은행',
  'DGB대구은행',
  'NH농협은행',
];
const List<String> bankCodeListInt = <String>[
  "103",
  "039",
  "034",
  "032",
  "088",
  "027",
  "020",
  "037",
  "090",
  "092",
  "081",
  "004",
  "031",
  "011",
];

class TransferPage extends StatefulWidget {
  const TransferPage({super.key, required this.bankData});
  final AccountListData bankData;

  @override
  State<TransferPage> createState() {
    return _TransferPage();
  }
}

class _TransferPage extends State<TransferPage> {
  final _form = GlobalKey<FormState>();
  String dropdownValue = bankCodeList.first;
  void _submitTransferData() {}

  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('송금하기'),
      ),
      body: Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  BankCodeButton(
                    bankCodeList: bankCodeList,
                    dropdownValue: dropdownValue,
                  ),
                  Expanded(
                    child: TextFormField(
                        decoration: InputDecoration(labelText: '계좌번호'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ]),
                  ),
                ],
              ),
              Text(myController.text),
              TextFormField(
                controller: myController,
                decoration: InputDecoration(labelText: '송금 금액'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyFormatter()
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '내 거래내역에 표기할 메모'),
                keyboardType: TextInputType.text,
                maxLength: 20,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '상대방 거래내역에 표기할 메모'),
                keyboardType: TextInputType.text,
                maxLength: 20,
              ),
              Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('취소'),
                  ),
                  ElevatedButton(
                      onPressed: _submitTransferData, child: const Text('송금')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/* 
"{
  ""bank_code_std"" : ""string, 입금 은행 표준 코드"",
  ""account_num' : ""string, 입금 계좌번호""
}"
"{
  ""tran_amt"" : ""int, 거래금액"",
  ""bank_code_std"" : ""string, 입금 은행 표준 코드"",
  ""account_num' : ""string, 입금 계좌번호"", 상대
  ""account_id"" : ""int, 계좌고유번호(출금 계좌)"", 나
  ""account_password"": ""String"",
  ""req_trans_memo"" : ""string, 내 거래내역에 표기할 메모"",
  ""recv_trans_memo"": ""string, 상대방 거래내역에 표기할 메모""
}"

*/