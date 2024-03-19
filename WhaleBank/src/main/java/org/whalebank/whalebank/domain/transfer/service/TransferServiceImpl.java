package org.whalebank.whalebank.domain.transfer.service;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.transaction.Transactional;
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
import org.whalebank.whalebank.domain.transfer.dto.request.InquiryRequest;
import org.whalebank.whalebank.domain.transfer.dto.response.InquiryResponse;
import org.whalebank.whalebank.domain.transfer.repository.TransferRepository;
import org.whalebank.whalebank.global.bank.CodeRepository;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class TransferServiceImpl implements TransferService {

  private final TokenProvider tokenProvider;
  private final AccountRepository accountRepository;
  private final TransferRepository transferRepository;
  private final CodeRepository codeRepository;
  private final AuthRepository authRepository;

  @Override
  public InquiryResponse inquiryReceive(HttpServletRequest request, InquiryRequest inquiryRequest) {

    // 로그인 유저 확인

    String token = request.getHeader("Authorization").replace("Bearer ", "");

    String userId = tokenProvider.getUserId(token).get("sub", String.class);

    // 입금은행
    String bankName = codeRepository.findById(inquiryRequest.getBank_code_std()).get()
        .getBankName();

    // 출금은행
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
        .bank_code_std(inquiryRequest.getBank_code_std())
        .bank_name(bankName)
        .account_num(inquiryRequest.getAccount_num())
        .account_holder_name(accountHolderName)
        .wd_bank_name(reqBankName)
        .wd_account_num(inquiryRequest.getReq_client_account_num())
        .tran_amt(inquiryRequest.getTran_amt())
        .build();
  }
}
