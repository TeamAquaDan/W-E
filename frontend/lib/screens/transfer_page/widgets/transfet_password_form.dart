import 'package:flutter/material.dart';
import 'package:frontend/api/account/transfer_api.dart';
import 'package:frontend/models/account/transfer_data.dart';
import 'package:frontend/models/store/user/user_controller.dart';
import 'package:frontend/models/store/userRole/user_role.dart';
import 'package:frontend/screens/child_page/child_page.dart';
import 'package:frontend/screens/parents_page/parent_page.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_keyboard/flutter_secure_keyboard.dart';

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
  // String pw = '';
  final _secureKeyboardController = SecureKeyboardController();
  final _pinCodeEditor = TextEditingController();
  final _pinCodeTextFieldFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return WithSecureKeyboard(
      controller: _secureKeyboardController,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
                '${widget.bank_code_name} ${widget.data.recv_client_account_num}'),
            Text(
              '${widget.data.recv_client_name}님에게',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              '${widget.input_tran_amt}을 보내요',
              style: const TextStyle(fontSize: 20),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    // keyboardType: TextInputType.number,
                    // obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      widget.data.req_account_password = value!;
                    },

                    // onChanged: (value) {
                    //   _pinCodeEditor = value;
                    // },
                    controller: _pinCodeEditor,
                    focusNode: _pinCodeTextFieldFocusNode,
                    // We recommended to set false to prevent the software keyboard from opening.
                    enableInteractiveSelection: false,
                    obscureText: true,
                    onTap: () {
                      _secureKeyboardController.show(
                        type: SecureKeyboardType.NUMERIC,
                        focusNode: _pinCodeTextFieldFocusNode,
                        initText: _pinCodeEditor.text,
                        hintText: 'pinCode',
                        onDoneKeyPressed: (List<int> charCodes) {
                          _pinCodeEditor.text = String.fromCharCodes(charCodes);
                        },
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // Navigator.pop(context, transferData);
                          if (widget.data.req_trans_memo.trim() == '') {
                            widget.data.req_trans_memo =
                                widget.data.recv_client_name;
                          }
                          if (widget.data.recv_trans_memo.trim() == '') {
                            widget.data.recv_trans_memo =
                                Get.find<UserController>().getUserName();
                          }
                          var res =
                              await postTransfer('accessToken', widget.data);
                          if (res == null) {
                            Get.snackbar('송금 에러', '송금 에러');
                          } else {
                            if (Get.find<UserRoleController>().getUserRole() ==
                                'ADULT') {
                              Get.offAll(const ParentPage());
                            } else if (Get.find<UserRoleController>()
                                    .getUserRole() ==
                                'CHILD') {
                              Get.offAll(const ChildPage());
                            }
                            // Navigator.pop(context);
                            // Navigator.pop(context);
                            Get.snackbar('송금완료',
                                '${widget.data.recv_client_name}님에게 ${widget.data.tran_amt} 원 입금 원료');
                          }
                        }
                      },
                      child: const Text('송금하기'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
