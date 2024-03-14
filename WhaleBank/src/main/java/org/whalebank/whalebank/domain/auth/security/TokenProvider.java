package org.whalebank.whalebank.domain.auth.security;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import jakarta.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.Map;
import javax.crypto.SecretKey;
import lombok.extern.slf4j.Slf4j;
import io.jsonwebtoken.Claims;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.whalebank.whalebank.domain.auth.AuthEntity;
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

  private SecretKey accessKey;
  private SecretKey refreshKey;

  @Autowired
  private AuthRepository authRepository;

  public SecretKey getAccessKey() {
    if (accessKey == null) {
      accessKey = createKey();
    }
    return accessKey;
  }

  public SecretKey getRefreshKey() {
    if (refreshKey == null) {
      refreshKey = createKey();
    }
    return refreshKey;
  }

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

//  public TokenResponse createRefreshToken(HttpServletRequest request) {
//    // 헤더에서 Ci 값을 가져옵니다.
//    String userCi = request.getHeader("Ci");
//
//    // 데이터베이스에서 해당 Ci 값을 가진 사용자를 찾습니다.
//    User user = userRepository.findByCi(userCi);
//
//    // 사용자가 존재하는지 확인합니다.
//    if (user != null) {
//      // 사용자가 존재하면 리프레시 토큰을 갱신합니다.
//      String refreshToken = generateRefreshToken(user);
//      return new TokenResponse(refreshToken);
//    } else {
//      // 사용자가 존재하지 않으면 새로운 리프레시 토큰을 생성합니다.
//      User newUser = new User(userCi);
//      userRepository.save(newUser);
//      String refreshToken = generateRefreshToken(newUser);
//      return new TokenResponse(refreshToken);
//    }
//  }

  public TokenResponse createRefreshToken(HttpServletRequest request) {
    String userCi = request.getHeader("x-user-ci");
    AuthEntity auth = authRepository.findByCi(userCi);

    if (auth != null) {
      return TokenResponse
          .builder()
          .refresh_token(createToken(auth.getUserId(), refreshTokenExpirationDate))
          .build();
    } else {
      throw new IllegalArgumentException("사용자가 없습니다.");
    }

  }

//  public ReissueResponse reissueAccessToken(HttpServletRequest request) {
//    String refreshToken = getTokenFromRequest(request);
//    try {
//      if (validateToken(refreshToken)) {
//        String userId = String.valueOf(getUserId(refreshToken));
//        AuthEntity auth = authRepository.findById(userId)
//            .orElseThrow(() -> new IllegalArgumentException("사용자가 없습니다."));
//        if (refreshToken.equals(auth.getRefreshToken())) {
//          // re-issue access token
//          return ReissueResponse
//              .builder()
//              .access_token(createToken(Integer.parseInt(userId), accessTokenExpirationDate))
//              .build();
//        } else {
//          throw new IllegalArgumentException("");
//        }
//      }
//    } catch (Exception e) {
//      //
//    }
//    return null;
//  }

}
