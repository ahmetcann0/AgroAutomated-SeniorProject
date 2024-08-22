package model;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Random;

import org.netlib.util.doubleW;

import entities.Plant;
import java_cup.internal_error;
import weka.classifiers.Classifier;
import weka.core.DenseInstance;
import weka.core.Instance;
import weka.core.Instances;
import weka.core.SerializationHelper;
import weka.core.converters.ConverterUtils.DataSource;

public class PredictUsingAI {
	
	private String cropType;
	private int cropDays;
	private int humidity;
	private int soilMoisture;
	private int temperature;
	private double Nitrogen;
	private double Phosphorous;
	private double Potassium;
	private double pH; 
	private double Rainfall;

	public PredictUsingAI(String cropType, int cropDays, int soilMoisture, int temperature ,int humidity, double nitrogen, double potassium, double ph, double rainfall) {
		this.cropType = cropType;
		this.cropDays = cropDays;
		this.soilMoisture = soilMoisture;
		this.temperature = temperature;
		this.humidity = humidity;
		this.Nitrogen = nitrogen;
		this.Potassium = potassium;
		this.pH = ph;
		this.Rainfall = rainfall;
	}
	
	public static String predictIrrigation(Plant plantObj) {
		double soil_temperature = plantObj.getTemperature();
		double soil_moisture = plantObj.getSoil_moisture();
		
        try {
            Classifier rf_model = (Classifier) SerializationHelper.read("C:\\Users\\Deniz\\OneDrive\\Belgeler\\GitHub\\agroautomated_cloned\\agroautomated\\backend_most_new\\WebSocketApp\\src\\AIModels\\rf_model.model");

            DataSource source = new DataSource("C:\\Users\\Deniz\\OneDrive\\Belgeler\\GitHub\\agroautomated_cloned\\agroautomated\\backend_most_new\\WebSocketApp\\src\\AIModels\\soil_moisture_prediction.csv");
            Instances data = source.getDataSet();
            if (data.classIndex() == -1)
                data.setClassIndex(data.numAttributes() - 1);

            Instance user_input = new DenseInstance(data.numAttributes());
            user_input.setDataset(data);

            String cropType = "Garden Flowers";
            user_input.setValue(data.attribute("CropType"), cropType);

            int cropDays = 67;
            user_input.setValue(data.attribute("CropDays"), cropDays);

            user_input.setValue(data.attribute("SoilMoisture"), soil_moisture);

            user_input.setValue(data.attribute("temperature"), soil_temperature);

            int humidity = 10;
            user_input.setValue(data.attribute("Humidity"), humidity);

            double prediction = rf_model.classifyInstance(user_input);

            float pr = Math.round(prediction);
            

            if (pr == 1.0) {
                return "Irrigate";
            } else {
                return "Do not Irrigate";
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Operation was unsuccessful";
    }
	
	public static String predictCrop(Plant plantObj) {
		
		int nitrogen = plantObj.getNitrogen();
		int phosporus = plantObj.getPhosporus();
		int potasium = plantObj.getPotasium();
		double soil_temperature = plantObj.getTemperature();
		double soil_humidity = plantObj.getSoil_moisture();
		double ph = plantObj.getPh();
		
		try {
            
            Classifier crf_model = (Classifier) SerializationHelper.read("C:\\Users\\Deniz\\OneDrive\\Belgeler\\GitHub\\agroautomated_cloned\\agroautomated\\backend_most_new\\WebSocketApp\\src\\AIModels\\cropmodel.model");
            
            DataSource source = new DataSource("C:\\Users\\Deniz\\OneDrive\\Belgeler\\GitHub\\agroautomated_cloned\\agroautomated\\backend_most_new\\WebSocketApp\\src\\AIModels\\Crop_recommendation.csv");
            Instances data = source.getDataSet();
            if (data.classIndex() == -1)
                data.setClassIndex(data.numAttributes() - 1);

                        
            Instance user_input = new DenseInstance(data.numAttributes());
            user_input.setDataset(data);

            user_input.setValue(data.attribute("N"), nitrogen);
            user_input.setValue(data.attribute("P"), phosporus);
            user_input.setValue(data.attribute("K"), potasium);
            user_input.setValue(data.attribute("temperature"), soil_temperature);
            user_input.setValue(data.attribute("humidity"), soil_humidity);
            user_input.setValue(data.attribute("ph"), ph);

            Random r = new Random();
			//double rainfall = 20 + (300 - 20) * r.nextDouble();
			double rainfall = 36.7;
			System.out.println("rainfall value:" +rainfall);
            
            user_input.setValue(data.attribute("rainfall"), rainfall);
            
            double prediction = crf_model.classifyInstance(user_input);
            
            String predictedLabel = data.classAttribute().value((int) prediction);
            //System.out.println("Predicted crop label: " + predictedLabel);
            return predictedLabel;

        } catch (Exception e) {
            e.printStackTrace();
        }
		return null;
	}

	public String getCropType() {
		return cropType;
	}

	public void setCropType(String cropType) {
		this.cropType = cropType;
	}

	public int getCropDays() {
		return cropDays;
	}

	public void setCropDays(int cropDays) {
		this.cropDays = cropDays;
	}

	public int getHumidity() {
		return humidity;
	}

	public void setHumidity(int humidity) {
		this.humidity = humidity;
	}

	public int getSoilMoisture() {
		return soilMoisture;
	}

	public void setSoilMoisture(int soilMoisture) {
		this.soilMoisture = soilMoisture;
	}

	public int getTemperature() {
		return temperature;
	}

	public void setTemperature(int temperature) {
		this.temperature = temperature;
	}

	public double getNitrogen() {
		return Nitrogen;
	}

	public void setNitrogen(double nitrogen) {
		Nitrogen = nitrogen;
	}

	public double getPhosphorous() {
		return Phosphorous;
	}

	public void setPhosphorous(double phosphorous) {
		Phosphorous = phosphorous;
	}

	public double getPotassium() {
		return Potassium;
	}

	public void setPotassium(double potassium) {
		Potassium = potassium;
	}

	public double getpH() {
		return pH;
	}

	public void setpH(double pH) {
		this.pH = pH;
	}

	public double getRainfall() {
		return Rainfall;
	}

	public void setRainfall(double rainfall) {
		Rainfall = rainfall;
	}
	
}