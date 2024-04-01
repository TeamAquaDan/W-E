import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/models/store/user/user_controller.dart';
import 'package:frontend/screens/friends_page/my_friends_page.dart';
import 'package:frontend/services/dio_service.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dioImport;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as pathImport;

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key, required this.userId});

  final int userId;

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  late List<dynamic> myProfileList = [];
  final TextEditingController bioController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
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
      final response = await dioService.dio.post(
        '${baseURL}api/user/profile',
        data: {
          'user_id': widget.userId,
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
        // Navigator.pop(context);
      }
    });
  }

  // 갤러리 또는 카메라에서 이미지를 선택하는 함수
  Future<void> _pickImage(ImageSource source) async {
    print('이미지 선택 시작: $source');
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

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

  Future<void> uploadImage(File image) async {
    final DioService dioService = DioService();
    String fileName = pathImport.basename(image.path);
    dioImport.FormData formData = dioImport.FormData.fromMap({
      "Content-Type": await dioImport.MultipartFile.fromFile(image.path,
          filename: fileName),
      // Include any other fields you need to send
    });

    try {
      var response = await dioService.dio.patch(
        "${baseURL}api/user/profile-img", // Replace with your endpoint
        data: formData,
      );
      if (response.statusCode == 200) {
        setState(() {
          loadProfiles();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("이미지가 성공적으로 업로드되었습니다!")),
        );
        // Handle success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("이미지 업로드에 실패했습니다.")),
        );
        // Handle failure
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("오류가 발생했습니다: $e")),
      );
      // Handle error
    }
  }

  void _showSelectedImageModal(File image) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 이 속성을 true로 설정하여 전체 화면 모달을 가능하게 합니다.
      builder: (BuildContext context) {
        // 전체 화면 높이의 80%를 계산
        double modalHeight = MediaQuery.of(context).size.height * 0.8;

        return SizedBox(
          height: modalHeight, // 여기에서 모달의 높이를 설정합니다.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.file(
                image,
                width: double.infinity, // 이미지를 모달 너비에 맞춤
                fit: BoxFit.fitWidth, // 이미지를 너비에 맞게 조정하면서 비율을 유지
              ),
              const SizedBox(height: 20), // 이미지와 버튼 사이의 간격
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
                      uploadImage(image);
                      Navigator.pop(context); // 모달 닫기
                      setState(() {
                        loadProfiles();
                      });
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
                leading: const Icon(Icons.photo_library),
                title: const Text('갤러리에서 선택'),
                onTap: () => _pickImage(ImageSource.gallery), // 갤러리에서 이미지 선택
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('카메라로 촬영'),
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
        title: Text('프로필 페이지'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: myProfileList.isNotEmpty
            ? Column(
                mainAxisAlignment:
                    MainAxisAlignment.start, // 컨텐츠를 위에서부터 시작하도록 설정
                children: [
                  const SizedBox(height: 15), // 상단 여백
                  GestureDetector(
                    onTap: () {
                      if (myProfileList[0]['editable'] == true) {
                        _showImagePickerModal(context);
                      } // 이미지 선택 모달 표시
                    },
                    child: Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          image: DecorationImage(
                            image: NetworkImage(myProfileList[0]
                                    ['profile_img'] ??
                                'https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbyfdKI%2FbtsGbRH96Xy%2FH3KbM1y85UhvkGtKT3KWu0%2Fimg.png'),
                            fit: BoxFit.fill,
                          ),
                          borderRadius:
                              BorderRadius.circular(100), // 원형 이미지로 만들기
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    myProfileList[0]['username'],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '@${myProfileList[0]['login_id']}',
                    style: const TextStyle(
                      color: Colors.black, // 색상 코드 수정
                      fontSize: 23,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    padding: const EdgeInsets.fromLTRB(20, 5, 5, 5),
                    decoration: BoxDecoration(
                      color: Color(0xFFF4F6FB),
                      border: Border.all(color: Color(0xFF616161), width: 0.5),
                      borderRadius: BorderRadius.circular(17),
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
                        : Container(
                            child: InkWell(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    myProfileList[0]['sentence'] ??
                                        '한 줄 소개가 설정되지 않았습니다.',
                                    style: const TextStyle(
                                      color: Colors.black, // 색상 코드 수정
                                      fontSize: 16,
                                    ),
                                  ),
                                  myProfileList[0]['editable'] == true
                                      ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isEditing = true;
                                            });
                                          },
                                          icon: Icon(Icons.edit))
                                      : const SizedBox(width: 0, height: 0),
                                ],
                              ),
                            ),
                          ),
                  ),

                  const SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: const Divider(
                      height: 1,
                      thickness: 2,
                    ),
                  ), // 구분선
                  const SizedBox(height: 5), // 버튼과 하단 여백
                  // 필요한 경우 여기에 추가적인 위젯 배치
                  if (myProfileList[0]['editable'])
                    SizedBox(
                      height: 5,
                    ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '방명록',
                          style: TextStyle(
                            color: Colors.black, // 색상 코드 수정
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        myProfileList[0]['editable'] == false
                            ? TextButton(
                                onPressed: () {
                                  _showWriteCommentModal();
                                },
                                child: Text(
                                  '＋ 작성하기',
                                  style: TextStyle(
                                    color: Colors.black, // 색상 코드 수정
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : SizedBox(width: 0, height: 0),
                      ],
                    ),
                  ),
                  if (myProfileList[0]['editable'])
                    SizedBox(
                      height: 7,
                    ),

                  if (myProfileList.isNotEmpty &&
                      myProfileList[0]['guestbook_list'] != null)
                    ListView.builder(
                      shrinkWrap: true, // 내용의 크기에 맞게 ListView의 크기를 조정합니다.
                      // physics:
                      //     const NeverScrollableScrollPhysics(), // 스크롤을 막습니다.
                      itemCount: myProfileList[0]['guestbook_list'].length,
                      itemBuilder: (context, index) {
                        var comment = myProfileList[0]['guestbook_list'][index];
                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          child: ListTile(
                            contentPadding: EdgeInsets.fromLTRB(20, 5, 10, 5),
                            tileColor: Color(0xFF568EF8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(comment[
                                      'writer_img'] ??
                                  'https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbyfdKI%2FbtsGbRH96Xy%2FH3KbM1y85UhvkGtKT3KWu0%2Fimg.png'),
                              // '기본_이미지_URL'을 코멘트 작성자의 기본 이미지 URL로 교체하세요.
                            ),
                            title: Container(
                              child: Text(
                                comment['writer_name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white,
                                ),

                                overflow:
                                    TextOverflow.ellipsis, // 이름이 길 경우 생략 기호 처리
                              ),
                            ),
                            subtitle: Container(
                              child: Text(
                                comment['content'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            trailing: (myProfileList[0]['editable'] == true ||
                                    comment['writer_id'] ==
                                        Get.find<UserController>().getUserId())
                                ? IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () async {
                                      final DioService dioService =
                                          DioService();
                                      try {
                                        var response =
                                            await dioService.dio.delete(
                                          '${baseURL}api/user/guestbook/${comment['guestbook_id']}',
                                        );
                                        setState(() {
                                          loadProfiles();
                                        });
                                      } catch (err) {
                                        print(err);
                                      }
                                    },
                                  )
                                : null, // 조건이 거짓일 때 null을 반환하여 아무것도 표시하지 않음
                          ),
                        );
                      },
                    ),

                  // 코멘트 입력 필드와 게시 버튼
                  // myProfileList[0]['editable'] == false
                  //     ? Padding(
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 8.0, vertical: 20),
                  //         child: Row(
                  //           children: [
                  //             Expanded(
                  //               child: TextField(
                  //                 controller: commentController,
                  //                 decoration: const InputDecoration(
                  //                   hintText: '코멘트를 입력하세요...',
                  //                   border: OutlineInputBorder(),
                  //                 ),
                  //               ),
                  //             ),
                  //             const SizedBox(width: 8),
                  //             ElevatedButton(
                  //               onPressed: () async {
                  //                 final DioService dioService = DioService();
                  //                 try {
                  //                   var response = await dioService.dio.post(
                  //                     '${baseURL}api/user/guestbook',
                  //                     data: {
                  //                       'user_id': widget.userId,
                  //                       'content': commentController.text,
                  //                     },
                  //                   );
                  //                   print(response);
                  //                   setState(() {
                  //                     loadProfiles();
                  //                   });
                  //                 } catch (err) {
                  //                   print(err);
                  //                 }
                  //               },
                  //               child: const Text('게시'),
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     : const SizedBox(height: 0, width: 0),
                ],
              )
            : const Center(
                child:
                    CircularProgressIndicator(), // 데이터가 로드되지 않았을 경우 로딩 인디케이터 표시
              ),
      ),
    );
  }

  void _showWriteCommentModal() {
    TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 10),
                    Text(
                      '방명록 작성하기',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: commentController,
                  style: const TextStyle(
                    color: Color(0xFF919191),
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    hintText: "댓글을 입력하세요",
                    hintStyle: const TextStyle(color: Color(0xFF919191)),
                    fillColor: Color.fromARGB(255, 218, 214, 214),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 2, // 여러 줄의 텍스트 입력을 허용
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity, // 버튼이 가로 길이 전체를 차지하도록 설정
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0))),
                      padding: EdgeInsets.symmetric(vertical: 16), // 버튼 높이 조절
                      backgroundColor: Color(0xFF568EF8), // 버튼 배경색을 파란색으로 설정
                    ),
                    onPressed: () async {
                      if (commentController.text.isNotEmpty) {
                        final DioService dioService = DioService();
                        try {
                          var response = await dioService.dio.post(
                            '${baseURL}api/user/guestbook',
                            data: {
                              'user_id': widget.userId,
                              'content': commentController.text,
                            },
                          );
                          print(response);
                          setState(() {
                            loadProfiles();
                          });
                        } catch (err) {
                          print(err);
                        }
                        Navigator.pop(context); // 바텀시트 닫기
                      }
                    },
                    child: const Text(
                      '작성하기',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
