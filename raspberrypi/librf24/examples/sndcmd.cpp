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
  role = role_ping_out;
  radio.begin();
  radio.setRetries(15,15);
  radio.setChannel(0x4c);
  radio.setPALevel(RF24_PA_MAX);
  radio.openWritingPipe(pipes[0]);
  radio.openReadingPipe(1,pipes[1])
  radio.startListening();
  radio.printDetails();
}
 
bool sendCommand(int[] command){
    radio.stopListening();

    printf("Send Command %d to %d", command[1], command[0]);

	bool ok = radio.write( &command, sizeof(int) * 4 );
    
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
      printf("NORP Failed, response timed out.\n\r");
    }
    else
    {
      // Grab the response, compare, and send to debugging spew
      unsigned long got_time;
      radio.read( &got_time, sizeof(unsigned long) );

      // Spew it
      printf("Got response %lu, round-trip delay: %lu\n\r",got_time,__millis()-got_time);
    }

    // Try again 1s later
	sleep(1); 
}  
 
int main( int argc, char ** argv){
 
    char choice;
    setup();
    bool switched = false;
    int counter = 0;
 
	int[] command = { 9, 8, 7, 6};
	sendCommand(command);
	
    //Define the options
 	/*
    while(( choice = getopt( argc, argv, "f:")) != -1){
 
        if (choice == 'f'){
 
           if( strcmp( optarg, "on" ) == 0 || strcmp( optarg, "On") == 0 || strcmp( optarg, "ON") == 0 ){
 
              printf("\nTurn it ooooon!\n");
              while(switched == false && counter < 5){
 
                // the switch light return true if the ACK package is received, 
                // If we do not receive the ACK package for 5 times in a row, then the transmission will stop.
 
                switched = switchLight(1);
                counter++;
              }
 
           }else{
 
              printf("\nKill it without mercy!\n");
              while(switched == false && counter < 5){
 
                // the switch light return true if the ACK package is received, 
                // If we do not receive the ACK package for 5 times in a row, then the transmission will stop.
 
                switched = switchLight(0);
                counter++;
              }
           }
 
          }else{
            // A little help:
                printf("\n\rIt's time to make some choices...\n");
                printf("\n\rUse -f option: ");
                printf("\n[on|On|ON] - will turn the light on.");
                printf("\n[Off|*] -  guess what? It will turns the light off.\n ");
                printf("\n\rExample: ");
                printf("\nsudo ./switch -f on\n");
          }
 
      //return 0 if everything went good, 2 otherwise
       if (counter < 5)
         return 0;
       else
         return 2;
   }
   */
}
