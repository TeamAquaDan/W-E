package org.whalebank.whalebank.domain.auth.security;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import jakarta.servlet.http.HttpServletRequest;

import java.util.Date;
import java.util.Map;
import java.util.Optional;
import javax.crypto.SecretKey;

import lombok.extern.slf4j.Slf4j;
import io.jsonwebtoken.Claims;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.whalebank.whalebank.domain.auth.AuthEntity;
import org.whalebank.whalebank.domain.auth.dto.request.ReissueRequest;
import org.whalebank.whalebank.domain.auth.dto.response.ReissueResponse;
import org.whalebank.whalebank.domain.auth.dto.response.TokenResponse;
import org.whalebank.whalebank.domain.auth.repository.AuthRepository;


@Slf4j
@Component
public class TokenProvider {

  @Value("${spring.jwt.secret}")
  private String jwtSecret;

  @Value("${spring.jwt.accessTokenExperation}")
  private long accessTokenExpirationDate;

  @Value("${spring.jwt.refreshTokenExperation}")
  private long refreshTokenExpirationDate;

  @Autowired
  private AuthRepository authRepository;

  // 키 생성
  private SecretKey createKey() {
    return Keys.hmacShaKeyFor(Decoders.BASE64.decode(jwtSecret));
  }

  // JWT 토큰 생성
  public String createToken(int userId, Long expireDate) {

    Date now = new Date();

    return Jwts.builder()
        .setHeader(Map.of("typ", "JWT"))
        .subject(String.valueOf(userId))
        .issuedAt(now)
        .expiration(new Date(now.getTime() + expireDate))
        .signWith(createKey())
        .compact();
  }

  public Claims getUserId(String accessToken) {
    return Jwts.parser()
        .verifyWith(createKey())
        .build()
        .parseSignedClaims(accessToken)
        .getPayload();
  }

  // validate Jwt Token
  public boolean validateToken(String token) {
    try {
      Jwts.parser()
          .verifyWith(createKey())
          .build()
          .parse(token);
      return true;
    } catch (Exception e) {
      return false;
    }
  }

  public TokenResponse generateToken(HttpServletRequest request) {

    String userCi = request.getHeader("x-user-ci");
    Optional<AuthEntity> auth = authRepository.findByUserCi(userCi);

    if (auth.isPresent()) {

      AuthEntity user = auth.get();

      String accessToken = createToken(auth.get().getUserId(), refreshTokenExpirationDate);
      String refreshToken = createRefreshToken(request);

      user.setRefreshToken(refreshToken);
      authRepository.save(user);

      return TokenResponse.builder()
          .token_type("Bearer")
          .access_token(accessToken)
          .refresh_token(refreshToken)
          .build();
    } else {
      throw new IllegalArgumentException("사용자가 없습니다.");
    }
  }

  public String createRefreshToken(HttpServletRequest request) {
    String userCi = request.getHeader("x-user-ci");
    Optional<AuthEntity> auth = authRepository.findByUserCi(userCi);

    if (auth != null) {
      return createToken(auth.get().getUserId(), refreshTokenExpirationDate);
    } else {
      throw new IllegalArgumentException("사용자가 없습니다.");
    }
  }


  public ReissueResponse reissueAccessToken(ReissueRequest reissueRequest) {
    String refreshToken = reissueRequest.getRefresh_token();

    try {
      if (validateToken(refreshToken)) {
        String userId = getUserId(refreshToken).get("sub", String.class);

        AuthEntity auth = authRepository.findById(userId)
            .orElseThrow(() -> new IllegalArgumentException("사용자가 없습니다."));
        if (refreshToken.equals(auth.getRefreshToken())) {
          return ReissueResponse
              .builder()
              .token_type("Bearer")
              .access_token(createToken(Integer.parseInt(userId), accessTokenExpirationDate))
              .build();
        }

        throw new IllegalArgumentException("토큰 값이 다릅니다.");
      }
    } catch (Exception e) {
      //
    }

    return null;
  }
}
