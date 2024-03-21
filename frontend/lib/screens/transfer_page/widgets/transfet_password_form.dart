import 'package:flutter/material.dart';
import 'package:frontend/api/account/transfer_api.dart';
import 'package:frontend/models/account/transfer_data.dart';
import 'package:get/get.dart';

class TransferPasswordForm extends StatefulWidget {
  TransferPasswordForm(
      {super.key,
      required this.data,
      required this.bank_code_name,
      required this.input_tran_amt});
  TransferPost data;
  String bank_code_name;
  String input_tran_amt;
  @override
  _TransferPasswordFormState createState() => _TransferPasswordFormState();
}

class _TransferPasswordFormState extends State<TransferPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  String pw = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
              '${widget.bank_code_name} ${widget.data.recv_client_account_num}'),
          Text(
            '${widget.data.recv_client_name}님에게',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            '${widget.input_tran_amt}을 보내요',
            style: TextStyle(fontSize: 20),
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.data.req_account_password = value!;
                  },
                  onChanged: (value) {
                    pw = value;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Navigator.pop(context, transferData);
                        var res =
                            await postTransfer('accessToken', widget.data);
                        if (res == null) {
                          Get.snackbar('에러', 'server');
                        } else {
                          Get.snackbar(widget.data.recv_client_name,
                              widget.data.req_account_password);
                        }
                      }
                    },
                    child: Text('송금하기'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
