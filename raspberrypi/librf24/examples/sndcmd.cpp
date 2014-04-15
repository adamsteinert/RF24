/*
This code is under CC-BY-SA license, created by Edoardo Odorico and Lorenzo Farnararo
http://hack.lenotta.com
edo@lenotta.com
*/
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <string>
#include <getopt.h>
#include <cstdlib>
#include <iostream>
#include "../RF24.h"

using namespace std;
RF24 radio("/dev/spidev0.0",8000000 , 25);  //spi device, speed and CSN,only CSN is NEEDED in RPI
const int role_pin = 7;
const uint64_t pipes[2] = { 0xF0F0F0F0E1LL, 0xF0F0F0F0D2LL };

void setup(void){
  //role = role_ping_out;
  radio.begin();
  radio.setRetries(15,15);
  radio.setChannel(0x4c);
  radio.setPALevel(RF24_PA_MAX);
  radio.openWritingPipe(pipes[0]);
  radio.openReadingPipe(1,pipes[1]);
  radio.startListening();
  radio.printDetails();
}

unsigned long sendCommand(int *command) {
    unsigned long result;
	  
    radio.stopListening();

	//int command[4] = { 0, 0, 0, 0};
	//command = ext;
    printf("Send Command %d to %d", command[1], command[0]);

	bool ok = radio.write( command, sizeof(int) * 4 );

    if (ok)
      printf("rad write ok...");
    else
      printf("rad write failed.\n\r");

    // Now, continue listening
    radio.startListening();

    // Wait here until we get a response, or timeout (250ms)
    unsigned long started_waiting_at = __millis();
    bool timeout = false;
    while ( ! radio.available() && ! timeout ) {
	// by bcatalin » Thu Feb 14, 2013 11:26 am 
	__msleep(5); //add a small delay to let radio.available to check payload
      if (__millis() - started_waiting_at > 200 )
        timeout = true;
    }

    // Describe the results
    if ( timeout )
    {
      printf("send failed, response timed out.\n\r");
    }
    else
    {
      // Grab the response, compare, and send to debugging spew
      radio.read( &result, sizeof(unsigned long) );

      // Spew it
      printf("Got response %lu, round-trip delay: %lu\n\r",result,__millis()-result);
    }

    // Try again 1s later
	sleep(1); 
	return result;
}  
 
int main( int argc, char ** argv) {
	int c;
	int command[4] = { 0, 0, 0, 0};
	
	while ((c = getopt (argc, argv, "a:c:x:y:")) != -1)
         switch (c)
           {
           case 'a':
             command[0] = atoi(optarg);
             break;
           case 'c':
             command[1] = atoi(optarg);
             break;
           case 'x':
             command[2] = atoi(optarg);
             break;
           case 'y':
             command[3] = atoi(optarg);
             break;			 
           }

    setup();	
	sendCommand(command);
	return 0;
}
