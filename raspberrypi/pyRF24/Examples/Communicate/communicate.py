# Copyright 2013 Jonathon Grigg <jonathongrigg@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from pyRF24 import RF24
pipes = [0xF0F0F0F0E1, 0xF0F0F0F0E2]
radio = RF24("/dev/spidev0.0", 8000000, 18, retries = (15, 15), channel = 76,
        dynamicPayloads = True, autoAck = True)
radio.openWritingPipe(pipes[0])
radio.openReadingPipe(1, pipes[1])
radio.printDetails()
message = input("Message: ")
while message:
    if radio.write(message):
        print("Sent", message)
    message = input("Message: ")
