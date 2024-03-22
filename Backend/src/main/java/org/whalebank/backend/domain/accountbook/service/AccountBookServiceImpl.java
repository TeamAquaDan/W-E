package org.whalebank.backend.domain.accountbook.service;

import java.time.LocalDateTime;
import java.time.YearMonth;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.accountbook.AccountBookEntity;
import org.whalebank.backend.domain.accountbook.AccountBookRepository;
import org.whalebank.backend.domain.accountbook.dto.response.CardHistoryResponseDto;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.domain.user.repository.AuthRepository;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.openfeign.card.CardAccessUtil;
import org.whalebank.backend.global.openfeign.card.response.CardHistoryResponse;
import org.whalebank.backend.global.response.ResponseCode;

@Service
@RequiredArgsConstructor
public class AccountBookServiceImpl implements AccountBookService {

  private final AuthRepository userRepository;
  private final AccountBookRepository repository;
  private final CardAccessUtil cardAccessUtil;

  @Override
  public void saveCardHistory(UserEntity user) {
    // 카드 내역 조회
    CardHistoryResponse resFromCard = cardAccessUtil.getCardHistory(user.getCardAccessToken(),
        user.getLastCardHistoryFetchTime());
    // 카드 내역 저장
    List<AccountBookEntity> accountBookList = resFromCard.getPay_list().stream()
        .map(detail -> AccountBookEntity.from(detail, user))
        .collect(Collectors.toList());

    repository.saveAll(accountBookList);
  }

  @Override
  public List<CardHistoryResponseDto> getCardHistory(String loginId, int year, int month) {
    UserEntity currentUser = userRepository.findByLoginId(loginId)
            .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));
    
    if(month<1 || month>12) throw new CustomException(ResponseCode.INVALID_TIME_FORMAT);

    // 주어진 연도와 월로 YearMonth 객체 생성
    YearMonth yearMonth = YearMonth.of(year, month);
    // 해당 연도와 월의 마지막 날짜 얻기
    int lastDayOfMonth = yearMonth.lengthOfMonth();

    // 내 가계부 내역 중에 year, month에 해당하는 내역을 시간 내림차순으로 정렬해서 돌려줘야함
    return repository.findAllByUserAndAccountBookDtmBetweenOrderByAccountBookDtmDesc(
        currentUser,
        LocalDateTime.of(year, month, 1, 0, 0,0),
        LocalDateTime.of(year, month, lastDayOfMonth, 23,59,59))
        .stream().map(CardHistoryResponseDto::from)
        .collect(Collectors.toList());
  }
}
