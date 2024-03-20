package org.whalebank.whalebank.domain.transfer.service;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.transaction.Transactional;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.whalebank.whalebank.domain.account.AccountEntity;
import org.whalebank.whalebank.domain.account.repository.AccountRepository;
import org.whalebank.whalebank.domain.auth.AuthEntity;
import org.whalebank.whalebank.domain.auth.repository.AuthRepository;
import org.whalebank.whalebank.domain.auth.security.TokenProvider;
import org.whalebank.whalebank.domain.transfer.TransferEntity;
import org.whalebank.whalebank.domain.transfer.dto.request.DepositRequest;
import org.whalebank.whalebank.domain.transfer.dto.request.InquiryRequest;
import org.whalebank.whalebank.domain.transfer.dto.request.WithdrawRequest;
import org.whalebank.whalebank.domain.transfer.dto.response.DepositResponse;
import org.whalebank.whalebank.domain.transfer.dto.response.InquiryResponse;
import org.whalebank.whalebank.domain.transfer.dto.response.WithdrawResponse;
import org.whalebank.whalebank.domain.transfer.repository.TransferRepository;
import org.whalebank.whalebank.global.bank.CodeRepository;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class TransferServiceImpl implements TransferService {

  private final TokenProvider tokenProvider;
  private final AccountRepository accountRepository;
  private final CodeRepository codeRepository;
  private final AuthRepository authRepository;
  private final TransferRepository transferRepository;

  @Override
  public InquiryResponse inquiryReceive(HttpServletRequest request, InquiryRequest inquiryRequest) {

    // 로그인 유저 확인
    String token = request.getHeader("Authorization").replace("Bearer ", "");
    String userId = tokenProvider.getUserId(token).get("sub", String.class);

    // 수취은행
    String bankName = codeRepository.findById(inquiryRequest.getBank_code_std()).get()
        .getBankName();

    // 요청은행
    String reqBankName = codeRepository.findById(inquiryRequest.getReq_client_bank_code()).get()
        .getBankName();

    // 입금계좌
    AccountEntity account = accountRepository.findByBankCodeAndAccountNum(
        inquiryRequest.getBank_code_std(), inquiryRequest.getAccount_num());

    if (account == null) {
      // 해당하는 계좌가 존재하지 않으면 수취인명을 돌려줄 수 없다.
      return InquiryResponse
          .builder()
          .rsp_code(404)
          .rsp_message("수취인에 해당하는 계좌가 없습니다.")
          .api_tran_dtm(LocalDateTime.now())
          .bank_code_std(inquiryRequest.getBank_code_std())
          .bank_name(bankName)
          .account_num(inquiryRequest.getAccount_num())
          .wd_bank_name(reqBankName)
          .wd_account_num(inquiryRequest.getReq_client_account_num())
          .tran_amt(inquiryRequest.getTran_amt())
          .build();
    }

    List<AuthEntity> receive = authRepository.findByAccountList_AccountId(account.getAccountId());

    String accountHolderName = "";  // 수취인명

    if (receive.size() == 1) {
      // 해당하는 사용자가 한명인 경우
      accountHolderName = receive.get(0).getUserName();
    } else {
      // 모임통장인 경우
      for (AuthEntity a : receive) {
        accountHolderName += a.getUserName() + " ";
      }

      accountHolderName = accountHolderName.substring(0, accountHolderName.length() - 1);
    }

    return InquiryResponse
        .builder()
        .rsp_code(200)
        .rsp_message("수취인 조회에 성공했습니다.")
        .api_tran_dtm(LocalDateTime.now())
        .req_client_name(inquiryRequest.getReq_client_name())
        .bank_code_std(inquiryRequest.getBank_code_std())
        .bank_name(bankName)
        .account_num(inquiryRequest.getAccount_num())
        .account_holder_name(accountHolderName)
        .wd_bank_name(reqBankName)
        .wd_account_num(inquiryRequest.getReq_client_account_num())
        .tran_amt(inquiryRequest.getTran_amt())
        .build();
  }

  @Override
  public WithdrawResponse withdrawTransfer(HttpServletRequest request,
      WithdrawRequest withdrawRequest) {

    // 로그인 유저 확인
    String token = request.getHeader("Authorization").replace("Bearer ", "");
    String userId = tokenProvider.getUserId(token).get("sub", String.class);

    // 수취은행
    String recvBankName = codeRepository.findById(withdrawRequest.getReq_client_bank_code()).get()
        .getBankName();

    // 요청계좌
    AccountEntity reqAccount = accountRepository.findByBankCodeAndAccountNum(
        withdrawRequest.getReq_client_bank_code(), withdrawRequest.getReq_client_account_num());

    // 계좌 비밀번호가 틀렸을 때
    if (!reqAccount.getAccountPassword().equals(withdrawRequest.getAccount_password())) {
      return WithdrawResponse
          .builder()
          .rsp_code(401)
          .rsp_message("계좌 비밀번호가 틀렸습니다.")
          .build();
    }

    // 잔액 부족
    if (reqAccount.getBalanceAmt() < withdrawRequest.getTran_amt()) {
      return WithdrawResponse
          .builder()
          .rsp_code(402)
          .rsp_message("잔액이 부족합니다.")
          .build();
    }

    // 1회 이체 한도 초과
    if (reqAccount.getOnceLimitAmt() < withdrawRequest.getTran_amt()) {
      return WithdrawResponse
          .builder()
          .rsp_code(403)
          .rsp_message("이체 한도가 초과되었습니다.")
          .build();
    }

    // 현재 잔액 = 현재잔액 - 이체금액
    reqAccount.setBalanceAmt(reqAccount.getBalanceAmt() - withdrawRequest.getTran_amt());

    // 출금가능액 = 출금가능액 - 이체금액
    reqAccount.setWithdrawableAmt(reqAccount.getWithdrawableAmt() - withdrawRequest.getTran_amt());

    TransferEntity transfer = TransferEntity.createTransfer(withdrawRequest,
        reqAccount.getBalanceAmt());

    transferRepository.save(transfer);

    reqAccount.addTransfer(transfer);

    return WithdrawResponse
        .builder()
        .rsp_code(200)
        .rsp_message("출금이체 등록에 성공했습니다.")
        .api_tran_id(transfer.getTransId())
        .api_tran_dtm(transfer.getTransDtm())
        .dps_bank_code_std(withdrawRequest.getReq_client_bank_code())
        .dps_bank_name(recvBankName)
        .dps_account_num_masked(withdrawRequest.getRecv_client_account_num())
        .dps_account_holder_name(withdrawRequest.getRecv_client_name())
        .account_holder_name(withdrawRequest.getReq_client_name())
        .tran_amt(withdrawRequest.getTran_amt())
        .wd_limit_remain_amt(reqAccount.getWithdrawableAmt())
        .balance_amt(reqAccount.getBalanceAmt())
        .trans_memo(withdrawRequest.getReq_trans_memo())
        .build();
  }

  @Override
  public DepositResponse depositTransfer(HttpServletRequest request,
      DepositRequest depositRequest) {

    String token = request.getHeader("Authorization").replace("Bearer ", "");
    String userId = tokenProvider.getUserId(token).get("sub", String.class);

    // 요청은행명
    String reqBankName = codeRepository.findById(depositRequest.getReq_client_bank_code()).get()
        .getBankName();

    // 수취은행명
    String recvBankName = codeRepository.findById(depositRequest.getRecv_client_bank_code()).get()
        .getBankName();

    // 요청계좌
    AccountEntity reqAccount = accountRepository.findByBankCodeAndAccountNum(
        depositRequest.getReq_client_bank_code(), depositRequest.getReq_client_account_num());

    // 수취계좌
    AccountEntity recvAccount = accountRepository.findByBankCodeAndAccountNum(
        depositRequest.getRecv_client_bank_code(), depositRequest.getRecv_client_account_num());

    // 현재 잔액 = 현재잔액 + 이체금액
    recvAccount.setBalanceAmt(recvAccount.getBalanceAmt() + depositRequest.getTrans_amt());

    TransferEntity transfer = TransferEntity.createTransfer(depositRequest,
        reqAccount.getBalanceAmt());

    transferRepository.save(transfer);

    reqAccount.addTransfer(transfer);

    return DepositResponse
        .builder()
        .rsp_code(200)
        .rsp_message("입금이체 등록에 성공했습니다.")
        .api_tran_id(transfer.getTransId())
        .api_tran_dtm(transfer.getTransDtm())
        .wd_bank_code_std(reqAccount.getBankCode())
        .wd_bank_name(reqBankName)
        .wd_account_num_masked(reqAccount.getAccountNum())
        .wd_account_holder_name(depositRequest.getReq_client_name())
        .bank_tran_date(transfer.getTransDate())
        .account_name(recvAccount.getAccountName())
        .bank_code_std(depositRequest.getRecv_client_bank_code())
        .bank_name(recvBankName)
        .account_num_masked(depositRequest.getRecv_client_account_num())
        .account_holder_name(depositRequest.getRecv_client_name())
        .tran_amt(depositRequest.getTrans_amt())
        .balance_amt(recvAccount.getBalanceAmt())
        .trans_memo(depositRequest.getRecv_trans_memo())
        .build();
  }

}
