import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  AuthTextField(
      {super.key,
      required this.controller,
      required this.isFailed,
      required this.label,
      required this.isBlind});
  TextEditingController controller;
  bool isFailed;
  String label;
  bool isBlind;
  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        TextField(
          controller: widget.controller,
          obscureText: widget.isBlind,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ), // 테두리 설정
            fillColor: const Color(0xFFF4F6FB), // 배경색 설정
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              borderSide: BorderSide(
                color: widget.isFailed
                    ? Colors.red
                    : Colors.grey, // 로그인 실패 시 테두리 색상을 빨간색으로 설정
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(const Radius.circular(15.0)),
              borderSide: BorderSide(
                color: widget.isFailed
                    ? Colors.red
                    : const Color(0xFF568EF8), // 로그인 실패 시 테두리 색상을 빨간색으로 설정
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          top: 10.20,
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Color(0xFF505050),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 0.11,
              letterSpacing: 0.40,
            ),
          ),
        ),
      ],
    );
  }
}
