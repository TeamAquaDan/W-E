import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/api/account_book/account_book_api.dart';
import 'package:frontend/api/account_book/account_book_model.dart';
import 'package:intl/intl.dart';

class FormAccountBook extends StatefulWidget {
  final Map<String, dynamic>? accountBookData;
  const FormAccountBook({Key? key, this.accountBookData}) : super(key: key);
  @override
  _FormAccountBookState createState() => _FormAccountBookState();
}

class _FormAccountBookState extends State<FormAccountBook> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  // TextEditingController _dateController = TextEditingController();
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isPatch = false;
  int? accountBookCategory;
  @override
  void initState() {
    super.initState();
    // Set initial values if accountBookData is provided
    if (widget.accountBookData != null) {
      _titleController.text =
          widget.accountBookData!['account_book_title'] ?? '';
      _amountController.text =
          widget.accountBookData!['account_book_amt']?.toString() ?? '';
      // Set selected date and time
      String dateString = widget.accountBookData!['account_book_dtm'];
      DateTime dateTime = DateFormat('yyyy.MM.dd HH:mm').parse(dateString);
      _selectedDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
      _selectedTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
      // Set selected category
      _selectedCategory = widget.accountBookData!['account_book_category'];
      _isPatch = true;
      accountBookCategory = widget.accountBookData!['account_book_id'];
      print(widget.accountBookData!['account_book_id'].runtimeType);
    }
  }

  @override
  Widget build(BuildContext context) {
    var category = [
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
    ];
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
              const SizedBox(height: 12),
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
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: TextEditingController(
                          text: DateFormat('yyyy-MM-dd').format(_selectedDate)),
                      readOnly: true,
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null && pickedDate != _selectedDate)
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                      },
                      decoration: InputDecoration(labelText: '날짜'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a date';
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: TextEditingController(
                          text: DateFormat('HH:mm').format(DateTime(2024, 3, 12,
                              _selectedTime.hour, _selectedTime.minute))),
                      readOnly: true,
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (pickedTime != null && pickedTime != _selectedTime)
                          setState(() {
                            _selectedTime = pickedTime;
                          });
                      },
                      decoration: InputDecoration(labelText: '시간'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a time';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                items: category,
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
    DateTime selectedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);

    AccountBook newAccountBook = AccountBook(
      accountBookTitle: _titleController.text,
      accountAmount: int.parse(_amountController.text),
      accountBookDate: formattedDateTime,
      accountBookCategory: _selectedCategory ?? "000",
    );
    print(formattedDateTime);
    if (_isPatch) {
      patchAccountBook(newAccountBook, accountBookCategory!);
    } else {
      postAccountBook(newAccountBook);
    }
  }
}
