package org.whalebank.backend.global.openfeign.bank.response;

import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AccountListResponseDto {

  public String rsp_code;
  public String rsp_message;
  public int account_num;
  public List<AccountInfo> account_list;

  @Getter
  @Setter
  public static class AccountInfo {

    public int account_id;
    public int account_type;
    public String account_num;
    public String account_name;
    public int balance_amt;

  }

}
