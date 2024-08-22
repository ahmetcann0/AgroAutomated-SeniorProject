package database;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.HashMap;
import java.util.concurrent.CountDownLatch;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import entities.Plant;
import entities.SensorEntities;
import server.ws.WsServer;
import utilities.SensorNotifier;

public class RealtimeDatabaseInteraction {

    private String credentials;
    private String DATABASE_URL;

    private FirebaseDatabase firebaseDatabase;

    static RealtimeDatabaseInteraction realtimeDatabaseInteractionObject = null;

    private RealtimeDatabaseInteraction() throws IOException {
        credentials = "C:\\\\Users\\\\Deniz\\\\eclipse-workspace\\\\FirebaseInteraction\\\\agroautomated-8f55e-firebase-adminsdk-mdmjm-56a8631d3b.json";
        DATABASE_URL = "https://agroautomated-8f55e-default-rtdb.firebaseio.com/";
    }

    public synchronized static RealtimeDatabaseInteraction getInstance() {
        if (realtimeDatabaseInteractionObject == null) {
            try {
                realtimeDatabaseInteractionObject = new RealtimeDatabaseInteraction();
            } catch (IOException e) {
                System.out.println("Exception in RealtimeDatabaseInteraction>getInstance()");
                e.printStackTrace();
            }
        }
        return realtimeDatabaseInteractionObject;
    }

    public int initialize() throws FileNotFoundException {
        FileInputStream serviceAccount =
            new FileInputStream(credentials);

        FirebaseOptions options;
        try {
            options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .setDatabaseUrl(DATABASE_URL)
                    .build();
            FirebaseApp.initializeApp(options);
            return 1;
        } catch (IOException e) {
            return -1;
        }
    }

    public void retrieveCurrentData(String plantName) {
        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("sensor_data").child(plantName);

        ref.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                SensorEntities sensorData = dataSnapshot.getValue(SensorEntities.class);
                if (sensorData != null) {
                    System.out.println("Veri Alındı:");
                    System.out.println("Distance Float: " + sensorData.distance_float);
                    System.out.println("Humidity Integer: " + sensorData.humidity_integer);
                    System.out.println("Information String: " + sensorData.information_string);
                    System.out.println("Soil Moisture Integer: " + sensorData.soil_moisture_integer);
                    System.out.println("Temperature Integer: " + sensorData.temperature_integer);
                }
            }

            @Override
            public void onCancelled(DatabaseError error) {
                System.out.println("Error retrieving data: " + error.getMessage());
            }
        });
    }

    public void addIfButtonPressedListener(int userId,String plantId){
        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("sensor_data").child(plantId).child("ifButtonPressed");

        ref.addValueEventListener(new ValueEventListener() {
            private Integer lastValue = null;

            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                Integer currentValue = dataSnapshot.getValue(Integer.class);
                if (currentValue != null && !currentValue.equals(lastValue)) {
                    System.out.println("ifButtonPressed value changed: " + currentValue);
                    lastValue = currentValue;
                    WsServer.ifIrrigationMustOccur = true;

                    
                }
            }

            @Override
            public void onCancelled(DatabaseError databaseError) {
                System.out.println("Listener was cancelled: " + databaseError.getMessage());
            }
        });
    }
    public void ifIrrigationMustOccurListener(int userId,String plantId){
        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("sensor_data").child(plantId).child("ifIrrigationMustOccur");

        ref.addValueEventListener(new ValueEventListener() {

            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                Boolean currentValue = dataSnapshot.getValue(Boolean.class);
                if (currentValue.equals(true)) {
                    System.out.println("ifIrrigationMustOccur value is true: " + currentValue);
                    WsServer.ifIrrigationMustOccur = true;
                    
//                    try {
//						WsServer.sessions.get(userId).getBasicRemote().sendText("Irrigate for 5 seconds!");
//					} catch (IOException e) {
//						e.printStackTrace();
//					}
                    
                }
            }

            @Override
            public void onCancelled(DatabaseError databaseError) {
                System.out.println("Listener was cancelled: " + databaseError.getMessage());
            }
        });
    }


    public void updaterDriver(int userId, String plantId, HashMap<Integer, HashMap<String, Plant>> userId_PlantId_Plant_HashMap, String cropRecommendationFromAi) {
        Plant correspondingUsersPlant = (userId_PlantId_Plant_HashMap.get(userId)).get(plantId);

        updateWaterLevel(plantId, correspondingUsersPlant.getWater_level());
        updateSoilMoisture(plantId, correspondingUsersPlant.getSoil_moisture());
        updateTemperature(plantId, correspondingUsersPlant.getTemperature());
        updateConductivity(plantId, correspondingUsersPlant.getConductivity());
        updatePh(plantId, correspondingUsersPlant.getPh());
        updateNitrogen(plantId, correspondingUsersPlant.getNitrogen());
        updatePhosporus(plantId, correspondingUsersPlant.getPhosporus());
        updatePotasium(plantId, correspondingUsersPlant.getPotasium());
        updateweather_humidity(plantId, correspondingUsersPlant.getWeather_humidity());
        updateweather_temperature(plantId, correspondingUsersPlant.getWeather_temperature());
        updateCropRecommendationFromAi(plantId, cropRecommendationFromAi);

    }
    public void updateifIrrigationMustOccur(String plantId, boolean irrigateOrNot) {

        try {
        	DatabaseReference ref = FirebaseDatabase.getInstance().getReference("sensor_data").child(plantId).child("ifIrrigationMustOccur");
        	final CountDownLatch latch = new CountDownLatch(1);
            ref.setValue(irrigateOrNot, new DatabaseReference.CompletionListener() {
                @Override
                public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference) {
                    if (databaseError != null) {
                        System.out.println("Data could not be saved " + databaseError.getMessage());
                        latch.countDown();
                    } else {
                        System.out.println("Data saved successfully.");
                        latch.countDown();
                    }
                }
            });
            latch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    public void updateweather_humidity(String plantId, double weather_humidity) {

        try {
        	DatabaseReference ref = FirebaseDatabase.getInstance().getReference("sensor_data").child(plantId).child("weather_humidity");
        	final CountDownLatch latch = new CountDownLatch(1);
            ref.setValue(weather_humidity, new DatabaseReference.CompletionListener() {
                @Override
                public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference) {
                    if (databaseError != null) {
                        System.out.println("Data could not be saved " + databaseError.getMessage());
                        latch.countDown();
                    } else {
                        System.out.println("Data saved successfully.");
                        latch.countDown();
                    }
                }
            });
            latch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
    public void updateweather_temperature(String plantId, double weather_temperature) {
        try {
        	DatabaseReference ref = FirebaseDatabase.getInstance().getReference("sensor_data").child(plantId).child("weather_temperature");
        	final CountDownLatch latch = new CountDownLatch(1);
            ref.setValue(weather_temperature, new DatabaseReference.CompletionListener() {
                @Override
                public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference) {
                    if (databaseError != null) {
                        System.out.println("Data could not be saved " + databaseError.getMessage());
                        latch.countDown();
                    } else {
                        System.out.println("Data saved successfully.");
                        latch.countDown();
                    }
                }
            });
            latch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
    public void updateWaterLevel(String plantId,double distance_float) {
        try {
            DatabaseReference ref = FirebaseDatabase.getInstance().getReference("sensor_data").child(plantId).child("distance");
            final CountDownLatch latch = new CountDownLatch(1);
            ref.setValue(distance_float, new DatabaseReference.CompletionListener() {
                @Override
                public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference) {
                    if (databaseError != null) {
                        System.out.println("Data could not be saved " + databaseError.getMessage());
                        latch.countDown();
                    } else {
                        System.out.println("Data saved successfully.");
                        latch.countDown();
                    }
                }
            });
            latch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
    
    public void updateSoilMoisture(String plantId, double soil_moisture_integer) {
        try {
        	DatabaseReference ref = FirebaseDatabase.getInstance().getReference("sensor_data").child(plantId).child("soil_moisture");
        	final CountDownLatch latch = new CountDownLatch(1);
            ref.setValue(soil_moisture_integer, new DatabaseReference.CompletionListener() {
                @Override
                public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference) {
                    if (databaseError != null) {
                        System.out.println("Data could not be saved " + databaseError.getMessage());
                        latch.countDown();
                    } else {
                        System.out.println("Data saved successfully.");
                        latch.countDown();
                    }
                }
            });
            latch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
    public void updateTemperature(String plantId, double temperature_integer) {
        try {
        	DatabaseReference ref = FirebaseDatabase.getInstance().getReference("sensor_data").child(plantId).child("soil_temperature");
        	final CountDownLatch latch = new CountDownLatch(1);
            ref.setValue(temperature_integer, new DatabaseReference.CompletionListener() {
                @Override
                public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference) {
                    if (databaseError != null) {
                        System.out.println("Data could not be saved " + databaseError.getMessage());
                        latch.countDown();
                    } else {
                        System.out.println("Data saved successfully.");
                        latch.countDown();
                    }
                }
            });
            latch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
    public void updateConductivity(String plantId, int conductivity) {
        try {
        	DatabaseReference ref = FirebaseDatabase.getInstance().getReference("sensor_data").child(plantId).child("soil_conductivity");
        	final CountDownLatch latch = new CountDownLatch(1);
            ref.setValue(conductivity, new DatabaseReference.CompletionListener() {
                @Override
                public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference) {
                    if (databaseError != null) {
                        System.out.println("Data could not be saved " + databaseError.getMessage());
                        latch.countDown();
                    } else {
                        System.out.println("Data saved successfully.");
                        latch.countDown();
                    }
                }
            });
            latch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
    public void updatePh(String plantId, double ph) {
        try {
        	DatabaseReference ref = FirebaseDatabase.getInstance().getReference("sensor_data").child(plantId).child("soil_ph");
        	final CountDownLatch latch = new CountDownLatch(1);
            ref.setValue(ph, new DatabaseReference.CompletionListener() {
                @Override
                public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference) {
                    if (databaseError != null) {
                        System.out.println("Data could not be saved " + databaseError.getMessage());
                        latch.countDown();
                    } else {
                        System.out.println("Data saved successfully.");
                        latch.countDown();
                    }
                }
            });
            latch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
    public void updateNitrogen(String plantId, int nitrogen) {
        try {
        	DatabaseReference ref = FirebaseDatabase.getInstance().getReference("sensor_data").child(plantId).child("soil_nitrogen");
        	final CountDownLatch latch = new CountDownLatch(1);
            ref.setValue(nitrogen, new DatabaseReference.CompletionListener() {
                @Override
                public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference) {
                    if (databaseError != null) {
                        System.out.println("Data could not be saved " + databaseError.getMessage());
                        latch.countDown();
                    } else {
                        System.out.println("Data saved successfully.");
                        latch.countDown();
                    }
                }
            });
            latch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
    public void updatePhosporus(String plantId, int phosporus) {
        try {
        	DatabaseReference ref = FirebaseDatabase.getInstance().getReference("sensor_data").child(plantId).child("soil_phosporus");
        	final CountDownLatch latch = new CountDownLatch(1);
            ref.setValue(phosporus, new DatabaseReference.CompletionListener() {
                @Override
                public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference) {
                    if (databaseError != null) {
                        System.out.println("Data could not be saved " + databaseError.getMessage());
                        latch.countDown();
                    } else {
                        System.out.println("Data saved successfully.");
                        latch.countDown();
                    }
                }
            });
            latch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
    public void updatePotasium(String plantId, int potasium) {
        try {
        	DatabaseReference ref = FirebaseDatabase.getInstance().getReference("sensor_data").child(plantId).child("soil_potasium");
        	final CountDownLatch latch = new CountDownLatch(1);
            ref.setValue(potasium, new DatabaseReference.CompletionListener() {
                @Override
                public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference) {
                    if (databaseError != null) {
                        System.out.println("Data could not be saved " + databaseError.getMessage());
                        latch.countDown();
                    } else {
                        System.out.println("Data saved successfully.");
                        latch.countDown();
                    }
                }
            });
            latch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
    public void updateCropRecommendationFromAi(String plantId, String cropRecommendationFromAi) {
        try {
        	DatabaseReference ref = FirebaseDatabase.getInstance().getReference("sensor_data").child(plantId).child("Recommended Crop");
        	final CountDownLatch latch = new CountDownLatch(1);
            ref.setValue(cropRecommendationFromAi, new DatabaseReference.CompletionListener() {
                @Override
                public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference) {
                    if (databaseError != null) {
                        System.out.println("Data could not be saved " + databaseError.getMessage());
                        latch.countDown();
                    } else {
                        System.out.println("Data saved successfully.");
                        latch.countDown();
                    }
                }
            });
            latch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }


    public void close() {
        FirebaseDatabase.getInstance().getApp().delete();
    }
}