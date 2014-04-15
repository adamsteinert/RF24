/*
 
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 version 2 as published by the Free Software Foundation.
 */
 /*
  Hack.lenotta.com
  Modified code of Getting Started RF24 Library
  It will switch a relay on if receive a message with text 1, 
  turn it off otherwise.
  Edo
 */
 
#include <SPI.h>
#include "nRF24L01.h"
#include "RF24.h"
#include "printf.h"
int relay = 2;
 
//
// Hardware conf
//
 
// Set up nRF24L01 radio on SPI bus plus pins 9 & 10 
 
RF24 radio(9,10);
 
//
// Topology
//
 
// Radio pipe addresses for the 2 nodes to communicate.
const uint64_t pipes[2] = { 0xF0F0F0F0E1LL, 0xF0F0F0F0D2LL };
boolean status = false;

void setup(void)
{
  //
  // Print preamble
  //
 
  Serial.begin(57600);
  pinMode(relay, OUTPUT);
  digitalWrite(relay, HIGH);
  printf_begin();
  printf("\nLight Switch Arduino\n\r");
 
  //
  // Setup and configure rf radio
  //
 
  radio.begin();
  radio.setRetries(15,15);
  
  printf("\nOpening Pipes\n\r");
  radio.openWritingPipe(pipes[0]);
  radio.openReadingPipe(1,pipes[1]);

  radio.startListening();
  printf("\nListening\n\r");
  
  radio.printDetails();
}

void loop(void)
{     
    // if there is data ready
    if ( radio.available() )
    {
      printf("Radio hit!");
      
      // Dump the payloads until we've gotten everything
      unsigned long message = 7;
      long command[4];
      bool done = false;
      
      while (!done)
      {
        // Fetch the payload, and see if this was the last one.
        done = radio.read( &command, sizeof(command) );
 
        // Spew it
        printf("\nAddress: %d", command[0]);
        printf("\nCommand: %d", command[1]);        
        printf("\nArg1:    %d", command[2]);
        printf("\nArg2:    %d", command[3]);
        
        if (status){
          digitalWrite(relay, LOW);
        }else{
          digitalWrite(relay, HIGH);
        }
        status = !status;
 
        // Delay just a little bit to let the other unit
        // make the transition to receiver
        delay(20);
      }
 
      // First, stop listening so we can talk
      radio.stopListening();
 
      // Send the final one back.
      ++message;     
      radio.write( &message, sizeof(unsigned long) );

      printf("\nSent response: %d", message);
 
      // Now, resume listening so we catch the next packets.
      radio.startListening();
    }
 
}
