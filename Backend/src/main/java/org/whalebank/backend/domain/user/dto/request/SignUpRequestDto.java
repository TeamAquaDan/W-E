package org.whalebank.backend.domain.user.dto.request;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.user.Role;
import org.whalebank.backend.domain.user.UserEntity;

@Getter
@Setter
public class SignUpRequestDto {

  String login_id;
  String password;
  String username;
  String birthdate;
  String personal_num;

  public UserEntity of(String encryptedPassword, String userCI, Role role, String BirthDate, String phoneNumber) {
    // create a formatter
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");

    return UserEntity.builder()
        .userName(this.username)
        .birthDate(LocalDate.parse(BirthDate, formatter))
        .userCi(userCI)
        .loginId(this.login_id)
        .loginPassword(encryptedPassword)
        .role(role)
        .isDeleted(false)
        .phoneNum(phoneNumber)
        .lastCardHistoryFetchTime(LocalDateTime.of(2000,1,1,0,0))
        .build();
  }
}
