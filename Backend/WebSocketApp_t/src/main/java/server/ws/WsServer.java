package server.ws;
 
import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutionException;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import org.json.JSONObject;

import database.FirebaseStorageInteraction;
import database.RealtimeDatabaseInteraction;
import model.ProcessMessage;
import model.WriteFile;
import model.ProvideWeatherInformation;
import entities.Plant;
 
@ServerEndpoint("/websocketendpoint")
public class WsServer {
	 private Session session;
	 
	 public static Map<Integer, Session> sessions = new ConcurrentHashMap<>();
	 HashMap<Integer, HashMap<String, Plant>> userPlants = new HashMap<Integer, HashMap<String, Plant>>();
	 
	 public static boolean ifIrrigationMustOccur = false;
	 
	 //Integer: userId, String:plantId, Plant: Plant object.

	 private RealtimeDatabaseInteraction db;
     private ProcessMessage pm = ProcessMessage.getInstance();

    @OnOpen
    public void onOpen(Session session) throws IOException, InterruptedException, ExecutionException{

    	this.session = session;
    	System.out.println("Client has been connected: "+session.getId());
    	//ProvideWeatherInformation weather = new ProvideWeatherInformation();
    	//weather.getRainfallInfo();

    }
     
    @OnClose
    public void onClose(){
        System.out.println("Close Connection ...");

    }
     
    @OnMessage
    public void onMessage(String message) throws Exception{
    	
        System.out.println("Message from the client: " + message);
    	JSONObject userMessage = new JSONObject(message);   
    	
        int userId = Integer.parseInt(userMessage.get("clientId").toString());
        String plantId = userMessage.get("plantId").toString();;
        
        if(message.contains("clientId") && !message.contains("Irrigation finished")) {
        
            boolean ifUserIdPresent = sessions.containsKey(Integer.valueOf(userId));
    		if(!ifUserIdPresent) {
    			sessions.put(Integer.valueOf(userId), session); //Added user with the id to the HashMap.
    		}
    		boolean isPlantIdPresent = userPlants.containsKey(Integer.valueOf(userId));
    		if(!isPlantIdPresent) {
    	        userPlants.put(Integer.valueOf(userId), new HashMap<String, Plant>());
    		}
       
            long startTime = System.currentTimeMillis();
            String result = pm.process(userId, userPlants, message);
            System.out.println(result);
            long stopTime = System.currentTimeMillis();
            System.out.println("Elapsed time is: " +(stopTime-startTime)+" ms");
               
        }
        if(ifIrrigationMustOccur) {
        	if(message.contains("Irrigation finished")) {
        		ifIrrigationMustOccur = false;
        		RealtimeDatabaseInteraction.getInstance().updateifIrrigationMustOccur(plantId, false);
                session.getBasicRemote().sendText("send sensor data");
        	}else {
                session.getBasicRemote().sendText("Irrigate for 5 seconds!");
        	}
        }else {
            session.getBasicRemote().sendText("send sensor data");
        }
        	
//    	dbStorage.initialize();
//
//    	dbStorage.close(); 
        	
    }
 
    @OnError
    public void onError(Throwable e){
        e.printStackTrace();
    }
 
}