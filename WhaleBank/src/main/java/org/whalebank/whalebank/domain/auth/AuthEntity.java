package org.whalebank.whalebank.domain.auth;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.antlr.v4.runtime.misc.NotNull;

@Entity
@Table(name = "user")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Builder
public class AuthEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private int userId;

  private String userName;

  private String phoneNum;

  private String birthDate;

  private LocalDateTime createdDtm;

  private String userCi;
}
