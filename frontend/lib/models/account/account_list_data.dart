/* 계좌 목록 조회
request body 없음

"{
  ""status"": 200,
  ""message"": ""계좌 목록 조회 성공"", 
  ""data"": [
    {
      ""account_id"": ""int, 계좌고유번호"",
      ""account_name"": ""string, 계좌명"",
      ""account_num"": ""string, 계좌번호"",
      ""balance_amt"": ""int, 현재잔액"",
      ""account_type: ""int, 계좌구분""
    }
  ]
}"
*/

class AccountListData {
  AccountListData({
    required this.account_id,
    required this.account_name,
    required this.account_num,
    required this.balance_amt,
    required this.account_type,
    required this.is_mainAccount,
  });

  final int account_id;
  final String account_name;
  final String account_num;
  final int balance_amt;
  final int account_type;
  final bool is_mainAccount;

  factory AccountListData.fromJson(Map<String, dynamic> json) {
    return AccountListData(
      account_id: json['account_id'] as int,
      account_name: json['account_name'] as String,
      account_num: json['account_num'] as String,
      balance_amt: json['balance_amt'] as int,
      account_type: json['account_type'] as int,
      is_mainAccount: json['is_mainAccount'] as bool,
    );
  }

  factory AccountListData.initial() {
    return AccountListData(
      account_id: 0, // Replace with appropriate initial value
      account_name: '', // Replace with appropriate initial value
      account_num: '', // Replace with appropriate initial value
      balance_amt: 0, // Replace with appropriate initial value
      account_type: 0, // Replace with appropriate initial value
      is_mainAccount: false, // Replace with appropriate initial value
    );
  }
}

// "{
//   ""status"": 200,
//   ""message"": ""계좌 상세 조회 성공"",
//   ""data"": {
//      ""account_id"": ""int, 계좌고유번호"",
//      ""account_name"": ""string, 계좌명"",
//      ""account_num"": ""string, 계좌번호"",
//      ""balance_amt"": ""int, 현재잔액"",
//      ""account_type: ""int, 계좌구분"",
//     ""issue_date"": ""string, 개설일자"",
//     ""day_limit_amt"": ""int, 1일 한도"",
//     ""once_limit_amt"": ""int, 1회 한도""
//   }
// }"
class AccountDetailData {
  AccountDetailData({
    required this.account_id,
    required this.account_name,
    required this.account_num,
    required this.balance_amt,
    required this.account_type,
    required this.issue_date,
    required this.day_limit_amt,
    required this.once_limit_amt,
  });

  final int account_id;
  final String account_name;
  final String account_num;
  final int balance_amt;
  final int account_type;
  final String issue_date;
  final int day_limit_amt;
  final int once_limit_amt;

  factory AccountDetailData.fromJson(Map<String, dynamic> json) {
    return AccountDetailData(
      account_id: json['account_id'] as int,
      account_name: json['account_name'] as String,
      account_num: json['account_num'] as String,
      balance_amt: json['balance_amt'] as int,
      account_type: json['account_type'] as int,
      issue_date: json['issue_date'] as String,
      day_limit_amt: json['day_limit_amt'] as int,
      once_limit_amt: json['once_limit_amt'] as int,
    );
  }
}

/* 계좌 거래 내역 조회
request body
"{
  ""account_id"": ""int, 계좌고유번호"",
  ""start_date"": string, 거래 조회 시작일 yyyy-mm-dd,
  ""end_date"" string,거래 조회 마지막일: yyyy-mm-dd 
}"

"{
  ""status"": 200,
  ""message"": ""거래 내역 조회 성공"", 
  ""data"": [
    {
      "trans_type": "int, 거래유형",  2번 출금 3번 입금
      "trans_amt": "int, 거래금액",
      "balance_amt": "int, 거래 후 잔액", 
      "trans_memo": "string, 적요",
      "trans_dtm": "string, 거래일시",
      // "trans_date": "string, 거래일자", 
      // "trans_title": "string, 거래제목",
      // "recv_client_name": "string, 수취고객성명",
      // "recv_client_account_num": "string, 최종수취고객계좌번호",
      // "recv_client_bank" : "string, 최종수취고객계좌 개설기관 이름",
      // "recv_client_bank_code": "string, 최종수취고객계좌 개설기관 표준코드"
    }
  ]
}"
*/
class AccountHistoryBody {
  AccountHistoryBody({
    required this.account_id,
    required this.start_date,
    required this.end_date,
  });

  final int account_id;
  final String start_date;
  final String end_date;

  Map<String, dynamic> toMap() {
    return {
      'account_id': account_id,
      'start_date': start_date,
      'end_date': end_date,
    };
  }
}

class AccountHistoryData {
  AccountHistoryData({
    required this.trans_type,
    required this.trans_amt,
    required this.balance_amt,
    required this.trans_memo,
    required this.trans_dtm,
    // required this.trans_date,
    // required this.trans_title,
    // required this.recv_client_name,
    // required this.recv_client_account_num,
    // required this.recv_client_bank,
    // required this.recv_client_bank_code,
  });

  final int trans_type;
  final int trans_amt;
  final int balance_amt;
  final String trans_memo;
  final String trans_dtm;
  // final String trans_date;
  // final String trans_title;
  // final String recv_client_name;
  // final String recv_client_account_num;
  // final String recv_client_bank;
  // final String recv_client_bank_code;

  factory AccountHistoryData.fromJson(Map<String, dynamic> json) {
    return AccountHistoryData(
      trans_type: json['trans_type'],
      trans_amt: json['trans_amt'],
      balance_amt: json['balance_amt'],
      trans_memo: json['trans_memo'],
      trans_dtm: json['trans_dtm'],
    );
  }
}
