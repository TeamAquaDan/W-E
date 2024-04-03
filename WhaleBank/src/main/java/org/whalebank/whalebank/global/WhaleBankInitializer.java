package org.whalebank.whalebank.global;

import jakarta.annotation.PostConstruct;
import java.time.LocalDateTime;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.whalebank.whalebank.domain.account.AccountEntity;
import org.whalebank.whalebank.domain.account.repository.AccountRepository;
import org.whalebank.whalebank.domain.auth.AuthEntity;
import org.whalebank.whalebank.domain.auth.repository.AuthRepository;
import org.whalebank.whalebank.domain.transfer.repository.TransferRepository;
import org.whalebank.whalebank.global.bank.CodeEntity;
import org.whalebank.whalebank.global.bank.CodeRepository;

  /*
@Component
@RequiredArgsConstructor
public class WhaleBankInitializer {

  private final AccountRepository accountRepository;
  private final AuthRepository authRepository;
  private final TransferRepository transferRepository;
  private final CodeRepository codeRepository;


  @PostConstruct
  public void init() {
    // 은행 더미 저장
    String[][] bankCodeAndNames = new String[][]{{"039", "경남은행"}, {"034", "광주은행"}, {"032", "부산은행"},
        {"088", "신한은행"}, {"027", "씨티은행"}, {"020", "우리은행"}, {"037", "제주은행"}, {"090", "카카오뱅크"},
        {"092", "토스뱅크"}, {"081", "하나은행"}, {"004", "KB국민은행"}, {"031", "DGB대구은행"}, {"011", "NH농협은행"},
        {"103", "웨일뱅크"}};
    for (String[] bankCodeAndName : bankCodeAndNames) {
      CodeEntity entity = new CodeEntity(bankCodeAndName[0], bankCodeAndName[1]);
      codeRepository.save(entity);
    }

    // 사용자, 계좌
    // 시연 참가자 5명
    AuthEntity child1 = AuthEntity.builder()
        .userName("김싸피")
        .phoneNum("01012345678")
        .userCi("f985dbe0e10a53a0bd84b183cc6b2d76bbd1f96168440b427fc6b56530121ba3")
        .createdDtm(LocalDateTime.of(2024,3,2,10,10))
        .birthDate("20100101")
        .build();
    AccountEntity account11 = AccountEntity.builder()
        .accountNum("010313579135")
        .accountName("호수통장")
        .balanceAmt(300000)
        .accountPassword("1234")
        .AccountType(1)
        .issueDate(LocalDateTime.of(2024,3,2,10,15))
        .bankCode("103")
        .dayLimitAmt(1000000)
        .onceLimitAmt(300000)
        .withdrawableAmt(1000000)
        .build();
    AccountEntity account1 = AccountEntity.builder()
        .accountNum("010312345678")
        .accountName("바다통장")
        .balanceAmt(150000)
        .accountPassword("1234")
        .AccountType(1)
        .issueDate(LocalDateTime.of(2024,3,2,10,15))
        .bankCode("103")
        .dayLimitAmt(5000000)
        .onceLimitAmt(3000000)
        .withdrawableAmt(5000000)
        .build();
    child1.addAccount(account1);
    child1.addAccount(account11);
    accountRepository.save(account1);
    accountRepository.save(account11);
    authRepository.save(child1);

    AuthEntity child2 = AuthEntity.builder()
        .userName("김지원")
        .phoneNum("01023456789")
        .userCi("ebefc4c695fa31a0293d05ffb10e74c3f94bdd254cea4f2ab7525bcedb0e0bc9")
        .createdDtm(LocalDateTime.of(2024,3,2,10,10))
        .birthDate("20100101")
        .build();
    AccountEntity account2 = AccountEntity.builder()
        .accountNum("010323456789")
        .accountName("바다통장")
        .balanceAmt(600000)
        .accountPassword("1234")
        .AccountType(1)
        .issueDate(LocalDateTime.of(2024,3,2,10,15))
        .bankCode("103")
        .dayLimitAmt(5000000)
        .onceLimitAmt(1000000)
        .withdrawableAmt(5000000)
        .build();
    child2.addAccount(account2);
    accountRepository.save(account2);
    authRepository.save(child2);

    AuthEntity child3 = AuthEntity.builder()
        .userName("김지우")
        .phoneNum("01034567890")
        .userCi("9a53ef0553ffe0d8269f400113a775a3d9626398ab8b5579ff6e431d30034476")
        .createdDtm(LocalDateTime.of(2024,3,2,10,10))
        .birthDate("20120206")
        .build();
    AccountEntity account3 = AccountEntity.builder()
        .accountNum("010334567890")
        .accountName("바다통장")
        .balanceAmt(700000)
        .accountPassword("1234")
        .AccountType(1)
        .issueDate(LocalDateTime.of(2024,3,2,10,15))
        .bankCode("103")
        .dayLimitAmt(5000000)
        .onceLimitAmt(1000000)
        .withdrawableAmt(5000000)
        .build();
    child3.addAccount(account3);
    accountRepository.save(account3);
    authRepository.save(child3);

    AuthEntity child4 = AuthEntity.builder()
        .userName("박서연")
        .phoneNum("01045678901")
        .userCi("4b19571325faa281fa9201ad1f8bf7d0878c668cdea3bc67dc4c38718d5d4049")
        .createdDtm(LocalDateTime.of(2024,3,2,10,10))
        .birthDate("20120313")
        .build();
    AccountEntity account4 = AccountEntity.builder()
        .accountNum("010345678901")
        .accountName("바다통장")
        .balanceAmt(800000)
        .accountPassword("1234")
        .AccountType(1)
        .issueDate(LocalDateTime.of(2024,3,2,10,15))
        .bankCode("103")
        .dayLimitAmt(5000000)
        .onceLimitAmt(1000000)
        .withdrawableAmt(5000000)
        .build();
    child4.addAccount(account4);
    accountRepository.save(account4);
    authRepository.save(child4);

    AuthEntity adult1 = AuthEntity.builder()
        .userName("김지훈")
        .phoneNum("01087654321")
        .userCi("52f62e5ba77f964f32d932fe5f0a26655123f998fef9641b15fc71980d9bf6de")
        .createdDtm(LocalDateTime.of(2024,3,2,10,10))
        .birthDate("19851005")
        .build();
    AccountEntity account5 = AccountEntity.builder()
        .accountNum("010387654321")
        .accountName("태평양통장")
        .balanceAmt(100000000)
        .accountPassword("1234")
        .AccountType(1)
        .issueDate(LocalDateTime.of(2024,3,2,10,15))
        .bankCode("103")
        .dayLimitAmt(100000000)
        .onceLimitAmt(50000000)
        .withdrawableAmt(100000000)
        .build();
    adult1.addAccount(account5);
    accountRepository.save(account5);
    authRepository.save(adult1);

    // 컨설턴트님 계정 1명(부모)
    AuthEntity adult2 = AuthEntity.builder()
        .userName("강시몬")
        .phoneNum("01098765432")
        .userCi("59204c6205dbe3a111b38c5199ae620303e7faa4e90f24ba8b95e9c550880683")
        .createdDtm(LocalDateTime.of(2024,3,2,10,10))
        .birthDate("19851005")
        .build();
    AccountEntity account6 = AccountEntity.builder()
        .accountNum("010398765432")
        .accountName("태평양통장")
        .balanceAmt(200000000)
        .accountPassword("1234")
        .AccountType(1)
        .issueDate(LocalDateTime.of(2024,3,2,10,15))
        .bankCode("103")
        .dayLimitAmt(100000000)
        .onceLimitAmt(50000000)
        .withdrawableAmt(100000000)
        .build();
    adult2.addAccount(account6);
    accountRepository.save(account6);
    authRepository.save(adult2);

    // 모임통장
    AccountEntity account10 = AccountEntity.builder()
        .accountNum("010319283746")
        .accountName("모임통장")
        .balanceAmt(900000)
        .accountPassword("1234")
        .AccountType(0) // 모임통장
        .issueDate(LocalDateTime.of(2024,3,2,10,15))
        .bankCode("103")
        .dayLimitAmt(10000000)
        .onceLimitAmt(5000000)
        .withdrawableAmt(10000000)
        .build();
    adult2.addAccount(account10);
    adult1.addAccount(account10);
    accountRepository.save(account10);

    // 코치님 계정 2명(자녀)
    AuthEntity child5 = AuthEntity.builder()
        .userName("권인식")
        .phoneNum("01001234567")
        .userCi("062d6727329650c97be50fa6344c175ca9a0dac693e41046567ae19877d62de1")
        .createdDtm(LocalDateTime.of(2024,3,2,10,10))
        .birthDate("20110430")
        .build();
    AccountEntity account7 = AccountEntity.builder()
        .accountNum("010301234567")
        .accountName("바다통장")
        .balanceAmt(900000)
        .accountPassword("1234")
        .AccountType(1)
        .issueDate(LocalDateTime.of(2024,3,2,10,15))
        .bankCode("103")
        .dayLimitAmt(5000000)
        .onceLimitAmt(1000000)
        .withdrawableAmt(5000000)
        .build();
    child5.addAccount(account7);
    accountRepository.save(account7);
    authRepository.save(child5);

    AuthEntity child6 = AuthEntity.builder()
        .userName("최영은")
        .phoneNum("01090123456")
        .userCi("c01ae01c25bd72169b1188f4231dff86e66c9eaf022eb96c5f5addf2e08d1836")
        .createdDtm(LocalDateTime.of(2024,3,2,10,10))
        .birthDate("20131015")
        .build();
    AccountEntity account8 = AccountEntity.builder()
        .accountNum("010390123456")
        .accountName("바다통장")
        .balanceAmt(900000)
        .accountPassword("1234")
        .AccountType(1)
        .issueDate(LocalDateTime.of(2024,3,2,10,15))
        .bankCode("103")
        .dayLimitAmt(5000000)
        .onceLimitAmt(1000000)
        .withdrawableAmt(5000000)
        .build();
    child6.addAccount(account8);
    accountRepository.save(account8);
    authRepository.save(child6);

    // 내부 테스트용
    AuthEntity child7 = AuthEntity.builder()
        .userName("홍주원")
        .phoneNum("01056789012")
        .userCi("746cfd2ce850575c6626dc1073850e521bf02274b663b8e4fb68371a251ed7f2")
        .createdDtm(LocalDateTime.of(2024,3,2,10,10))
        .birthDate("090423")
        .build();
    AccountEntity account9 = AccountEntity.builder()
        .accountNum("010356789012")
        .accountName("바다통장")
        .balanceAmt(900000)
        .accountPassword("1234")
        .AccountType(1)
        .issueDate(LocalDateTime.of(2024,3,2,10,15))
        .bankCode("103")
        .dayLimitAmt(5000000)
        .onceLimitAmt(1000000)
        .withdrawableAmt(5000000)
        .build();
    child7.addAccount(account9);
    accountRepository.save(account9);
    authRepository.save(child7);

  }

}
  */
