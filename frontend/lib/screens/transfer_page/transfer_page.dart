import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/api/account/transfer_api.dart';
import 'package:frontend/models/account/account_list_data.dart';
import 'package:frontend/models/account/transfer_data.dart';
import 'package:frontend/screens/transfer_page/widgets/bank_code_button.dart';
import 'package:frontend/screens/transfer_page/widgets/input_format.dart';
import 'package:frontend/models/account/bank_code.dart';
import 'package:frontend/screens/transfer_page/widgets/transfet_password_form.dart';
import 'package:get/get.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({super.key, required this.bankData});
  final AccountListData bankData;

  @override
  State<TransferPage> createState() {
    return TransferPageState();
  }
}

class TransferPageState extends State<TransferPage> {
  final formKey = GlobalKey<FormState>();
  String dropdownValue = bankCodeList.first;
  void _submitTransferData() async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // Get.snackbar(recv_client_bank_code, account_num);
      receiveData = TransferReceivePost(
          bank_code_std: recv_client_bank_code, account_num: account_num);
      responseTransferReceive =
          await postTransferReceive('accessToken', receiveData);
      if (responseTransferReceive != null) {
        transferData = TransferPost(
            tran_amt: tran_amt,
            req_account_id: widget.bankData.account_id,
            req_account_num: widget.bankData.account_num,
            req_account_password: '',
            req_trans_memo: req_trans_memo,
            recv_client_name: responseTransferReceive!,
            recv_client_bank_code: recv_client_bank_code,
            recv_client_account_num: account_num,
            recv_trans_memo: recv_trans_memo);
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return TransferPasswordForm(
              data: transferData,
              bank_code_name: bank_code_name,
              input_tran_amt: input_tran_amt,
            );
          },
        );
      } else {
        Get.snackbar('수취인이 없어요', '해당 수취인을 찾을 수 가 없습니다.');
        // transferData = TransferPost(
        //     tran_amt: tran_amt,
        //     req_account_id: widget.bankData.account_id,
        //     req_account_num: widget.bankData.account_num,
        //     req_account_password: '',
        //     req_trans_memo: req_trans_memo,
        //     recv_client_name: 'Fail',
        //     recv_client_bank_code: recv_client_bank_code,
        //     recv_client_account_num: account_num,
        //     recv_trans_memo: recv_trans_memo);
        // showModalBottomSheet(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return TransferPasswordForm(
        //       data: transferData,
        //       bank_code_name: bank_code_name,
        //       input_tran_amt: input_tran_amt,
        //     );
        //   },
        // );
      }
    }
  }

  String input_tran_amt = ''; //
  int tran_amt = 0;
  // int req_account_id = widget.bankData.account_id;
  // String req_account_num = widget.bankData.account_num;
  String req_account_password = '';
  String bank_code_name = '웨일뱅크'; //
  String recv_client_bank_code = '103'; // 수취인 조회
  String account_num = ''; // 수취인 조회
  // String recv_client_account_num = account_num;
  // String recv_client_name 수취인 조회 결과
  String req_trans_memo = '';
  String recv_trans_memo = '';
  late TransferReceivePost receiveData;
  late TransferPost transferData;
  late String? responseTransferReceive;
  void _setTranAmt(int? newValue) {
    setState(() {
      tran_amt = newValue!;
    });
  }

  void _setBankCode(String? newValue) {
    if (newValue is String) {
      setState(() {
        bank_code_name = newValue;
        recv_client_bank_code = bankCodeObj[newValue]!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('송금하기'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  BankCodeButton(
                      bankCode: bank_code_name, setBankCode: _setBankCode),
                  Expanded(
                    child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: '계좌번호',
                          labelStyle: TextStyle(fontSize: 16),
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (newValue) {
                          setState(() => account_num = newValue!);
                        },
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '계좌번호를 입력해 주세요';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ]),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: '송금 금액'),
                onSaved: (newValue) {
                  setState(() {
                    input_tran_amt = newValue!;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    input_tran_amt = value;
                  });
                },
                autovalidateMode: AutovalidateMode.always,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '보낼 금액을 입력해 주세요';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyFormatter(_setTranAmt)
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: '내 거래내역에 표기할 메모'),
                onSaved: (newValue) {
                  setState(() {
                    req_trans_memo = newValue!;
                  });
                },
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null) {
                    return '입력';
                  }
                  return null;
                },
                maxLength: 20,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: '상대방 거래내역에 표기할 메모'),
                onSaved: (newValue) {
                  setState(() {
                    recv_trans_memo = newValue!;
                  });
                },
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null) {
                    return '입력';
                  }
                  return null;
                },
                maxLength: 20,
              ),
              const SizedBox(height: 16),
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
              // Column(
              //   children: [
              //     Text('bank_code_std : $bank_code_name'),
              //     Text('recv_client_bank_code : $recv_client_bank_code'),
              //     Text('account_num : $account_num'),
              //     Text('tran_amt : $tran_amt'),
              //     Text('input_tran_amt : $input_tran_amt'),
              //     Text('req_trans_memo : $req_trans_memo'),
              //     Text('recv_trans_memo : $recv_trans_memo')
              //   ],
              // )
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

{
  ""tran_amt"": ""int, 거래금액"",
  ""req_account_id"": int, 계좌 고유 번호(출금 계좌),
  ""req_account_num"": ""string, 출금 계좌 번호"",
  ""req_account_password"" : ""string, 요청고객 계좌 비밀번호"",
  ""recv_client_bank_code"": ""string, 최종수취고객계좌 개설기관 표준코드"",
  ""recv_client_account_num"": ""string, 최종수취고객 계좌번호"", 
  ""recv_client_name"": string, 수취인 성명
  ""req_trans_memo"" : ""string, 내 거래내역에 표기할 메모"",
  ""recv_trans_memo"": ""string, 상대방 거래내역에 표기할 메모""
}

계좌번호 ""-"" 포함 x"
*/