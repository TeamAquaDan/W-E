package org.whalebank.backend.global.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.messaging.FirebaseMessaging;
import java.io.FileInputStream;
import java.io.IOException;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.response.ResponseCode;

@Configuration
public class FirebaseConfig {

  @Bean
  FirebaseMessaging firebaseMessaging() {

    try {
      FirebaseApp firebaseApp = null;

      FileInputStream serviceAccount =
          new FileInputStream(
              "src/main/resources/key/whale-f56e3-firebase-adminsdk-ows0f-2bf63a2a02.json");

      FirebaseOptions options = new FirebaseOptions.Builder()
          .setCredentials(GoogleCredentials.fromStream(serviceAccount))
          .setDatabaseUrl("https://whale-f56e3-default-rtdb.asia-southeast1.firebasedatabase.app")
          .build();

      firebaseApp = FirebaseApp.initializeApp(options);
      return FirebaseMessaging.getInstance(firebaseApp);
    } catch(IOException e) {
      e.printStackTrace();
      throw new CustomException(ResponseCode.FIREBASE_SETTING_FAIL);
    }

  }

}
