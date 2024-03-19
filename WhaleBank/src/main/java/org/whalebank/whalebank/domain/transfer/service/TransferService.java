package org.whalebank.whalebank.domain.transfer.service;

import jakarta.servlet.http.HttpServletRequest;
import org.whalebank.whalebank.domain.transfer.dto.request.InquiryRequest;
import org.whalebank.whalebank.domain.transfer.dto.response.InquiryResponse;
import org.whalebank.whalebank.domain.transfer.dto.response.WithdrawResponse;

public interface TransferService {

  InquiryResponse inquiryReceive(HttpServletRequest request, InquiryRequest inquiryRequest);
}
