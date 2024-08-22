package database;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.messaging.AndroidConfig;
import com.google.firebase.messaging.AndroidNotification;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import java.io.InputStream;

public class FCMSender {
  private static InputStream getServiceAccount() {
    return FCMSender.class.getClassLoader().getResourceAsStream("service-account.json");
  }

  private static void initFirebaseSDK() throws Exception {
    FirebaseOptions options =
        FirebaseOptions.builder()
            .setCredentials(GoogleCredentials.fromStream(getServiceAccount()))
            .build();

    FirebaseApp.initializeApp(options);
  }

  public static void sendMessageToFcmRegistrationToken(String messageToBeSent) throws Exception {
    String registrationToken = "dKMM6Zj8S0u4IP-03qyyRk:APA91bHDjr88_lLaKSDTwZJS-lem9eer83MEehzWYGGkg4mi-5VDZfvxjGwSW0in98TbTu5lyoUAwbICY0KBB2nG5thBfUQkT8UNQ5RTV5Iut499cPA-nAx6d4mprAoGlycnM1gEfIlG";
    Message message =
        Message.builder()
            .putData("FCM", "https://firebase.google.com/docs/cloud-messaging")
            .putData("flutter", "https://flutter.dev/")
            .setNotification(
                Notification.builder()
                    .setTitle("AgroAutomaTED")
                    .setBody(messageToBeSent)
                    .build())
            .setToken(registrationToken)
            .build();

    FirebaseMessaging.getInstance().send(message);

    System.out.println("Message to FCM Registration Token sent successfully:"+messageToBeSent);
  }

  private static void sendMessageToFcmTopic() throws Exception {
    String topicName = "app_promotion";

    Message message =
        Message.builder()
            .setNotification(
                Notification.builder()
                    .setTitle("A new app is available")
                    .setBody("Check out our latest app in the app store.")
                    .build())
            .setAndroidConfig(
                AndroidConfig.builder()
                    .setNotification(
                        AndroidNotification.builder()
                            .setTitle("A new Android app is available")
                            .setBody("Our latest app is available on Google Play store")
                            .build())
                    .build())
            .setTopic("app_promotion")
            .build();

    FirebaseMessaging.getInstance().send(message);

    System.out.println("Message to topic sent successfully!!");
  }

}