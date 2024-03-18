package org.whalebank.whalebank.domain.account.dto.response;

import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
public class AccountResponse {


  private int account_cnt;

  private List<Account> account_list;

  @NoArgsConstructor
  @AllArgsConstructor
  @Getter
  @Setter
  public static class Account {

    private int account_id;
    // private int account_type;
    private String account_num;
    private String account_name;

  }
}
