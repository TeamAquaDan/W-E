package org.whalebank.backend.domain.user.security;

import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import io.jsonwebtoken.security.SignatureException;
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
import org.whalebank.backend.domain.user.dto.response.ReissueResponseDto;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.response.ResponseCode;

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
    Date now = new Date();
    Date expiration = new Date(now.getTime() + accessTokenExpirationDate);

    return Jwts.builder()
        .subject(loginId)
        .issuedAt(now)
        .expiration(expiration)
        .signWith(key())
        .compact();
  }

  public String generateRefreshToken(String loginId) {
    Date now = new Date();
    Date expiration = new Date(now.getTime() + refreshTokenExpirationDate);

    return Jwts.builder()
        .subject(loginId)
        .issuedAt(now)
        .expiration(expiration)
        .signWith(key())
        .compact();
  }

  // get loginId from Jwt token
  public String getLoginId(String token) {
    try {
      return Jwts.parser()
          .verifyWith((SecretKey) key())
          .build()
          .parseSignedClaims(token)
          .getPayload()
          .getSubject();
    } catch (SignatureException e) {
      throw new org.whalebank.backend.global.exception.JwtException(ResponseCode.JWT_SIGNATURE.getMessage());
    } catch (MalformedJwtException e) {
      throw new org.whalebank.backend.global.exception.JwtException(ResponseCode.JWT_MALFORMED.getMessage());
    } catch (ExpiredJwtException e) {
      throw new org.whalebank.backend.global.exception.JwtException(ResponseCode.JWT_EXPIRED.getMessage());
    } catch (IllegalArgumentException e) {
      throw new org.whalebank.backend.global.exception.JwtException(ResponseCode.JWT_ILLEGALARGUMENT.getMessage());
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
    LoginResponseDto resDto = LoginResponseDto.of(
        generateRefreshToken(user.getLoginId()),
        generateAccessToken(user.getLoginId()),
        user);

    redisTemplate.opsForValue()
        .set("RT:" + user.getLoginId(), resDto.getRefresh_token(), refreshTokenExpirationDate,
            TimeUnit.MILLISECONDS);

    return resDto;
  }

  public ReissueResponseDto reissueToken(String loginId, String refreshToken) {
    // redis에서 login id를 기반으로 저장된 refresh token 값 가져옴
    if (!refreshToken.equals((String) redisTemplate.opsForValue().get("RT:" + loginId))) {
      throw new CustomException(ResponseCode.DIFFERENT_REFRESH_TOKEN);
    }

    // 토큰 재생성
    refreshToken = generateRefreshToken(loginId);
    String accessToken = generateAccessToken(loginId);

    // redis 업데이트
    redisTemplate.opsForValue().set("RT:"+loginId, refreshToken, refreshTokenExpirationDate,
        TimeUnit.MILLISECONDS);

    return new ReissueResponseDto(accessToken, refreshToken);
  }

}
