package org.whalebank.backend.domain.accountbook.repository;

import jakarta.transaction.Transactional;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.whalebank.backend.domain.accountbook.AccountBookEntity;

@Repository
@RequiredArgsConstructor
public class AccountBookBulkRepository {

  private final JdbcTemplate jdbcTemplate;

  @Transactional
  public void saveAll(List<AccountBookEntity> entities) {
    String sql =
        "INSERT INTO account_book(account_book_title, trans_id, user_id, account_book_amt, account_book_category, account_book_dtm, is_hide) "
            +
            "VALUES(?,?,?,?,?,?,?)";
    jdbcTemplate.batchUpdate(sql,
        entities,
        entities.size(),
        (PreparedStatement ps, AccountBookEntity accountBook) -> {
          ps.setString(1, accountBook.getAccountBookTitle());
          ps.setInt(2, accountBook.getTransId());
          ps.setInt(3, accountBook.getUser().getUserId());
          ps.setInt(4, accountBook.getAccountBookAmt());
          ps.setString(5, accountBook.getAccountBookCategory());
          ps.setTimestamp(6, Timestamp.valueOf(accountBook.getAccountBookDtm()));
          ps.setBoolean(7, false);
        });
  }

}
