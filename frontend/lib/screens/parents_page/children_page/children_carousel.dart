import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/allowance/child_model.dart';
import 'package:frontend/api/allowance/children_api.dart';
import 'package:frontend/screens/parents_page/children_page/widgets/mission/mission_list.dart';
import 'package:frontend/screens/parents_page/children_page/widgets/add_child_form.dart';
import 'package:frontend/screens/parents_page/widgets/child_card.dart';

class ChildrenManagePage2 extends StatefulWidget {
  const ChildrenManagePage2({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChildrenManagePage2State();
  }
}

class _ChildrenManagePage2State extends State<ChildrenManagePage2> {
  bool _isLoading = true;
  int _current = 0;
  final CarouselController _controller = CarouselController();
  late List<Widget> itemList = [];
  List<Child> children = [];
  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _fetchAccountListData();
  }

  void setChange() {
    _isLoading = true;
    _fetchAccountListData();
    _current = 0;
  }

  Future<void> _fetchAccountListData() async {
    try {
      // 비동기 작업을 시작하기 전에 로딩 상태를 true로 설정합니다.
      setState(() {
        _isLoading = true;
      });

      List<Child> res = await getChildren();
      print('통신결과: $res');
      setState(() {
        itemList = [
          //계좌 목록 조회 17
          for (int i = 0; i < res.length; i++)
            ChildCard(
                groupId: res[i].groupId,
                userId: res[i].userId,
                groupNickname: res[i].groupNickname),
        ];
        children = res;
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
        ? const SizedBox(
            child: Center(child: CircularProgressIndicator())) // 로딩 화면을 표시합니다.
        : Scaffold(
            appBar: AppBar(
              title: const Text(
                '내 자녀 조회',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontFamily: 'SB Aggro',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) =>
                                  const AddChildForm(),
                              isScrollControlled: true,
                            );
                          },
                          icon: const Icon(Icons.add)),
                      const Text('자녀 추가하기')
                    ],
                  ),
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
                                  .withOpacity(
                                      _current == entry.key ? 0.9 : 0.4)),
                        ),
                      );
                    }).toList(),
                  ),
                  MissionList(
                    groupId: children[_current].groupId,
                  )
                ],
              ),
            ),
          );
  }
}
