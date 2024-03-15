import 'package:flutter/material.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({Key? key}) : super(key: key);

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(
    length: 8,
    vsync: this,
    initialIndex: 0,

    /// 탭 변경 애니메이션 시간
    animationDuration: const Duration(milliseconds: 800),
  );

  @override
  void initState() {
    tabController.addListener(() {
      /// 프레임당 콜백
    });

    /// 탭바의 index가 변경되고 있는지 체크
    /// true or false
    tabController.indexIsChanging;

    /// 탭바의 개수
    tabController.length;

    /// 변경 전의 index
    tabController.previousIndex;

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TabBarScreen"),
      ),
      body: Column(
        children: [
          _tabBar(),
          ElevatedButton(
            onPressed: () {
              /// 애니메이션 없이 바로 변경
              tabController.index = 2;
            },
            child: const Text("이동"),
          ),
          ElevatedButton(
            onPressed: () {
              /// 애니메이션 없이 바로 변경
              tabController.animateTo(5);
            },
            child: const Text("이동 animateTo"),
          ),
        ],
      ),
    );
  }

  Widget _tabBar() {
    return TabBar(
      controller: tabController,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      labelStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 16,
      ),

      /// 탭바 클릭시 나오는 splash effect 컬러
      overlayColor: MaterialStatePropertyAll(
        Colors.blue.shade100,
      ),

      /// 탭바 클릭할 때 나오는 splash effect의 radius
      splashBorderRadius: BorderRadius.circular(20),

      /// 기본 인디캐이터의 컬러
      indicatorColor: Colors.black,

      /// indicator에서  UnderlineTabIndicator를 사용하지 않을 경우
      /// 0으로 설정할 것
      indicatorWeight: 5,

      /// 인디캐이터의 기본 사이즈를 label에 맞출지,
      /// 탭 좌우 사이즈에 맞출지 설정
      indicatorSize: TabBarIndicatorSize.label,

      /// 탭바의 상하좌우에 적용하는 패딩
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),

      /// 라벨에 주는 패딩
      labelPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),

      /// 인디캐이터의 패딩
      indicatorPadding: const EdgeInsets.all(5),

      /// 커스텀 인디캐이터
      indicator: BoxDecoration(
        color: Colors.green.shade400,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.orange,
          width: 5,
        ),
      ),

      isScrollable: true,

      onTap: (index) {},
      tabs: const [
        Tab(text: "Tab 1"),
        Tab(text: "Tab 2"),
        Tab(text: "Tab 3"),
        Tab(text: "Tab 4"),
        Tab(text: "Tab 5"),
        Tab(text: "Tab 6"),
        Tab(text: "Tab 7"),
        Tab(text: "Tab 8"),
      ],
    );
  }
}
