package org.whalebank.backend.domain.user.security;

import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import jakarta.servlet.http.HttpServletRequest;
import java.security.Key;
import java.util.Date;
import java.util.concurrent.TimeUnit;
import javax.crypto.SecretKey;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.domain.user.dto.response.LoginResponseDto;

@Component
@RequiredArgsConstructor
public class JwtService {

  @Value("${spring.jwt.secret}")
  private String SECRET_KEY;

  @Value("${spring.jwt.refreshTokenExpiration}")
  private long refreshTokenExpirationDate;

  @Value("${spring.jwt.accessTokenExpiration}")
  private long accessTokenExpirationDate;

  private final RedisTemplate<String, Object> redisTemplate;

  private Key key() {
    return Keys.hmacShaKeyFor(Decoders.BASE64.decode(SECRET_KEY));
  }

  public String generateAccessToken(String loginId) {
    Date currentDate = new Date();

    return Jwts.builder()
        .subject(loginId)
        .issuedAt(new Date())
        .expiration(new Date(currentDate.getTime() + accessTokenExpirationDate))
        .signWith(key())
        .compact();
  }

  public String generateRefreshToken(String loginId) {
    Date currentDate = new Date();

    return Jwts.builder()
        .subject(loginId)
        .issuedAt(new Date())
        .expiration(new Date(currentDate.getTime() + refreshTokenExpirationDate))
        .signWith(key())
        .compact();
  }

  // get loginId from Jwt token
  public String getLoginId(String token) {
    return Jwts.parser()
        .verifyWith((SecretKey) key())
        .build()
        .parseSignedClaims(token)
        .getPayload()
        .getSubject();
  }

  public boolean validateToken(String token) {
    try {
      Jwts.parser()
          .verifyWith((SecretKey) key())
          .build()
          .parse(token);
      return true;
    } catch (ExpiredJwtException exception) {
      return false;
    } catch (JwtException exception) {
      return false;
    }
  }

  public String getTokenFromRequest(HttpServletRequest request) {
    String bearerToken = request.getHeader("Authorization");

    if(StringUtils.hasText(bearerToken) && bearerToken.startsWith("Bearer ")) {
      return bearerToken.substring(7);
    }

    return null;
  }

  public LoginResponseDto generateToken(UserEntity user) {
    LoginResponseDto resDto = LoginResponseDto.of(generateAccessToken(user.getLoginId()),
        generateRefreshToken(user.getLoginId()), user);

    redisTemplate.opsForValue().set("RT:"+user.getLoginId(), resDto.getRefresh_token(), refreshTokenExpirationDate,
        TimeUnit.MILLISECONDS);

    return resDto;
  }



}
