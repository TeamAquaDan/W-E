import 'package:flutter/material.dart';
import 'package:frontend/screens/chart_page/widgets/chart2.dart';

class AccountBookChart extends StatefulWidget {
  const AccountBookChart({super.key, required this.data});
  final Map<String, dynamic> data;
  @override
  _AccountBookChartState createState() => _AccountBookChartState();
}

class _AccountBookChartState extends State<AccountBookChart> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: widget.data.isEmpty
          ? const CircularProgressIndicator()
          : Column(
              children: [
                PieChartSample2(data: widget.data['data']),
              ],
            ),
    );
  }
}
