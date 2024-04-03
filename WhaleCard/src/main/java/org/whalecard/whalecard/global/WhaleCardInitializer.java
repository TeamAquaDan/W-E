package org.whalecard.whalecard.global;

import jakarta.annotation.PostConstruct;
import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.whalecard.whalecard.domain.auth.AuthEntity;
import org.whalecard.whalecard.domain.auth.repository.AuthRepository;
import org.whalecard.whalecard.domain.card.CardEntity;
import org.whalecard.whalecard.domain.card.repository.CardRepository;

@Component
@RequiredArgsConstructor
public class WhaleCardInitializer {

  private final CardRepository cardRepository;
  private final AuthRepository authRepository;

  @PostConstruct
  public void init() {
    // 사용자, 카드
    // 시연 참가자 5명
    AuthEntity child1 = AuthEntity.builder()
        .userName("김싸피")
        .phoneNum("01012345678")
        .userCi("f985dbe0e10a53a0bd84b183cc6b2d76bbd1f96168440b427fc6b56530121ba3")
        .createdDtm(LocalDateTime.of(2024,3,2,10,10))
        .birthDate("20100101")
        .build();
    CardEntity card1 = CardEntity.builder()
        .cardNo("010311111111")
        .cardName("바다카드")
        .accountNum("010312345678")
        .cardPassword("0000")
        .issueDate(LocalDate.of(2024,3,2))
        .build();
    cardRepository.save(card1);
    child1.addCard(card1);
    authRepository.save(child1);
    CardEntity card2 = CardEntity.builder()
        .cardNo("010311111112")
        .cardName("호수카드")
        .accountNum("010313579135")
        .cardPassword("0001")
        .issueDate(LocalDate.of(2024,3,2))
        .build();
    cardRepository.save(card2);
    child1.addCard(card2);
    authRepository.save(child1);


    AuthEntity child2 = AuthEntity.builder()
        .userName("김지원")
        .phoneNum("01023456789")
        .userCi("ebefc4c695fa31a0293d05ffb10e74c3f94bdd254cea4f2ab7525bcedb0e0bc9")
        .createdDtm(LocalDateTime.of(2024,3,2,10,10))
        .birthDate("20100101")
        .build();
    CardEntity card3 = CardEntity.builder()
        .cardNo("010311111113")
        .cardName("바다카드")
        .accountNum("010323456789")
        .cardPassword("0011")
        .issueDate(LocalDate.of(2024,3,2))
        .build();
    cardRepository.save(card3);
    child2.addCard(card3);
    authRepository.save(child2);


    AuthEntity child3 = AuthEntity.builder()
        .userName("김지우")
        .phoneNum("01034567890")
        .userCi("9a53ef0553ffe0d8269f400113a775a3d9626398ab8b5579ff6e431d30034476")
        .createdDtm(LocalDateTime.of(2024,3,2,10,10))
        .birthDate("20120206")
        .build();
    CardEntity card4 = CardEntity.builder()
        .cardNo("010311111114")
        .cardName("바다카드")
        .accountNum("010334567890")
        .cardPassword("0100")
        .issueDate(LocalDate.of(2024,3,2))
        .build();
    cardRepository.save(card4);
    child3.addCard(card4);
    authRepository.save(child3);

    AuthEntity child4 = AuthEntity.builder()
        .userName("박서연")
        .phoneNum("01045678901")
        .userCi("4b19571325faa281fa9201ad1f8bf7d0878c668cdea3bc67dc4c38718d5d4049")
        .createdDtm(LocalDateTime.of(2024,3,2,10,10))
        .birthDate("20120313")
        .build();
    CardEntity card5 = CardEntity.builder()
        .cardNo("010311111115")
        .cardName("바다카드")
        .accountNum("010345678901")
        .cardPassword("0101")
        .issueDate(LocalDate.of(2024,3,2))
        .build();
    cardRepository.save(card5);
    child4.addCard(card5);
    authRepository.save(child4);

    AuthEntity adult1 = AuthEntity.builder()
        .userName("김지훈")
        .phoneNum("01087654321")
        .userCi("52f62e5ba77f964f32d932fe5f0a26655123f998fef9641b15fc71980d9bf6de")
        .createdDtm(LocalDateTime.of(2024,3,2,10,10))
        .birthDate("19851005")
        .build();
    CardEntity card6 = CardEntity.builder()
        .cardNo("010311111117")
        .cardName("태평양카드")
        .accountNum("010387654321")
        .cardPassword("0111")
        .issueDate(LocalDate.of(2024,3,2))
        .build();
    cardRepository.save(card6);
    adult1.addCard(card6);

    // 컨설턴트님 계정 1명(부모)
    AuthEntity adult2 = AuthEntity.builder()
        .userName("강시몬")
        .phoneNum("01098765432")
        .userCi("59204c6205dbe3a111b38c5199ae620303e7faa4e90f24ba8b95e9c550880683")
        .createdDtm(LocalDateTime.of(2024,3,2,10,10))
        .birthDate("19851005")
        .build();
    CardEntity card7 = CardEntity.builder()
        .cardNo("010311111118")
        .cardName("태평양카드")
        .accountNum("010398765432")
        .cardPassword("1000")
        .issueDate(LocalDate.of(2024,3,2))
        .build();
    cardRepository.save(card7);
    adult2.addCard(card7);

    // 모임 통장 카드
    CardEntity card11 = CardEntity.builder()
        .cardNo("010311111119")
        .cardName("태평양카드")
        .accountNum("010319283746")
        .cardPassword("1001")
        .issueDate(LocalDate.of(2024,3,2))
        .build();
    cardRepository.save(card11);
    adult1.addCard(card11);
    adult2.addCard(card11);

    authRepository.save(adult1);
    authRepository.save(adult2);


    // 코치님 계정 2명(자녀)
    AuthEntity child5 = AuthEntity.builder()
        .userName("권인식")
        .phoneNum("01001234567")
        .userCi("062d6727329650c97be50fa6344c175ca9a0dac693e41046567ae19877d62de1")
        .createdDtm(LocalDateTime.of(2024,3,2,10,10))
        .birthDate("20110430")
        .build();
    CardEntity card8 = CardEntity.builder()
        .cardNo("010311111116")
        .cardName("바다카드")
        .accountNum("010301234567")
        .cardPassword("0110")
        .issueDate(LocalDate.of(2024,3,2))
        .build();
    cardRepository.save(card8);
    child5.addCard(card8);
    authRepository.save(child5);

    AuthEntity child6 = AuthEntity.builder()
        .userName("최영은")
        .phoneNum("01090123456")
        .userCi("c01ae01c25bd72169b1188f4231dff86e66c9eaf022eb96c5f5addf2e08d1836")
        .createdDtm(LocalDateTime.of(2024,3,2,10,10))
        .birthDate("20131015")
        .build();
    CardEntity card9 = CardEntity.builder()
        .cardNo("010311111124")
        .cardName("바다카드")
        .accountNum("010390123456")
        .cardPassword("1101")
        .issueDate(LocalDate.of(2024,3,2))
        .build();
    cardRepository.save(card9);
    child6.addCard(card9);
    authRepository.save(child6);

    // 내부 테스트용
    AuthEntity child7 = AuthEntity.builder()
        .userName("홍주원")
        .phoneNum("01056789012")
        .userCi("746cfd2ce850575c6626dc1073850e521bf02274b663b8e4fb68371a251ed7f2")
        .createdDtm(LocalDateTime.of(2024,3,2,10,10))
        .birthDate("20090423")
        .build();
    CardEntity card10 = CardEntity.builder()
        .cardNo("010311111120")
        .cardName("바다카드")
        .accountNum("010356789012")
        .cardPassword("1010")
        .issueDate(LocalDate.of(2024,3,2))
        .build();
    cardRepository.save(card10);
    child7.addCard(card10);
    authRepository.save(child7);

  }

}
