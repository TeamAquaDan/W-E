import 'package:flutter/material.dart';
import 'package:frontend/models/account_list_data.dart';

List<AccountHistoryData> dummyDataList = [
  AccountHistoryData(
      trans_type: 2,
      trans_amt: 150000,
      balance_amt: 3630000,
      trans_memo: "식료품 구매",
      trans_dtm: "2024-03-19 09:23:45",
      trans_date: "2024-03-19",
      trans_title: "마트에서 식료품 구매",
      recv_client_name: "홍길동",
      recv_client_account_num: "123-456-789012",
      recv_client_bank: "국민은행",
      recv_client_bank_code: "004"),
  AccountHistoryData(
      trans_type: 3,
      trans_amt: 3000000,
      balance_amt: 3780000,
      trans_memo: "월급 수령",
      trans_dtm: "2024-03-18 15:30:00",
      trans_date: "2024-03-18",
      trans_title: "회사 월급 지급",
      recv_client_name: "회사명",
      recv_client_account_num: "987-654-321098",
      recv_client_bank: "신한은행",
      recv_client_bank_code: "088"),
  AccountHistoryData(
      trans_type: 2,
      trans_amt: 30000,
      balance_amt: 780000,
      trans_memo: "카페에서 커피 구매",
      trans_dtm: "2024-03-17 11:45:22",
      trans_date: "2024-03-17",
      trans_title: "카페에서 아메리카노 구매",
      recv_client_name: "김철수",
      recv_client_account_num: "456-789-012345",
      recv_client_bank: "하나은행",
      recv_client_bank_code: "081"),
  AccountHistoryData(
      trans_type: 2,
      trans_amt: 80000,
      balance_amt: 810000,
      trans_memo: "통신비 납부",
      trans_dtm: "2024-03-16 14:20:10",
      trans_date: "2024-03-16",
      trans_title: "통신요금 납부",
      recv_client_name: "통신사명",
      recv_client_account_num: "654-321-098765",
      recv_client_bank: "우리은행",
      recv_client_bank_code: "020"),
  AccountHistoryData(
      trans_type: 2,
      trans_amt: 20000,
      balance_amt: 890000,
      trans_memo: "도서 구매",
      trans_dtm: "2024-03-15 16:55:33",
      trans_date: "2024-03-15",
      trans_title: "인터넷 서점에서 책 구매",
      recv_client_name: "홍길동",
      recv_client_account_num: "123-456-789012",
      recv_client_bank: "국민은행",
      recv_client_bank_code: "004"),
  AccountHistoryData(
      trans_type: 2,
      trans_amt: 120000,
      balance_amt: 910000,
      trans_memo: "임대료 지불",
      trans_dtm: "2024-03-14 08:10:05",
      trans_date: "2024-03-14",
      trans_title: "사무실 임대료 지불",
      recv_client_name: "건물주성명",
      recv_client_account_num: "789-012-345678",
      recv_client_bank: "신한은행",
      recv_client_bank_code: "088"),
  AccountHistoryData(
      trans_type: 2,
      trans_amt: 60000,
      balance_amt: 1030000,
      trans_memo: "점심 식사",
      trans_dtm: "2024-03-13 12:30:15",
      trans_date: "2024-03-13",
      trans_title: "회사 근처 식당에서 점심",
      recv_client_name: "없음",
      recv_client_account_num: "",
      recv_client_bank: "",
      recv_client_bank_code: ""),
  AccountHistoryData(
      trans_type: 2,
      trans_amt: 50000,
      balance_amt: 1090000,
      trans_memo: "카드 대금 지불",
      trans_dtm: "2024-03-12 17:45:50",
      trans_date: "2024-03-12",
      trans_title: "신용카드 대금 지불",
      recv_client_name: "신용카드사",
      recv_client_account_num: "000-111-222333",
      recv_client_bank: "KB국민카드",
      recv_client_bank_code: "001"),
  AccountHistoryData(
      trans_type: 2,
      trans_amt: 70000,
      balance_amt: 1140000,
      trans_memo: "의류 매입",
      trans_dtm: "2024-03-11 10:20:40",
      trans_date: "2024-03-11",
      trans_title: "온라인 의류 쇼핑몰에서 구매",
      recv_client_name: "홍길동",
      recv_client_account_num: "123-456-789012",
      recv_client_bank: "국민은행",
      recv_client_bank_code: "004"),
  AccountHistoryData(
      trans_type: 2,
      trans_amt: 90000,
      balance_amt: 1210000,
      trans_memo: "이월 금액 입금",
      trans_dtm: "2024-03-10 09:00:00",
      trans_date: "2024-03-10",
      trans_title: "전월 이월 잔액 입금",
      recv_client_name: "없음",
      recv_client_account_num: "",
      recv_client_bank: "",
      recv_client_bank_code: "")
];
