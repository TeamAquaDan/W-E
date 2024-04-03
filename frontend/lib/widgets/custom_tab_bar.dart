import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final int selectedTabIndex;
  final Function(int) onTabChanged;
  final Color selectedTabColor;
  final List<String> tabLabels;

  const CustomTabBar({
    Key? key,
    required this.selectedTabIndex,
    required this.onTabChanged,
    required this.tabLabels,
    this.selectedTabColor = const Color(0xFF568ef8),
  })  : assert(
            tabLabels.length > 1, 'You must provide at least two tab labels.'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabWidth = MediaQuery.of(context).size.width / tabLabels.length;
    final _indicatorPosition = tabWidth * selectedTabIndex;

    return Container(
      height: kToolbarHeight - 8.0,
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Color(0xffd9d9d9),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: _indicatorPosition,
            width: tabWidth,
            child: Container(
              height: kToolbarHeight - 8.0,
              decoration: BoxDecoration(
                color: selectedTabColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          Row(
            children: List.generate(
              tabLabels.length,
              (index) => Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTabChanged(index),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 8),
                    alignment: Alignment.center,
                    child: Text(tabLabels[index],
                        style: TextStyle(
                          color: selectedTabIndex == index
                              ? Colors.white
                              : Color(0xff919191),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
