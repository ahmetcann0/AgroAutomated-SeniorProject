package utilities;

import database.FCMSender;
import database.RealtimeDatabaseInteraction;
import entities.Plant;


public class CheckMoistureLevelIrrigateIfNecessary {
	static RealtimeDatabaseInteraction db = RealtimeDatabaseInteraction.getInstance();
	
	public static String CheckMoistureLevelChangeDatabaseVariable(Plant plantObj) throws Exception {
		SensorNotifier sn = SensorNotifier.getInstance();

		String plantID = plantObj.getPlantId();
		double soil_moisture = plantObj.getSoil_moisture();
		String result="";
		
		  if (soil_moisture < 10) {// Very low soil moisture
		    result = "Soil moisture is critically low. Water plant now! "+soil_moisture+"%";
			db.updateifIrrigationMustOccur(plantID, true);
			
			FCMSender.sendMessageToFcmRegistrationToken("Automatic irrigation has been started!");

		  } 
		  else if (soil_moisture >= 10 && soil_moisture < 30) {// Low soil moisture
		    result = "Soil moisture is low. Consider watering the plants: "+soil_moisture+"%";
			db.updateifIrrigationMustOccur(plantID, true);
			FCMSender.sendMessageToFcmRegistrationToken("Automatic irrigation has been started!");

		  } 
		  else if (soil_moisture >= 30 && soil_moisture < 50) {// Moderate soil moisture
		    result = "Soil moisture is at a moderate level: "+soil_moisture+"%";
			db.updateifIrrigationMustOccur(plantID, false);
			sn.sendMoistureNotificationIfAllowed("Soil moisture is nearly 50%.");

		  }
		  else if (soil_moisture >= 50 && soil_moisture < 70) {// Moderate soil moisture
			result = "Soil moisture is at a moderate level: "+soil_moisture+"%";
			db.updateifIrrigationMustOccur(plantID, false);

		  }
		  else if(soil_moisture >= 70 && soil_moisture < 100) { // Adequate soil moisture
		    result = "Water level is above %70. Might be risky!";
			db.updateifIrrigationMustOccur(plantID, false);
			sn.sendMoistureNotificationIfAllowed("Soil moisture is more than %70. Too much irrigation might be harmful!");


		  }
		 return result;
    }
	
}

