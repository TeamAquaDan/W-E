import 'package:flutter/material.dart';
import 'package:frontend/api/account_book/account_book_api.dart';
import 'package:frontend/api/account_book/account_book_model.dart';

class FormAccountBook extends StatefulWidget {
  @override
  _FormAccountBookState createState() => _FormAccountBookState();
}

class _FormAccountBookState extends State<FormAccountBook> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('거래내역 추가하기'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: '제목'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: '금액'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration:
                    InputDecoration(labelText: 'Date (yyyy-MM-dd hh:mm)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: "001",
                    child: Text("식비"),
                  ),
                  DropdownMenuItem(
                    value: "002",
                    child: Text("카페/간식"),
                  ),
                  DropdownMenuItem(
                    value: "003",
                    child: Text("생활"),
                  ),
                  DropdownMenuItem(
                    value: "004",
                    child: Text("주거/통신"),
                  ),
                  DropdownMenuItem(
                    value: "005",
                    child: Text("온라인쇼핑"),
                  ),
                  DropdownMenuItem(
                    value: "006",
                    child: Text("패션/쇼핑"),
                  ),
                  DropdownMenuItem(
                    value: "007",
                    child: Text("뷰티/미용"),
                  ),
                  DropdownMenuItem(
                    value: "008",
                    child: Text("의료/건강"),
                  ),
                  DropdownMenuItem(
                    value: "009",
                    child: Text("문화/여가"),
                  ),
                  DropdownMenuItem(
                    value: "010",
                    child: Text("여행/숙박"),
                  ),
                  DropdownMenuItem(
                    value: "011",
                    child: Text("경조/선물"),
                  ),
                  DropdownMenuItem(
                    value: "012",
                    child: Text("반려동물"),
                  ),
                  DropdownMenuItem(
                    value: "013",
                    child: Text("교육/학습"),
                  ),
                  DropdownMenuItem(
                    value: "014",
                    child: Text("술/유흥"),
                  ),
                  DropdownMenuItem(
                    value: "015",
                    child: Text("교통"),
                  ),
                  DropdownMenuItem(
                    value: "000",
                    child: Text("기타"),
                  ),
                  DropdownMenuItem(
                    value: "100",
                    child: Text("수입"),
                  ),
                ],
                decoration: InputDecoration(labelText: '카테고리'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submitForm();
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    // Create an AccountBook object from the form input
    AccountBook newAccountBook = AccountBook(
      accountBookTitle: _titleController.text,
      accountAmount: int.parse(_amountController.text),
      accountBookDate: _dateController.text,
      accountBookCategory: _selectedCategory ?? "000",
    );

    // Call the postAccountBook function to send data to the server
    postAccountBook(newAccountBook);
  }
}
