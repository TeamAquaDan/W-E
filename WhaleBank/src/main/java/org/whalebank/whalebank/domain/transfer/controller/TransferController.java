package org.whalebank.whalebank.domain.transfer.controller;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.whalebank.whalebank.domain.transfer.dto.request.DepositRequest;
import org.whalebank.whalebank.domain.transfer.dto.request.InquiryRequest;
import org.whalebank.whalebank.domain.transfer.dto.request.WithdrawRequest;
import org.whalebank.whalebank.domain.transfer.dto.response.WithdrawResponse;

@RestController
@RequestMapping("/whale/bank")
@RequiredArgsConstructor
public class TransferController {

    @PostMapping("/transfer/withdraw")
    public ResponseEntity<WithdrawResponse> withdrawTransfer(
            HttpServletRequest request,
            @RequestBody WithdrawRequest withdrawRequest) {
        return null;
    }

    @PostMapping("/transfer/deposit")
    public ResponseEntity<WithdrawResponse> depositTransfer(
            HttpServletRequest request,
            @RequestBody DepositRequest depositRequest) {
        return null;
    }

    @PostMapping("/inquiry/receive")
    public ResponseEntity<WithdrawResponse> inquiryReceive(
            HttpServletRequest request,
            @RequestBody InquiryRequest receiveRequest) {
        return null;
    }
}
