package org.whalebank.backend.domain.user;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.MapsId;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "profile")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProfileEntity {

  @Id
  @Column(name = "user_id", nullable = false)
  private int userId;

  @OneToOne
  @MapsId
  @JoinColumn(name = "user_id")
  private UserEntity user;

  private String profileImage;

  private String sentence;

  private String originName;

  private String storedName;

  // 이미지 파일의 확장자를 추출하는 메소드
  public String extractExtension(String originName) {
    int index = originName.lastIndexOf('.');

    return originName.substring(index);
  }

  // 이미지 파일의 이름을 저장하기 위한 이름으로 변환하는 메소드
  public String getFileName(String originName) {
    return UUID.randomUUID() + extractExtension(originName);
  }

}
