package org.whalebank.backend.domain.notification.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.notification.FCMCategory;

@Getter
@Setter
@Builder
public class FCMRequestDto {

  public String title;
  public String content;
  public String category;

  public static FCMRequestDto of(String title, String content, FCMCategory category) {
    return FCMRequestDto.builder()
        .title(title)
        .content(content)
        .category(category.code)
        .build();
  }

}
