package org.whalebank.backend.domain.user;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.whalebank.backend.domain.user.dto.request.GuestBookRequestDto;

@Entity
@Table(name = "guestbook")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GuestBookEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private int guestbookId;

  private int writerId;

  private String content;

  private LocalDateTime guestbookDtm;

  @ManyToOne
  @JoinColumn(name = "user_id")
  private ProfileEntity profile;

  public static GuestBookEntity createGuestBook(ProfileEntity profile, UserEntity writer,
      GuestBookRequestDto request) {
    return GuestBookEntity
        .builder()
        .writerId(writer.getUserId())
        .content(request.getContent())
        .guestbookDtm(LocalDateTime.now())
        .profile(profile)

        .build();

  }
}
