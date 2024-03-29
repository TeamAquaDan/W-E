package org.whalebank.backend.domain.user.dto.response;

import java.time.format.DateTimeFormatter;
import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.user.GuestBookEntity;
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
  public String sentence; // 한줄소개
  public boolean editable; // 본인 프로필일 경우 editable: true


  public List<GuestBook> guestBook_list;

  @Getter
  @Setter
  @Builder
  public static class GuestBook {

    private int guestbook_id;
    private String writer_profile_img;  // 작성자 프로필 이미지
    private String writer_name; // 작성자 이름
    private String content;   // 방명록 내용
  }


  public static ProfileResponseDto of(UserEntity user, boolean editable, List<GuestBook> guestBookList) {
    return ProfileResponseDto.builder()
        .user_id(user.getUserId())
        .login_id(user.getLoginId())
        .username(user.getUserName())
        .profile_img(user.getProfile().getProfileImage())
        .birthdate(user.getBirthDate().format(DateTimeFormatter.ofPattern("yyyy.MM.dd")))
        .sentence(user.getProfile().getSentence())
        .editable(editable)
        .guestBook_list(guestBookList)
        .build();
  }

}
