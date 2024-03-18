package org.whalebank.whalebank.domain.transfer.dto.response;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WithdrawResponse {

    private int rsp_code;
    private String rsp_message;

    private String api_tran_id;    // 거래 고유 번호
    private LocalDateTime api_tran_dtm; // 거래일시
    private String dps_bank_code_std;   // 입금기관 표준코드
    private String dps_print_content;   // 입금계좌 인자내역
    private String dps_bank_name;   // 입금기관명
    private String dps_account_num_masked;  // 입금계좌번호
    private String dps_account_holder_name; // 수취인성명
    private String print_content;   // 출금계좌 인자내역
    private String account_holder_name; // 송금인 성명
    private int tran_amt;   // 거래금액
    private int wd_limit_remain_amt;    // 출금한도 잔여금액

}
