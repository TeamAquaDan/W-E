package org.whalebank.whalebank.global.bank;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "code")
public class CodeEntity {

  @Id
  private String bankCodeStd; // 기관 표준코드
  private String bankName;  // 기관명

}
