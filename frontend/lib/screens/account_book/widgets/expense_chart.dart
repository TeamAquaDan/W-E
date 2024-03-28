import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseChart extends StatelessWidget {
  final Map<String, dynamic> data;

  const ExpenseChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    int totalExpense = data['expense_amt'];
    Map<String, int> categoryExpenses =
        Map<String, int>.from(data['statistics_list']);

    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Total Expense: $totalExpense'), // 지출 총량 표시
            const SizedBox(height: 20),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: List.generate(
                    categoryExpenses.length,
                    (index) {
                      final category = categoryExpenses.keys.toList()[index];
                      final expense = categoryExpenses[category]!;
                      return PieChartSectionData(
                        color: getColorByIndex(index),
                        value: expense.toDouble(),
                        title: '$category\n${expense.toStringAsFixed(2)}',
                        radius: 100,
                      );
                    },
                  ),
                  sectionsSpace: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getColorByIndex(int index) {
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.cyan,
    ];
    return colors[index % colors.length];
  }
}
