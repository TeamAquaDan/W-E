import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/api/allowance/child_model.dart';
import 'package:frontend/api/allowance/children_api.dart';
import 'package:frontend/screens/parents_page/widgets/child_card.dart';
import 'package:frontend/screens/parents_page/widgets/nego/nego_list_widget.dart';

class ChildrenList extends StatefulWidget {
  const ChildrenList({super.key});

  @override
  _ChildrenListState createState() => _ChildrenListState();
}

class _ChildrenListState extends State<ChildrenList> {
  bool _isLoading = true;
  int _current = 0;
  final CarouselController _controller = CarouselController();
  late List<Widget> itemList = [];
  List<Child> children = [];

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    try {
      setState(() {
        _isLoading = true;
      });
      List<Child> loadedChildren = await getChildren();
      setState(() {
        itemList = [
          //계좌 목록 조회 17
          for (int i = 0; i < loadedChildren.length; i++)
            ChildCard(
                groupId: loadedChildren[i].groupId,
                userId: loadedChildren[i].userId,
                groupNickname: loadedChildren[i].groupNickname),
        ];
        children = loadedChildren;
      });
    } catch (error) {
      // 에러가 발생한 경우 에러 처리를 수행합니다.
      print('Error: $error');
    } finally {
      // 비동기 작업이 완료되었으므로 로딩 상태를 false로 설정합니다.
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const SizedBox(child: Center(child: CircularProgressIndicator()))
        : Column(
            children: [
              CarouselSlider(
                items: itemList,
                carouselController: _controller,
                options: CarouselOptions(
                    height: 186,
                    // aspectRatio: 1.97,
                    autoPlay: false,
                    viewportFraction: 0.8,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: itemList.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black)
                              .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                child: NegoListWidget(groupId: children[_current].groupId),
              ),
            ],
          );
    // : SizedBox(
    //     width: MediaQuery.of(context).size.width,
    //     // height: 700,
    //     child: ListView.builder(
    //       physics: const NeverScrollableScrollPhysics(), // ListView 스크롤 제거
    //       shrinkWrap: true, // ListView가 자신의 공간만 차지하도록 설정
    //       itemCount: children.length,
    //       itemBuilder: (BuildContext context, int index) {
    //         Child child = children[index];
    //         return Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 16),
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               ChildCard(
    //                   groupId: child.groupId,
    //                   userId: child.userId,
    //                   groupNickname: child.groupNickname),
    //               NegoListWidget(groupId: child.groupId)
    //             ],
    //           ),
    //         );
    //       },
    //     ),
    //   );
  }
}
