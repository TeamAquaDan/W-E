import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class PieChartSample2 extends StatefulWidget {
  final Map<String, dynamic> data;

  const PieChartSample2({super.key, required this.data});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartSample2> {
  int touchedIndex = -1;
  final formatter = NumberFormat('###,###,###,### 원');
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.4,
          child: Column(
            children: <Widget>[
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 60,
                      sections: showingSections(),
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 80),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 24),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    '전체',
                    style: TextStyle(
                      color: Color(0xFF3c3c3c),
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    formatter.format(widget.data['expense_amt']),
                    style: const TextStyle(
                      color: Color(0xFF3c3c3c),
                      fontSize: 20,
                    ),
                  )
                ],
              ),
              const Divider()
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildIndicators(),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    final Map<String, int> categoryExpenses =
        Map<String, int>.from(widget.data['statistics_list']);

    return List.generate(categoryExpenses.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final category = categoryExpenses.keys.toList()[i];
      final expense = categoryExpenses[category]!;

      return PieChartSectionData(
        color: getColorByCategory(category),
        value: expense.toDouble(),
        title:
            '${(expense / widget.data['expense_amt'] * 100).toStringAsFixed(2)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    });
  }

  List<Widget> _buildIndicators() {
    final Map<String, int> categoryExpenses =
        Map<String, int>.from(widget.data['statistics_list']);
    final List<Widget> indicators = [];
    categoryExpenses.forEach((category, value) {
      final color = getColorByCategory(category);
      final text = getCategoryName(category);
      final money = value;
      indicators.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 24),
          child: Row(
            children: <Widget>[
              Container(
                width: 20,
                height: 20,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                '$text ${(money / widget.data['expense_amt'] * 100).toStringAsFixed(2)}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                formatter.format(money),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    });

    return indicators;
  }

  String getCategoryName(String category) {
    switch (category) {
      case '001':
        return '식비';
      case '002':
        return '카페/간식';
      case '003':
        return '생활';
      case '004':
        return '주거/통신';
      case '005':
        return '온라인쇼핑';
      case '006':
        return '패션/쇼핑';
      case '007':
        return '뷰티/미용';
      case '008':
        return '의료/건강';
      case '009':
        return '문화/여가';
      case '010':
        return '여행/숙박';
      case '011':
        return '경조/선물';
      case '012':
        return '반려동물';
      case '013':
        return '교육/학습';
      case '014':
        return '술/유흥';
      case '015':
        return '교통';
      case '000':
        return '기타';
      case '100':
        return '수입';
      default:
        return 'Unknown';
    }
  }

  Color getColorByCategory(String category) {
    switch (category) {
      case '001':
        return Colors.blue;
      case '002':
        return Colors.yellow;
      case '003':
        return Colors.purple;
      case '004':
        return Colors.green;
      case '005':
        return Colors.red;
      case '006':
        return Colors.orange;
      case '007':
        return Colors.indigo;
      case '008':
        return Colors.teal;
      case '009':
        return Colors.cyan;
      case '010':
        return Colors.deepPurple;
      case '011':
        return Colors.amber;
      case '012':
        return Colors.lime;
      case '013':
        return Colors.lightGreen;
      case '014':
        return Colors.deepOrange;
      case '015':
        return Colors.pink;
      case '000':
        return Colors.grey;
      case '100':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }
}
