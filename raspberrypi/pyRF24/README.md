# Raspberry Pi Python3 library for nRF24L01(+) 2.4GHz Wireless Transceiver

_A Cython wrapper for the C++ based RF24 library, originally by ManiacBug_

Features
------------
* Complete function wrap from C++ to Cython for access within Python3
* Custom constructor to pass in additional radio options

Building
------------------
1. Ensure you have Cython installed under python3 (not python/python2)
2. Also ensure that librf24 has been built and is now in ```/usr/local/lib```
3. From ```raspberrypi/pyRF24``` run ```sudo python3 setup.py build_ext --inplace```

Usage
---------
* Having built pyRF24 using setup.py, pyRF24.so is now in ```/usr/local/lib/python3.x/dist-packages``` for easy importing via
    ```from pyRF24 import pyRF24```
* Until I get around to true documentation, look through ```Examples/Communicate/communicate.py``` and ```pyRF24.pyx``` for usage

Notes
--------
* Resulting python programs __must__ be run with sudo due to low level access

Credits
----------
* [maniacbug](https://github.com/maniacbug/RF24)
* [Stanley Seow - stanleyseow](https://github.com/stanleyseow/RF24)
* [Arco van Geest - gnulnulf](https://github.com/gnulnulf/RF24)
* [Jonathon Grigg - jonathongrigg](https://github.com/jonathongrigg/RF24)
