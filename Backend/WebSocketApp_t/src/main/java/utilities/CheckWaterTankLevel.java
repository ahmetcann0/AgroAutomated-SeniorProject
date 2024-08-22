package utilities;

import database.FCMSender;
import database.RealtimeDatabaseInteraction;
import entities.Plant;


public class CheckWaterTankLevel {
	static RealtimeDatabaseInteraction db = RealtimeDatabaseInteraction.getInstance();
	
	public static String CheckWaterTankLevelChangeDatabaseVariable(Plant plantObj) throws Exception {
		SensorNotifier sn = SensorNotifier.getInstance();

		double water_level = plantObj.getWater_level();
		String result="";
		
		  if (water_level < 10) {// Very low soil moisture
			  result = "Water tank level is critically low! "+water_level+"%";
			  sn.sendWaterLevelNotificationIfAllowed(result);

		  } 
		  else if (water_level >= 20 && water_level < 30) {// Low soil moisture
			  result = "Water tank level is low! "+water_level+"%";
			  sn.sendWaterLevelNotificationIfAllowed(result);
		  } 

		  return result;
    }
	
}

