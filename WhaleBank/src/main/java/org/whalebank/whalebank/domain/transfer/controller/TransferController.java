package org.whalebank.whalebank.domain.transfer.controller;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.whalebank.whalebank.domain.transfer.dto.request.DepositRequest;
import org.whalebank.whalebank.domain.transfer.dto.request.InquiryRequest;
import org.whalebank.whalebank.domain.transfer.dto.request.WithdrawRequest;
import org.whalebank.whalebank.domain.transfer.dto.response.DepositResponse;
import org.whalebank.whalebank.domain.transfer.dto.response.InquiryResponse;
import org.whalebank.whalebank.domain.transfer.dto.response.WithdrawResponse;
import org.whalebank.whalebank.domain.transfer.service.TransferService;

@RestController
@RequestMapping("/whale/bank")
@RequiredArgsConstructor
public class TransferController {

  private final TransferService transferService;

  @PostMapping("/inquiry/receive")
  public ResponseEntity<InquiryResponse> inquiryReceive(
      HttpServletRequest request,
      @RequestBody InquiryRequest inquiryRequest) {
    return new ResponseEntity<>(transferService.inquiryReceive(request, inquiryRequest),
        HttpStatus.OK);
  }

  @PostMapping("/transfer/withdraw")
  public ResponseEntity<WithdrawResponse> withdrawTransfer(
      HttpServletRequest request,
      @RequestBody WithdrawRequest withdrawRequest) {
    return new ResponseEntity<>(transferService.withdrawTransfer(request, withdrawRequest),
        HttpStatus.OK);
  }

  @PostMapping("/transfer/deposit")
  public ResponseEntity<DepositResponse> depositTransfer(
      HttpServletRequest request,
      @RequestBody DepositRequest depositRequest) {
    return new ResponseEntity<>(transferService.depositTransfer(request, depositRequest),
        HttpStatus.OK);
  }


}
