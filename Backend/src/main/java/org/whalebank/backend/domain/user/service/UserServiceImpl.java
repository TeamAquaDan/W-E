package org.whalebank.backend.domain.user.service;

import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.ObjectMetadata;
import jakarta.transaction.Transactional;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.whalebank.backend.domain.user.ProfileEntity;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.domain.user.dto.request.RegisterMainAccountRequestDto;
import org.whalebank.backend.domain.user.dto.request.VerifyRequestDto;
import org.whalebank.backend.domain.user.dto.response.ProfileImageResponseDto;
import org.whalebank.backend.domain.user.dto.response.ProfileResponseDto;
import org.whalebank.backend.domain.user.dto.response.VerifyResponseDto;
import org.whalebank.backend.domain.user.repository.AuthRepository;
import org.whalebank.backend.domain.user.repository.ProfileRepository;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.response.ResponseCode;

@RequiredArgsConstructor
@Service
public class UserServiceImpl implements UserService {

  private final AuthRepository repository;
  private final ProfileRepository profileRepository;
  private final AmazonS3Client amazonS3Client;

  @Value("${cloud.aws.s3.bucket}")
  private String bucket;

  @Override
  @Transactional
  public ProfileImageResponseDto updateProfileImage(String loginId, MultipartFile file) {

    String originalName = file.getOriginalFilename();

    // 현재 로그인한 사용자
    UserEntity user = repository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    // 현재 로그인한 사용자의 프로필
    ProfileEntity profileImage = profileRepository.findById(String.valueOf(user.getUserId())).get();

    // 저장할 이름
    String filename = profileImage.getFileName(originalName);

    System.out.println(filename);

    try {

      ObjectMetadata objectMetadata = new ObjectMetadata();
      objectMetadata.setContentLength(file.getSize());
      objectMetadata.setContentType(file.getContentType());

      // 버켓에 저장
      amazonS3Client.putObject(bucket, filename, file.getInputStream(), objectMetadata);

      String accessUrl = amazonS3Client.getUrl(bucket, filename).toString();

      profileImage.setProfileImage(accessUrl);

      profileRepository.save(profileImage);

    } catch (Exception e) {
      throw new CustomException(ResponseCode.BAD_REQUEST);
    }

    return ProfileImageResponseDto
        .builder()
        .profile_img(profileImage.getProfileImage())
        .build();
  }

  @Override
  @Transactional
  public void updateSentence(String loginId, String sentence) {
    UserEntity user = repository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    user.updateSentence(sentence);
  }


  public ProfileResponseDto getProfile(int userId, String loginId) {
    boolean editable = true;
    // 현재 로그인한 사용자
    UserEntity user = repository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    if (user.getUserId() != userId) {
      // 친구 프로필 조회
      user = repository.findById(userId)
          .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));
      editable = false;
    }

    return ProfileResponseDto.of(user, editable);
  }

  public VerifyResponseDto verifyUser(VerifyRequestDto reqDto) {
    UserEntity user = repository.findByPhoneNumAndUserName(reqDto.getPhone_num(),
            reqDto.getUsername())
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    return VerifyResponseDto.of(user.getUserId(), user.getUserName());
  }

  @Override
  @Transactional
  public void updateMainAccount(String loginId, RegisterMainAccountRequestDto reqDto) {
    UserEntity user = repository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    user.updateMainAccount(reqDto.getAccount_id(), reqDto.getAccount_num());
  }
}
