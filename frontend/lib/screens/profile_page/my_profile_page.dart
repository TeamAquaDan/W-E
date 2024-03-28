import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/models/store/user/user_controller.dart';
import 'package:frontend/screens/friends_page/my_friends_page.dart';
import 'package:frontend/services/dio_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  late List<dynamic> myProfileList = [];
  final TextEditingController bioController = TextEditingController();
  bool isEditing = false;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    loadProfiles();
  }

  void updateInfo() async {
    final DioService dioService = DioService();
    try {
      var response = await dioService.dio.patch(
        '${baseURL}api/user/profile/sentence',
        data: {
          "sentence": bioController.text,
        },
      );
      if (response.statusCode == 200) {
        // 요청이 성공적으로 완료되었을 때의 처리
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("프로필 정보가 성공적으로 업데이트되었습니다!")),
        );
        // 성공적으로 업데이트된 후에는 프로필 정보를 다시 로딩할 수 있습니다.
        loadProfiles();
      } else {
        // 요청이 실패했을 때의 처리
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("프로필 정보 업데이트에 실패했습니다.")),
        );
      }
    } catch (e) {
      // 요청 중 에러가 발생했을 때의 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("오류가 발생했습니다: $e")),
      );
    }
  }

  Future<void> loadProfiles() async {
    // 여기에 REST API 요청을 수행하는 코드를 작성합니다.
    // 예시로, 다음은 가상의 데이터 로딩 함수입니다.
    var fetcedProfile = await fetchProfilesFromAPI();
    setState(() {
      myProfileList = fetcedProfile; // API로부터 받아온 데이터를 상태에 저장합니다.
    });
  }

  Future<List<dynamic>> fetchProfilesFromAPI() async {
    // 여기에 REST API 요청을 수행하는 코드를 작성합니다.
    final DioService dioService = DioService();

    try {
      var userId = Get.find<UserController>().getUserId();
      final response = await dioService.dio.post(
        '${baseURL}api/user/profile',
        data: {
          'user_id': userId,
        },
      );
      if (response.statusCode == 200) {
        print('POST request 성공: ${response.data}');
        return [response.data['data']];
      } else {
        print('POST request 실패: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: 에러 $e');
      return [];
    }
  }

  void toggleEdit() {
    // 편집 모드 상태 토글 함수
    setState(() {
      isEditing = !isEditing;
      if (!isEditing) {
        // 편집 완료 시, API로 변경된 한 줄 소개 전송
        updateInfo();
      }
    });
  }

  // 갤러리 또는 카메라에서 이미지를 선택하는 함수
  Future<void> _pickImage(ImageSource source) async {
    print('이미지 선택 시작: $source');
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      print('선택된 이미지 경로: ${image.path}');
      setState(() {
        _selectedImage = File(image.path);
        Navigator.pop(context);

        _showSelectedImageModal(_selectedImage!);
      });
      // Navigator.pop(context);
    } else {
      print('이미지 선택 취소');
    }
  }

  void _showSelectedImageModal(File image) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 이 속성을 true로 설정하여 전체 화면 모달을 가능하게 합니다.
      builder: (BuildContext context) {
        // 전체 화면 높이의 80%를 계산
        double modalHeight = MediaQuery.of(context).size.height * 0.8;

        return Container(
          height: modalHeight, // 여기에서 모달의 높이를 설정합니다.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.file(
                image,
                width: double.infinity, // 이미지를 모달 너비에 맞춤
                fit: BoxFit.fitWidth, // 이미지를 너비에 맞게 조정하면서 비율을 유지
              ),
              SizedBox(height: 20), // 이미지와 버튼 사이의 간격
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // 모달 닫기
                    },
                    child: const Text('취소'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // 모달 닫기
                    },
                    child: const Text('확인'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // 이미지 선택 모달을 표시하는 함수
  void _showImagePickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min, // 모달의 크기를 내용물에 맞춤
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('갤러리에서 선택'),
                onTap: () => _pickImage(ImageSource.gallery), // 갤러리에서 이미지 선택
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('카메라로 촬영'),
                onTap: () => _pickImage(ImageSource.camera), // 카메라로 사진 촬영
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 프로필'),
      ),
      body: SingleChildScrollView(
        child: myProfileList.isNotEmpty
            ? Column(
                mainAxisAlignment:
                    MainAxisAlignment.start, // 컨텐츠를 위에서부터 시작하도록 설정
                children: [
                  const SizedBox(height: 30), // 상단 여백
                  GestureDetector(
                    onTap: () {
                      print('프로필 이미지 클릭됨');
                      _showImagePickerModal(context); // 이미지 선택 모달 표시
                    },
                    child: Container(
                      width: 94,
                      height: 94,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        image: const DecorationImage(
                          image: NetworkImage(
                              'https://i.namu.wiki/i/D95WsY8MeICt3KVX1_tUf7KOIexMwiNeNvWtPFpVxez2l8PZd9ULpEiTCcYtfWLi7oo5e2He6YjyvHdWypIr4deeOgSkUfU_LTxDT-BUFOeHD65eCe36Bzn58ik-gMENFo7xgrDWyNEboaH8wpwShQ.webp'),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(50), // 원형 이미지로 만들기
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    myProfileList[0]['username'],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3), // 프로필 이름과 아이디 사이의 여백
                  Text(
                    '@${myProfileList[0]['login_id']}',
                    style: const TextStyle(
                      color: Colors.black, // 색상 코드 수정
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // 한 줄 소개 표시/편집 컨테이너
                    child: isEditing
                        ? TextField(
                            controller: bioController,
                            decoration: InputDecoration(
                              hintText: '여기에 한 줄 소개를 입력하세요',
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.save),
                                onPressed: toggleEdit,
                              ),
                            ),
                            maxLength: 20,
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5),
                            child: InkWell(
                              child: Text(
                                myProfileList[0]['sentence'] ??
                                    '한 줄 소개가 설정되지 않았습니다.',
                                style: const TextStyle(
                                  color: Colors.black, // 색상 코드 수정
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                  ),

                  const SizedBox(height: 20),

                  Get.find<UserController>().getUserId() ==
                          myProfileList[0]['user_id']
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF6750A4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                              onPressed: () {
                                // 내친구관리 버튼 액션
                                Get.to(() => const MyFriendsPage());
                              },
                              child: const Text(
                                '내친구관리',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                backgroundColor: const Color(0xFF6750A4),
                              ),
                              onPressed: () {
                                setState(() {
                                  isEditing = true;
                                });
                              },
                              child: const Text(
                                '프로필수정',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(height: 0, width: 0),
                  const SizedBox(height: 20), // 버튼과 하단 여백
                  // 필요한 경우 여기에 추가적인 위젯 배치
                ],
              )
            : const Center(
                child:
                    CircularProgressIndicator(), // 데이터가 로드되지 않았을 경우 로딩 인디케이터 표시
              ),
      ),
    );
  }
}
