package org.whalebank.whalebank.domain.transfer.service;

import jakarta.servlet.http.HttpServletRequest;
import org.whalebank.whalebank.domain.transfer.dto.request.DepositRequest;
import org.whalebank.whalebank.domain.transfer.dto.request.InquiryRequest;
import org.whalebank.whalebank.domain.transfer.dto.request.WithdrawRequest;
import org.whalebank.whalebank.domain.transfer.dto.response.DepositResponse;
import org.whalebank.whalebank.domain.transfer.dto.response.InquiryResponse;
import org.whalebank.whalebank.domain.transfer.dto.response.WithdrawResponse;

public interface TransferService {

  InquiryResponse inquiryReceive(HttpServletRequest request, InquiryRequest inquiryRequest);

  WithdrawResponse withdrawTransfer(HttpServletRequest request, WithdrawRequest withdrawRequest);

  DepositResponse depositTransfer(HttpServletRequest request, DepositRequest depositRequest);
}
