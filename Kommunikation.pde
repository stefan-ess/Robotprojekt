/* Program för att visa kommunikationen */

#include <Wire.h> //Används ej atm
#include <Servo.h> //Används ej atm
#include <AverageList.h> //Måste inkluderas i Arduino-miljön för att filen ska kunna kompileras!
typedef int sample;
const byte MAX_NUMBER_OF_READINGS = 10;
sample storage[MAX_NUMBER_OF_READINGS] = {0};
AverageList<sample> distance[3] = AverageList<sample>(storage, MAX_NUMBER_OF_READINGS);

unsigned char lastReceived = '0';
unsigned int lastSent = 0;

const unsigned int trigPin[1] = {3};
const unsigned int echoPin[1] = {4};

char inByte[17] = {"N0#D0;0#E0;0#S0#"}; 
char utByte[36] = {"N0#Pa;b;c#Cd#Ue;f;g;h;i;j#Ak#Dl#L0#"};
char fel[9] = {"E0#T0;0#"};

void setup()
{
	Serial.begin(9600);

        pinMode(trigPin[1], OUTPUT);
        pinMode(echoPin[1], INPUT);	
}
void loop()
{
	unsigned int i=0;
	while(1 <= Serial.available()) // loopar igenom hela input, även enterslaget	
		{
		    inByte[i] = Serial.read(); // receive byte as a character
		    Serial.println(inByte);    // print the character
			i++;
			if(inByte[0]!='N' && inByte[3]!='D' && inByte[8]!='E' && inByte[13]!='S')
			{	
            	error('inByte');
            }
		}
		demoFunktion();
		//parseInput(inByte)
}
void error(char message)
{
	Serial.println("Felkod: ");
	Serial.print(message);
}
void getDistance(int sensor)
{
  digitalWrite(trigPin[sensor], LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin[sensor], HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin[sensor], LOW);  
  distance[sensor].addValue(pulseIn(echoPin[sensor], HIGH)/58);
}
void demoFunktion()
{
	//Skicka tillbaka erhållen data samt ett dummy-paket för att illustrera att det funkar.
	getDistance(1); //Erhåller avståndsvärde på ultraljudssensor 1
    //utByte[14] = distance[1].getAverage(); //Gör att allt buggar ur, även bara nollor som värde.
	utByte[1] = lastSent;
	utByte[33] = lastReceived;
	Serial.println(utByte);
	lastSent++;
}
void parseInput(char data[17])
{
	//Bryta ner datan
}