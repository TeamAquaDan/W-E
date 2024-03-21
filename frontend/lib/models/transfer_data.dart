class TransferReceivePost {
  TransferReceivePost({
    required this.bank_code_std,
    required this.account_num,
  });

  final String bank_code_std;
  final String account_num;
}

class TransferReceiveResponse {
  TransferReceiveResponse({
    required this.bank_name,
    required this.account_num,
    required this.account_holder_name,
  });

  final String bank_name;
  final String account_num;
  final List<String> account_holder_name;
}

class TransferPost {
  TransferPost({
    required this.tran_amt,
    required this.req_account_id,
    required this.req_account_num,
    required this.req_account_password,
    required this.recv_client_bank_code,
    required this.recv_client_account_num,
    required this.recv_client_name,
    required this.req_trans_memo,
    required this.recv_trans_memo,
  });

  final int tran_amt;
  final int req_account_id;
  final String req_account_num;
  String req_account_password;
  final String recv_client_bank_code;
  final String recv_client_account_num;
  final String recv_client_name;
  final String req_trans_memo;
  final String recv_trans_memo;
}
/*
"{
  ""bank_code_std"" : ""string, 입금 은행 표준 코드"",
  ""account_num' : ""string, 입금 계좌번호""
}"

"{
  ""status"": 200,
  ""message"": ""수취인 조회 성공"", 
  ""data"": 
  {
    ""bank_name"" : ""string, 입금 은행 이름"",
    ""account_num"" : ""string, 입금 계좌번호,
    ""account_holder_name"": [""string, 수취인성명"", ]
  }
}

{
  ""status"": 200,
  ""message"": ""수취인 조회 성공"",
  ""data"": {
    ""bank_name"": ""웨일뱅크"",
    ""account_num"": ""12345678"",
    ""account_holder_name"": [
      ""김가영"",
      ""공동소유주""
    ]
  }
}" 
*/
/* 
{
  ""tran_amt"": ""int, 거래금액"",
  ""req_account_id"": int, 계좌 고유 번호(출금 계좌),
  ""req_account_num"": ""string, 출금 계좌 번호"",
  ""req_account_password"" : ""string, 요청고객 계좌 비밀번호"",
  ""recv_client_bank_code"": ""string, 최종수취고객계좌 개설기관 표준코드"",
  ""recv_client_account_num"": ""string, 최종수취고객 계좌번호"", 
  ""recv_client_name"": string, 수취인 성명
  ""req_trans_memo"" : ""string, 내 거래내역에 표기할 메모"",
  ""recv_trans_memo"": ""string, 상대방 거래내역에 표기할 메모""
}

계좌번호 ""-"" 포함 x"
*/