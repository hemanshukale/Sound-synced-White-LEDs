# Sound-synced-lights-using-ESP8266
Sync your lights with music playing or any sound you want-


https://youtu.be/xqCmeVD_XI8

Here are 2 sketches - 1 of processing to be run on computer or Raspberry PI, other on ESP8266  
This processing sketch analyses the value of Sound in MIC IN and sends a scaled values (0 - 1023) to the ESP which in turn, writes the corresponding pwm to the LED strip  

Explanation of code -   

At startup - calibrates for 5 seconds- finds the average ambient noise so that it will subtract this level from input  
Then connects to client and starts sending the scaled sound level data

GUI explanation - 
there are 2 circles - RED indicates current value ; BLUE indicates scaled value
total 6 numbers at bottom of the screen,  starting from left -  
1st - calculated average of ambient noise  
2nd - Min Sound level  
3rd - Max Sound level  
4th - Current sound level  
5th - Scaled current sound level  
6th - framerate of sketch  

Min sound level - sound level that will be scaled as 0  
Max sound level - sound level that will be scaled as 1023

Keys explanation - 

Different mappings will be required for different songs -  
  
LEFT arrow  - decreses  Min sound level  
RIGHT arrow - increases Min sound level  
UP arrow    - increases Max sound level  
DOWN arrow  - decreses  Max sound level  

0 - hold 0 to turn on light to full
. - press . to pause turn on light to full, press again turn off light, press again to resume  

F - hold F and press + or - to increase / decrease framerate respectively

Electronics needed -
ESP8266  
LED strip 
12V adapter
AMS1117 3.3V  
MOSFEET  - get one with gate cutoff voltage less than 3.3V  
else, use a button cell in between GPIO and gate

Pinouts  

ESP8266-
VCC, EN, - 3.3V  
GPIO 2   - Pulled up  
GND      - GND  
GPIO15   - Pulled Down  
GPIO 12  - MOSFET gate with around 1K resistor in between ; can be pulled down for additional safety  
GPPIO 0  - GND for flashing  

Connect +ve terminal of LED strip to 12V and -ve to Drain of MOSFET  
Source of MOSFET - GND
