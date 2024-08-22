package utilities;
import java.util.HashMap;
import java.util.Map;

import database.FCMSender;
import entities.Plant;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

public class SensorNotifier {

    private static final long NOTIFICATION_INTERVAL_MINUTES = 5;
    private static SensorNotifier sn;

    private static Map<String, LocalDateTime> lastNotificationTimes = new HashMap<>();

    public static SensorNotifier getInstance() {
    	if(sn == null)
    		sn = new SensorNotifier();
    	return sn;
    }


    public void sendMoistureNotificationIfAllowed(String message) {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime lastNotificationTime = lastNotificationTimes.getOrDefault("soil_moisture", LocalDateTime.MIN);

        System.out.println("Last notification time for " + message + ": " + lastNotificationTime);

        if (ChronoUnit.MINUTES.between(lastNotificationTime, now) >= NOTIFICATION_INTERVAL_MINUTES) {
            try {
                FCMSender.sendMessageToFcmRegistrationToken(message);
                lastNotificationTimes.put("soil_moisture", now);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    public void sendWaterLevelNotificationIfAllowed(String message) {
        LocalDateTime now = LocalDateTime.now();
        
        LocalDateTime lastNotificationTime = lastNotificationTimes.getOrDefault("water_level", LocalDateTime.MIN);

        System.out.println("Last notification time for " + message + ": " + lastNotificationTime);

        if (ChronoUnit.MINUTES.between(lastNotificationTime, now) >= NOTIFICATION_INTERVAL_MINUTES) {
            try {
                FCMSender.sendMessageToFcmRegistrationToken(message);
                lastNotificationTimes.put("water_level", now);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
