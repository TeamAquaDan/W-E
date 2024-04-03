package org.whalecard.whalecard.domain.auth.controller;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.whalecard.whalecard.domain.auth.dto.request.ReissueRequest;
import org.whalecard.whalecard.domain.auth.dto.response.ReissueResponse;
import org.whalecard.whalecard.domain.auth.dto.response.TokenResponse;
import org.whalecard.whalecard.domain.auth.security.TokenProvider;

@RestController
@RequestMapping("/whale/card/oauth/2.0")
@RequiredArgsConstructor
public class AuthController {

  private final TokenProvider tokenProvider;

  @PostMapping("/token")
  public ResponseEntity<TokenResponse> getRefreshToken(HttpServletRequest request) {
    return new ResponseEntity<>(tokenProvider.generateToken(request), HttpStatus.OK);
  }

  @PostMapping("/reissue")
  public ResponseEntity<? extends ReissueResponse> getAccessToken(
      @RequestBody ReissueRequest reissueRequest) {
    return new ResponseEntity<>(tokenProvider.reissueAccessToken(reissueRequest), HttpStatus.OK);
  }
}
