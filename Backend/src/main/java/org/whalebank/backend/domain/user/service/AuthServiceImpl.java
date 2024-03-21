package org.whalebank.backend.domain.user.service;

import jakarta.transaction.Transactional;
import java.time.LocalDate;
import java.time.Period;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.user.Role;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.domain.user.dto.request.LoginRequestDto;
import org.whalebank.backend.domain.user.dto.request.SignUpRequestDto;
import org.whalebank.backend.domain.user.dto.response.LoginResponseDto;
import org.whalebank.backend.domain.user.dto.response.ReissueResponseDto;
import org.whalebank.backend.domain.user.repository.AuthRepository;
import org.whalebank.backend.domain.user.security.JwtService;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.openfeign.bank.BankAccessUtil;
import org.whalebank.backend.global.openfeign.bank.response.AccessTokenResponseDto;
import org.whalebank.backend.global.response.ResponseCode;
import org.whalebank.backend.global.utils.EncryptionUtils;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuthServiceImpl implements AuthService {

  private final AuthRepository repository;
  private final BCryptPasswordEncoder encoder;
  private final JwtService jwtService;
  private final BankAccessUtil bankAccessUtil;

  @Transactional
  public void signUp(SignUpRequestDto dto) {
    String userCI = createCI(dto.getBirthDate(), dto.getPersonal_num());
    log.info("userCI: "+userCI);
    // 은행 db에 있는 회원인지?
    String phoneNumber = bankAccessUtil.getUserInfo(userCI);

    // 20세 이하면 자녀, 20세 이상이면 부모
    Role role = null;
    String birthDate = convertToEightDigits(dto.getBirthDate());
    if(calculateAge(birthDate)<=20) {
      role = Role.CHILD;
    } else {
      role = Role.ADULT;
    }
    // 유저 엔티티 생성
    UserEntity entity = dto.of(encoder.encode(dto.getPassword()), userCI, role, birthDate, phoneNumber);
    repository.save(entity);
  }

  @Override
  @Transactional
  public LoginResponseDto login(LoginRequestDto dto) {
    UserEntity user = repository.findByLoginId(dto.getLogin_id())
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    if (!encoder.matches(dto.getPassword(), user.getLoginPassword())) {
      throw new CustomException(ResponseCode.USER_NOT_FOUND);
    }

    if(user.getCardAccessToken()==null || user.getBankAccessToken()==null) {
      AccessTokenResponseDto responseDto = bankAccessUtil.generateToken(user.getUserCi());
      user.updateBankAccessToken(responseDto.getAccess_token());
      // TODO: 카드사 접근토큰 저장
    }
    user.updateFcmToken(dto.getFcm_token()); // fcm 토큰 저장

    return jwtService.generateToken(user);
  }

  @Override
  public ReissueResponseDto reissue(String refreshToken) {

    if(!jwtService.validateToken(refreshToken)) {
      throw new CustomException(ResponseCode.INVALID_REFRESH_TOKEN);
    }
    String loginId = jwtService.getLoginId(refreshToken); // 리프레시 토큰에서 유저 아이디 가져옴

    UserEntity user = repository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    return jwtService.reissueToken(user, refreshToken);
  }

  /**
   * @param birthDate 주민등록번호 앞 6자리
   * @param rrNumber  주민등록번호 뒤 7자리
   * @return ci값
   */
  public String createCI(String birthDate, String rrNumber) {
    return EncryptionUtils.encryptSHA256(birthDate+rrNumber);
  }

  public static String convertToEightDigits(String sixDigitDate) {
    if (sixDigitDate.length() != 6) {
      throw new CustomException(ResponseCode.INVALID_BIRTHDATE);
    }

    String yearPrefix = (Integer.parseInt(sixDigitDate.substring(0, 2)) < 24) ? "20" : "19";
    return yearPrefix + sixDigitDate;
  }

  public static int calculateAge(String birthDateStr) {

    // 생년월일 문자열을 LocalDate로 변환
    LocalDate birthDate = LocalDate.of(Integer.parseInt(birthDateStr.substring(0, 4)),
        Integer.parseInt(birthDateStr.substring(4, 6)),
        Integer.parseInt(birthDateStr.substring(6)));

    // 나이를 계산
    Period period = Period.between(birthDate, LocalDate.now());

    // 계산된 나이에서 년수만 추출하여 반환
    return period.getYears();
  }

}
