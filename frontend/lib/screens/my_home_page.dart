import 'package:flutter/material.dart';
import 'package:frontend/widgets/bank_book.dart';
import 'package:frontend/widgets/mission_none.dart';
import 'package:frontend/widgets/pin_money.dart';
import 'package:frontend/widgets/saving_goal.dart';
import 'package:frontend/widgets/saving_goal_none.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              BankBook(
                title: '통장 이름',
                bankBookNum: '123-1234-12345',
                bankBookMoney: 123123000,
              ),
              PinMoney(
                PinMoneyDay: 16,
                PinMoneyMoney: 100000,
                childName: '아들1',
              ),
              SavingGoal(),
              SavingGoalNone(),
              MissionNone(),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
