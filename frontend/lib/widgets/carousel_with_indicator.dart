import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/account/account_list_api.dart';
import 'package:frontend/models/account/account_list_data.dart';
import 'package:frontend/widgets/bank_book.dart';

class CarouselWithIndicator extends StatefulWidget {
  CarouselWithIndicator({super.key});

  final List<AccountListData> _accountListData = [
    AccountListData(
      account_id: 1,
      account_name: '프론트 더미 데이터: 통신 에러',
      account_num: '111-1234-12345',
      balance_amt: 3630000,
      account_type: 0,
    ),
    AccountListData(
      account_id: 2,
      account_name: '계좌명 2',
      account_num: '222-1234-12345',
      balance_amt: 222000,
      account_type: 0,
    ),
    AccountListData(
      account_id: 3,
      account_name: 'bank Book 3',
      account_num: '111-1234-12345',
      balance_amt: 3630000,
      account_type: 0,
    ),
  ];

  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  bool _isLoading = true;
  int _current = 0;
  final CarouselController _controller = CarouselController();
  late List<Widget> itemList = [];
  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _fetchAccountListData();
  }

  Future<void> _fetchAccountListData() async {
    try {
      // 비동기 작업을 시작하기 전에 로딩 상태를 true로 설정합니다.
      setState(() {
        _isLoading = true;
      });

      var res = await getAccountListData('accessToken');
      print('통신결과: $res');
      setState(() {
        if (res == null) {
          itemList = [
            //계좌 목록 조회 17
            for (int i = 0; i < widget._accountListData.length; i++)
              BankBook(
                bankData: widget._accountListData[i],
              ),
          ];
        } else {
          itemList = [
            //계좌 목록 조회 17
            for (int i = 0; i < res.length; i++)
              BankBook(
                bankData: res[i],
              ),
          ];
        }
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
        ? Container(
            height: 192,
            child: Center(child: CircularProgressIndicator())) // 로딩 화면을 표시합니다.
        : Column(
            children: [
              CarouselSlider(
                items: itemList,
                carouselController: _controller,
                options: CarouselOptions(
                    height: 176,
                    // aspectRatio: 1.97,
                    autoPlay: false,
                    viewportFraction: 1,
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
            ],
          );
  }
}
