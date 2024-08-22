package model;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.time.format.DateTimeFormatter;

import entities.SensorEntities;

import java.time.LocalDateTime;  

public class WriteFile {
    private DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy,HH:mm:ss");
    private String filePath; 
    private String filename;
    
    public WriteFile(String filePath, String filename) {
    	this.filePath = filePath;
    	this.filename = filename;
        try {
            File myObj = new File(filePath+filename);
            if (myObj.createNewFile()) {
                System.out.println("File created: " + myObj.getName());
                FileWriter myWriter = new FileWriter(filePath+"\\"+filename,true);
                myWriter.write("date,time,weather_humidity,weather_temperature,soil_moisture,water_level,soil_temperature,soil_conductivity,soil_ph,soil_nitrogen,soil_phosporus,soil_potasium\n");
                myWriter.close();
            } else {
                System.out.println("File already exists.");
            }
            myObj = null;
        } catch (IOException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }
    }

    public void writeLineDataAndTimestamp(String[] sensorDataLineArray) {
        LocalDateTime now = LocalDateTime.now();  
        StringBuilder sensorDataLine = new StringBuilder(100);
        sensorDataLine.append(dtf.format(now));

        for(int i = 0; i < sensorDataLineArray.length; i++) 
            sensorDataLine.append(",").append(sensorDataLineArray[i]);
        
        try {
            FileWriter myWriter = new FileWriter(filePath+"\\"+filename,true);
            myWriter.write(sensorDataLine.toString()+"\n");
            myWriter.close();
            myWriter = null;
        } catch (IOException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }
    }
}
