package org.whalebank.backend.domain.user.service;

import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.ObjectMetadata;
import jakarta.transaction.Transactional;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.apache.catalina.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.whalebank.backend.domain.friend.FriendEntity;
import org.whalebank.backend.domain.friend.FriendId;
import org.whalebank.backend.domain.friend.repository.FriendRepository;
import org.whalebank.backend.domain.user.GuestBookEntity;
import org.whalebank.backend.domain.user.ProfileEntity;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.domain.user.dto.request.GuestBookRequestDto;
import org.whalebank.backend.domain.user.dto.request.RegisterMainAccountRequestDto;
import org.whalebank.backend.domain.user.dto.request.VerifyRequestDto;
import org.whalebank.backend.domain.user.dto.response.ProfileImageResponseDto;
import org.whalebank.backend.domain.user.dto.response.ProfileResponseDto;
import org.whalebank.backend.domain.user.dto.response.ProfileResponseDto.GuestBook;
import org.whalebank.backend.domain.user.dto.response.VerifyResponseDto;
import org.whalebank.backend.domain.user.repository.AuthRepository;
import org.whalebank.backend.domain.user.repository.GuestBookRepository;
import org.whalebank.backend.domain.user.repository.ProfileRepository;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.response.ResponseCode;

@RequiredArgsConstructor
@Service
public class UserServiceImpl implements UserService {

  private final AuthRepository repository;
  private final ProfileRepository profileRepository;
  private final AmazonS3Client amazonS3Client;
  private final FriendRepository friendRepository;
  private final GuestBookRepository guestBookRepository;

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

  @Override
  @Transactional
  public void createGuestBook(String loginId, GuestBookRequestDto request) {

    // 작성자
    UserEntity writer = repository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    // 작성 대상 프로필 사용자
    UserEntity profileUser = repository.findById(request.getUser_id())
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    // 본인 프로필에는 작성 불가능
    if (writer == profileUser) {
      throw new CustomException(ResponseCode.SAME_USER);
    }

    // 작성자와 프로필 유저가 서로 친구가 아니면 작성 불가능
    FriendEntity friend = friendRepository.findById(new FriendId(writer, profileUser))
        .orElseThrow(() -> new CustomException(ResponseCode.FRIEND_NOT_FOUND));

    // 작성자 프로필 엔티티 불러오기
    ProfileEntity profile = profileRepository.findById(String.valueOf(profileUser.getUserId()))
        .orElseThrow(() -> new CustomException(ResponseCode.PROFILE_NOT_FOUND));

    // 방명록 저장
    GuestBookEntity guestBook = GuestBookEntity.createGuestBook(profile, writer, request);
    guestBookRepository.save(guestBook);

  }

  @Override
  public void deleteGuestBook(String loginId, int guestBookId) {

    // 현재 로그인한 사용자
    UserEntity user = repository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    // 삭제하려는 방명록
    GuestBookEntity guestBook = guestBookRepository.findById(guestBookId)
        .orElseThrow(() -> new CustomException((ResponseCode.GUESTBOOK_NOT_FOUND)));

    // 방명록이 있는 프로필의 사용자가 아니거나
    // 방명록 작성자가 아니라면 삭제 불가
    UserEntity profileUser = repository.findById(guestBook.getProfile().getUserId())
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    UserEntity writerUser = repository.findById(guestBook.getWriterId())
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    if (user != profileUser && user != writerUser) {
      throw new CustomException(ResponseCode.NO_DELETE_PERMISSION);
    }

    guestBookRepository.delete(guestBook);

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

    // 내 프로필에 저장된 모든 방명록 불러오기
    List<GuestBookEntity> guestBooks = guestBookRepository.findByProfile(user.getProfile());

    List<GuestBook> guestBookList = guestBooks.stream().map(guestBookEntity -> {
      // 작성자 불러오기
      UserEntity writer = repository.findById(guestBookEntity.getWriterId())
          .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

      return GuestBook.builder()
          .guestbook_id(guestBookEntity.getGuestbookId())
          .writer_profile_img(writer.getProfile().getProfileImage())
          .writer_name(writer.getUserName())
          .content(guestBookEntity.getContent())
          .build();
    }).collect(Collectors.toList());

    return ProfileResponseDto.of(user, editable, guestBookList);
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

    if (user.getAccountId() == reqDto.getAccount_id()) {
      throw new CustomException(ResponseCode.ALREADY_MAIN_ACCOUNT);
    }

    user.updateMainAccount(reqDto.getAccount_id(), reqDto.getAccount_num());
  }
}
