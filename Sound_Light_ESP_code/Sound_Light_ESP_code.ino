const char* ssid_rout0 = "Winterfell";
const char* pass_rout0 = "AryaStark";

#include <ESP8266WiFi.h>

IPAddress ip1(10, 42, 3, 204);
IPAddress gateway1(10, 42, 3, 1);
IPAddress subnet(255, 255, 255, 0);

#define MAX_SRV_CLIENTS 1
WiFiClient serverClients[MAX_SRV_CLIENTS];

WiFiServer serverS(500);
unsigned long lastp = 0;


void setup() {
  // put your setup code here, to run once:

pinMode(12, OUTPUT);
digitalWrite(12, HIGH); delay(9); 

Serial.begin(115200);

  WiFi.disconnect();  
  Serial.println("Wifi disconnected...");

  delay(300);
  WiFi.mode(WIFI_STA);
  Serial.println("Mode Set...");
  
 delay(300);
  //WiFi.mode(WIFI_AP_STA);
 Serial.println("Mode Set...");
      
  WiFi.begin(ssid_rout0, pass_rout0);
  WiFi.config(ip1, gateway1, subnet);

  delay(3000);
serverS.begin(); serverS.setNoDelay(true);
}

void loop() {


    if (Serial.available())
    {
      String a = Serial.readString();
      if (a.indexOf("rrr") != -1 ) 
        {
          ESP.restart();
        }
    }
    
  // put your main code here, to run repeatedly:
delay(1);
    uint8_t i;
  //check if there are any new clients
  if (serverS.hasClient()){
    for(i = 0; i < MAX_SRV_CLIENTS; i++){
      //find free/disconnected spot
      if (!serverClients[i] || !serverClients[i].connected()){
        if(serverClients[i]) serverClients[i].stop();
        serverClients[i] = serverS.available();
      //  Serial.print("New client: "); Serial.print(i);
        continue;
      }
    }
    //no free/disconnected spot so reject
    WiFiClient serverClient = serverS.available();
    serverClient.stop();
  }
  //check clients for data
  for(i = 0; i < MAX_SRV_CLIENTS; i++){
    if (serverClients[i] && serverClients[i].connected()){
      if(serverClients[i].available()){
 //     Serial.println(serverClients[i].available());
        String sound = serverClients[i].readStringUntil('\n');serverClients[i].setTimeout(5);
        int ind1 = sound.indexOf('s');
        int ind2 = sound.indexOf('d');
        
        if( ind1 != -1 && ind2 != -1)
          {
            String ss1 = sound.substring(ind1+1, ind2);
            int level =  ss1.toInt();
            level = constrain(level, 0, 1023);
//          Serial.println(level);
            analogWrite(12,level);
           //3 Serial.println(level)
          }
          delay(1);

        }
    while (serverClients[i].available() > 2000) char buff = serverClients[i].read();
    // clears buffer in case of overflow
    
  }
  
  
    } // MAX svrclient ends
}
