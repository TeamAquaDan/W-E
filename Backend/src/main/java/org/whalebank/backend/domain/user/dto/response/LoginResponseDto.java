package org.whalebank.backend.domain.user.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.user.UserEntity;

@Getter
@Setter
@Builder
public class LoginResponseDto {

  public String refresh_token;
  public String access_token;
  public int user_id;
  public String profile_img;
  public String username;
  public String role;

  public static LoginResponseDto of(String refresh_token, String access_token, UserEntity user) {
    return LoginResponseDto.builder()
        .refresh_token(refresh_token)
        .access_token(access_token)
        .user_id(user.getUserId())
        .profile_img(user.getProfileImage())
        .username(user.getUserName())
        .role(user.getRole().toString())
        .build();
  }

}
