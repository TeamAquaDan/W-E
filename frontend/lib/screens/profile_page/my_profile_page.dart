import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dioImport;
import 'package:get/get.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/models/store/user/user_controller.dart';
import 'package:frontend/screens/friends_page/my_friends_page.dart';
import 'package:frontend/services/dio_service.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  late List<dynamic> myProfileList = [];
  final TextEditingController bioController = TextEditingController();
  bool isEditing = false;
  File? _image;

  @override
  void initState() {
    super.initState();
    loadProfiles();
  }

  Future<void> loadProfiles() async {
    // 예시: 프로필 정보 로딩 함수
    var fetchedProfile = await fetchProfilesFromAPI();
    setState(() {
      myProfileList = fetchedProfile;
    });
  }

  Future<List<dynamic>> fetchProfilesFromAPI() async {
    // 예시: API 요청하여 프로필 정보 가져오기
    final DioService dioService = DioService();
    try {
      var userId = Get.find<UserController>().getUserId();
      var response =
          await dioService.dio.get('${baseURL}api/user/profile/$userId');
      return [response.data]; // 예시 응답
    } catch (e) {
      print("Error fetching profile: $e");
      return [];
    }
  }

  void updateInfo() async {
    // 프로필 정보 업데이트 함수
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('갤러리'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('카메라'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future _imgFromCamera() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
    });
  }

  Future _imgFromGallery() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
    });
  }

  Future<void> uploadProfileImage(File image) async {
    // 파일 업로드 함수
    String fileName = image.path.split('/').last;
    dioImport.FormData formData = dioImport.FormData.fromMap({
      "file": await dioImport.MultipartFile.fromFile(image.path,
          filename: fileName),
    });

    final DioService dioService = DioService();
    try {
      var response = await dioService.dio.post(
        '${baseURL}api/user/profile/photo',
        data: formData,
      );
      if (response.statusCode == 200) {
        print("업로드 성공: ${response.data}");
        // 업로드 성공 후 로직, 예: 프로필 정보 재로딩
        loadProfiles();
      } else {
        print("업로드 실패: ${response.statusCode}");
      }
    } catch (e) {
      print("업로드 중 에러 발생: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 프로필'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xffFDCF09),
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          _image!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
            ),
            // 여기에 나머지 프로필 정보 UI 추가
          ],
        ),
      ),
    );
  }
}
