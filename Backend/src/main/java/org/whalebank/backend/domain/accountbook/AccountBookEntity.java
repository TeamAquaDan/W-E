package org.whalebank.backend.domain.accountbook;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.global.openfeign.card.response.CardHistoryResponse.CardHistoryDetail;

@Entity
@Getter
@Table(name="account_book")
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AccountBookEntity {

  @Id
  @GeneratedValue(strategy= GenerationType.IDENTITY)
  private int accountBookId; // 가계부 내역 아이디

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "user_id")
  private UserEntity user;

  private int transId; // 카드사 거래 고유번호

  private String accountBookTitle; // 카드사 가맹점명

  private int accountBookAmt; // 카드사 거래 금액

  private LocalDateTime accountBookDtm; // 카드사 거래일시

  private String accountBookCategory; // 거래 카테고리

  @ColumnDefault("0")
  private boolean isHide; // 거래내역 숨김 여부

  public static AccountBookEntity from(CardHistoryDetail cardHistoryDetail, UserEntity user) {
    return AccountBookEntity.builder()
        .transId(cardHistoryDetail.getTrans_id()) // 거래 고유번호
        .accountBookTitle(cardHistoryDetail.getMember_store_name()) // 가맹점명
        .accountBookAmt(cardHistoryDetail.getTrans_amt()) // 이용금액
        .accountBookDtm(cardHistoryDetail.getTransaction_dtm()) // 결제일시
        .accountBookCategory(convertCodetoCategory(cardHistoryDetail.getMember_store_type())) // 카테고리
        .user(user)
        .build();
  }

  private static String convertCodetoCategory(String code) {
    return switch (code.substring(0, 2)) {
      case "30", "31", "32" -> "003"; // 생활
      case "90", "91" -> "004"; // 주거/통신
      case "40", "42", "44" -> "006";
      case "71" -> "007";
      case "70", "84" -> "008";
      case "20", "21", "22" -> "009";
      case "50", "51", "52" -> "013";
      case "80", "81" -> "014";
      default -> "000";
    };
  }

}
