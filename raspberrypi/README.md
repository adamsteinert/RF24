# Raspberry Pi RF24 libraries

_This is the collection of libraries for RF24 / NRF24L01 wireless modules on the Raspberry Pi._

There are two folders with two different libraries

- librf24    This library/driver are ported from Arduino to BeagleBone then to RPi, uses GPIO
- pyRF24     A Cython wrapper allowing the use of Python3

Setup librf24
-------------
1. Run ```cd librf24```
2. Execute ```make``` and ```sudo make install``` to install the shared libraries
3. (_Optional_) Change to examples folder, change to the correct connected pins and execte ```make```

Links
-----
- Maniacbug RF24 [http://maniacbug.github.com/RF24/index.html]()
- RF24 Class Reference [http://maniacbug.github.com/RF24/classRF24.html]()


Credits
-------
* [maniacbug](https://github.com/maniacbug/RF24)
* [Stanley Seow - stanleyseow](https://github.com/stanleyseow/RF24)
* [Arco van Geest - gnulnulf](https://github.com/gnulnulf/RF24)
* [Jonathon Grigg - jonathongrigg](https://github.com/jonathongrigg/RF24)
