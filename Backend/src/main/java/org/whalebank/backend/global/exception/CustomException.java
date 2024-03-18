package org.whalebank.backend.global.exception;

import lombok.Getter;
import org.whalebank.backend.global.response.ResponseCode;

@Getter
public class CustomException extends RuntimeException{

  private final ResponseCode code;
  private final String message;

  public CustomException(ResponseCode responseCode) {
    super(responseCode.getMessage());
    this.code = responseCode;
    this.message = responseCode.getMessage();
  }

}
