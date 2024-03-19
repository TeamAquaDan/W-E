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
  });

  final int account_id;
  final String account_name;
  final String account_num;
  final int balance_amt;
  final int account_type;
}

/* 계좌 거래 내역 조회
request body
"{
  ""account_id"": ""int, 계좌고유번호""
}"

"{
  ""status"": 200,
  ""message"": ""거래 내역 조회 성공"", 
  ""data"": [
    {
      ""trans_type"": ""int, 거래유형"", 
      ""trans_amt"": ""int, 거래금액"",
      ""balance_amt"": ""int, 거래 후 잔액"", 
      ""trans_memo"": ""string, 적요"",
      ""trans_dtm"": ""string, 거래일시"",
      ""trans_date"": ""string, 거래일자"", 
      ""trans_title"": ""string, 거래제목"",
      ""recv_client_name"": ""string, 수취고객성명"",
      ""recv_client_account_num"": ""string, 최종수취고객계좌번호"",
      ""recv_client_bank"" : ""string, 최종수취고객계좌 개설기관 이름""
      ""recv_client_bank_code"": ""string, 최종수취고객계좌 개설기관 표준코드""
    }
  ]
}"
*/
class AccountHistoryData {
  AccountHistoryData({
    required this.trans_type,
    required this.trans_amt,
    required this.balance_amt,
    required this.trans_memo,
    required this.trans_dtm,
    required this.trans_date,
    required this.trans_title,
    required this.recv_client_name,
    required this.recv_client_account_num,
    required this.recv_client_bank,
    required this.recv_client_bank_code,
  });

  final int trans_type;
  final int trans_amt;
  final int balance_amt;
  final String trans_memo;
  final String trans_dtm;
  final String trans_date;
  final String trans_title;
  final String recv_client_name;
  final String recv_client_account_num;
  final String recv_client_bank;
  final String recv_client_bank_code;
}
