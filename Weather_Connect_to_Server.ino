#include <Adafruit_Sensor.h>
#include <Adafruit_BME280.h>
#include <analogWrite.h>
#include <HTTPClient.h>
#include <Arduino.h>
#include <Wire.h>
#include <WiFi.h>

#define moisturePin 34
#define ALTITUDE 1190.0 // Altitude in Tehran

Adafruit_BME280 bme; // I2C

float moisture = 0;
float temperature;
float humidity;
float pressure;

const char *SSID = "Virus.exe";
const char *WiFiPassword = "vAmpire2252";

void ConnectToWiFi(){
  WiFi.mode(WIFI_STA);
  WiFi.begin(SSID, WiFiPassword);
  Serial.print("Connecting to "); Serial.println(SSID);
  uint8_t i = 0;
  
  while (WiFi.status() != WL_CONNECTED){
    Serial.print('.');
    delay(500);
    
    if ((++i % 16) == 0)
      Serial.println(F(" still trying to connect"));
  }
  Serial.print(F("Connected, My IP address is: "));
  Serial.println(WiFi.localIP());
}

float getMoisture() {
  for (int i = 0; i <= 100; i++) {
    moisture = moisture + analogRead(moisturePin);
    delay(1);
  }
  moisture = moisture / 1000;
}

float getTemperature(){
  temperature = bme.readTemperature();
}

float getHumidity(){
  humidity = bme.readHumidity();
}

float getPressure(){
  pressure = bme.readPressure();
  pressure = bme.seaLevelForAltitude(ALTITUDE,pressure);
  pressure = pressure/100.F;
}


void setup() {
  Serial.begin(9600);
  pinMode(moisturePin, INPUT);
  
  bool status;
    
  // default settings
  status = bme.begin(0x76);  //The I2C address of the sensor I use is 0x76
  if (!status) {
      Serial.println("Could not find a valid BME280 sensor, check wiring!");
      while (1);
  }
  ConnectToWiFi();
}


void loop() {
  getPressure();
  getHumidity();
  getTemperature();
  getMoisture();

  String moistureString = "Moisture: " + String(moisture);
  Serial.println(moistureString);
  String temperatureString = "Temperature: "+ String(temperature,1) + " C";
  Serial.println(temperatureString);
  String pressureString = "Pressure: " + String(pressure,2) + " hPa";;
  Serial.println(pressureString);
  String humidityString = "Humidity: " + String(humidity,0) + " %"; 
  Serial.println(humidityString);
  
  if(WiFi.status() == WL_CONNECTED){
    HTTPClient http;

    http.begin("http://192.168.1.7:8000/add/");
    http.addHeader("Content-type", "application/json");
    
    int httpResponseCode = http.POST("{\"Moisture\":" + String(moisture) + ", \"Temp\":" + String(temperature) + ", \"Pressure\":" + String(pressure) + ", \"Humidity\":" + String(humidity) + "}");

    if(httpResponseCode > 0){
      String response = http.getString();
      String responseCode = "Response: " + String(httpResponseCode);
      Serial.println(responseCode);
      Serial.println(response);
      Serial.println();
      
    }else{
      Serial.print("Error on sending POST: ");
      Serial.println(httpResponseCode);
    }

    http.end();
    
  }else{
    Serial.println("Error in WiFi Connection");
  }

  delay(2000);
}
