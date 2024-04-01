package org.whalebank.whalebank;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class WhaleBankApplication {

  public static void main(String[] args) {
    SpringApplication.run(WhaleBankApplication.class, args);
  }

}
