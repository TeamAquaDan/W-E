import 'package:flutter/material.dart';
import 'package:frontend/widgets/bank_book.dart';
import 'package:frontend/widgets/carousel_with_indicator.dart';
import 'package:frontend/widgets/pin_money.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ParentsHomePage extends StatelessWidget {
  const ParentsHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/whale.png',
              height: 32,
            ),
            Text('Whale 부모 페이지'),
          ],
        ),
      ),
      body: const SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CarouselWithIndicator(
                itemList: [
                  BankBook(
                    title: '통장 이름1',
                    bankBookNum: '111-1234-12345',
                    bankBookMoney: 112000,
                  ),
                  BankBook(
                    title: '통장 이름2',
                    bankBookNum: '222-1234-12345',
                    bankBookMoney: 223000,
                  ),
                  BankBook(
                    title: '통장 이름3',
                    bankBookNum: '222-1234-12345',
                    bankBookMoney: 323000,
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              PinMoney(
                PinMoneyDay: 16,
                PinMoneyMoney: 100000,
                childName: '아들1',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
