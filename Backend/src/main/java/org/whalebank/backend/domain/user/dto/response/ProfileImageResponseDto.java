package org.whalebank.backend.domain.user.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@Builder
public class ProfileImageResponseDto {

  private String profile_img;
}
