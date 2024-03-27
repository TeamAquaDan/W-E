package org.whalebank.backend.domain.notification.service;

import java.util.List;
import org.whalebank.backend.domain.notification.dto.response.NotiResponseDto;

public interface NotiService {

  public List<NotiResponseDto> getAllNotification(String loginId);

}
