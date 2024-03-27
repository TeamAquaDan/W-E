import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:frontend/screens/friends_page/widgets/friends_request_modal.dart';

class ContactsModal extends StatefulWidget {
  const ContactsModal({super.key});

  @override
  _ContactsModalState createState() => _ContactsModalState();
}

class _ContactsModalState extends State<ContactsModal> {
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _getPermissions();
  }

  Future<void> _getPermissions() async {
    var permissionStatus = await Permission.contacts.status;
    if (permissionStatus.isGranted) {
      _loadContacts();
    } else {
      await Permission.contacts.request();
      if (await Permission.contacts.isGranted) {
        _loadContacts();
      } else {
        // 사용자가 연락처 접근 권한을 거부했습니다. 적절한 처리를 해주세요.
        print("연락처 접근 권한이 거부되었습니다.");
      }
    }
  }

  Future<void> _loadContacts() async {
    List<Contact> contacts = (await ContactsService.getContacts()).toList();
    setState(() {
      _contacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("연락처"),
      ),
      body: _contacts.isNotEmpty
          ? ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                Contact contact = _contacts[index];
                return ListTile(
                  onTap: () {
                    print(_contacts[index].displayName);
                    print(_contacts[index].phones!.first.value);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return FriendsRequestModal(
                            friendName: _contacts[index].displayName ?? "",
                            friendPhoneNumber:
                                _contacts[index].phones!.first.value ?? "");
                      },
                    ).then((value) {
                      if (value == true) {
                        // 사용자가 '예'를 선택했을 때의 처리 로직
                        print('예 누름');
                      } else {
                        // 사용자가 '아니오'를 선택했을 때의 처리 로직 또는 아무것도 하지 않음
                        print('아니오 누름');
                      }
                    });
                  },
                  leading:
                      (contact.avatar != null && contact.avatar!.isNotEmpty)
                          ? CircleAvatar(
                              backgroundImage: MemoryImage(contact.avatar!),
                            )
                          : CircleAvatar(
                              child: Text(contact.initials()),
                            ),
                  title: Text(contact.displayName ?? ""),
                  subtitle: contact.phones!.isNotEmpty
                      ? Text(contact.phones!.first.value ?? "")
                      : null,
                );
              },
            )
          : const Center(
              child: Text(
                '저장된 연락처가 없습니다.',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
