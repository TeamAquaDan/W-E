package org.whalebank.backend.domain.user.dto.response;

import java.time.format.DateTimeFormatter;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.user.UserEntity;

@Getter
@Setter
@Builder
public class ProfileResponseDto {

  public int user_id;
  public String login_id;
  public String username;
  public String profile_img;
  public String birthdate;
  public boolean editable; // 본인 프로필일 경우 editable: true

  public static ProfileResponseDto of(UserEntity user, boolean editable) {
    return ProfileResponseDto.builder()
        .user_id(user.getUserId())
        .login_id(user.getLoginId())
        .username(user.getUserName())
        .profile_img(user.getProfileImage())
        .birthdate(user.getBirthDate().format(DateTimeFormatter.ofPattern("yyyy.MM.dd")))
        .editable(editable)
        .build();
  }

}
