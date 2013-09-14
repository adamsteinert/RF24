/*
 Copyright 2013 Jonathon Grigg <jonathongrigg@gmail.com>

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 One way communication between RPi and Arduino
 Open Serial Monitor and read the messages being sent from the Pi
*/

#include <SPI.h>
#include "RF24.h"

RF24 radio(9,10);
const uint64_t pipes[2] = { 0xF0F0F0F0E2LL, 0xF0F0F0F0E1LL };
char payload[32];

void setup(void)
{
  Serial.begin(57600);
  radio.begin();
  radio.enableDynamicPayloads();
  radio.setDataRate(RF24_1MBPS);
  radio.setPALevel(RF24_PA_MAX);
  radio.setChannel(76);
  radio.setRetries(15,15);
  radio.openWritingPipe(pipes[0]); 
  radio.openReadingPipe(1,pipes[1]); 
  radio.startListening();
  Serial.println("Ready!");
  delay(1000); 
}

void loop(void)
{
  while (radio.available()) {
    unsigned char length = radio.getDynamicPayloadSize();
    radio.read(payload, length);
    payload[length] = 0;  // Don't print the rest of the buffer
    Serial.println(payload);
  }  
  delay(250);
}
