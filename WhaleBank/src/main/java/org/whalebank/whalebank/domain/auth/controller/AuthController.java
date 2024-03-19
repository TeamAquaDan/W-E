package org.whalebank.whalebank.domain.auth.controller;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.whalebank.whalebank.domain.auth.dto.request.AuthRequest;
import org.whalebank.whalebank.domain.auth.dto.request.ReissueRequest;
import org.whalebank.whalebank.domain.auth.dto.response.AuthResponse;
import org.whalebank.whalebank.domain.auth.dto.response.ReissueResponse;
import org.whalebank.whalebank.domain.auth.dto.response.TokenResponse;
import org.whalebank.whalebank.domain.auth.security.TokenProvider;
import org.whalebank.whalebank.domain.auth.service.AuthService;

@RestController
@RequestMapping("/whale/bank/oauth/2.0")
@RequiredArgsConstructor
public class AuthController {

  private final TokenProvider tokenProvider;
  private final AuthService authService;

  @PostMapping("/authorize")
  public ResponseEntity<AuthResponse> getAuth(
      @RequestBody AuthRequest authRequest) {
    return new ResponseEntity<>(authService.getPhonenum(authRequest.getUser_ci()), HttpStatus.OK);
  }

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
