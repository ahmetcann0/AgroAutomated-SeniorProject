package entities;

public class Plant {
	private int userId;
	private String plantId;
	private double water_level;
	private double soil_moisture;
	private double temperature;
	private int conductivity;
	private double ph;
	private int nitrogen;
	private int phosporus;
	private int potasium;
	boolean ifIrrigationMustOccur;
	
	private double weather_humidity;
	private double weather_temperature;

	public Plant(int userId, String plantId, double water_level, double soil_moisture,
			double temperature, int conductivity, double ph, int nitrogen, int phosporus, int potasium, double weather_humidity, double weather_temperature) {
		this.userId = userId;
		this.plantId = plantId;
		this.water_level = water_level;
		this.soil_moisture = soil_moisture;
		this.temperature = temperature;
		this.temperature = temperature;
		this.conductivity = conductivity;
		this.ph = ph;
		this.nitrogen = nitrogen;
		this.phosporus = phosporus;
		this.potasium = potasium;
		this.weather_humidity = weather_humidity;
		this.weather_temperature = weather_temperature;
		
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getPlantId() {
		return plantId;
	}

	public void setPlantId(String plantId) {
		this.plantId = plantId;
	}

	public double getWater_level() {
		return water_level;
	}

	public void setWater_level(double distance) {
		this.water_level = distance;
	}



	public double getSoil_moisture() {
		return soil_moisture;
	}

	public void setSoil_moisture(double soil_moisture) {
		this.soil_moisture = soil_moisture;
	}

	public double getTemperature() {
		return temperature;
	}

	public void setTemperature(double temperature) {
		this.temperature = temperature;
	}
	public int getConductivity() {
		return conductivity;
	}

	public void setConductivity(int conductivity) {
		this.conductivity = conductivity;
	}

	public double getPh() {
		return ph;
	}

	public void setPh(double ph) {
		this.ph = ph;
	}

	public int getNitrogen() {
		return nitrogen;
	}

	public void setNitrogen(int nitrogen) {
		this.nitrogen = nitrogen;
	}

	public int getPhosporus() {
		return phosporus;
	}

	public void setPhosporus(int phosporus) {
		this.phosporus = phosporus;
	}

	public int getPotasium() {
		return potasium;
	}

	public void setPotasium(int potasium) {
		this.potasium = potasium;
	}
	
	public double getWeather_humidity() {
		return weather_humidity;
	}

	public void setWeather_humidity(double d) {
		this.weather_humidity = d;
	}
	
	public double getWeather_temperature() {
		return weather_temperature;
	}

	public void setWeather_temperature(double weather_temperature) {
		this.weather_temperature = weather_temperature;
	}


}