package org.whalebank.backend.global.config;

import feign.RequestInterceptor;
import feign.okhttp.OkHttpClient;
import org.springframework.context.annotation.Bean;

public class OpenFeignConfig {

  @Bean
  public RequestInterceptor requestInterceptor() {
    return requestTemplate -> {
      requestTemplate.header("Content-Type", "application/json");
      requestTemplate.header("Accept", "application/json");
    };
  }

  @Bean
  public OkHttpClient client() {
    return new OkHttpClient();
  }

}
