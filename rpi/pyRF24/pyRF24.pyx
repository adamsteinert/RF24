# Copyright August 2013 Jonathon Grigg <jonathongrigg@gmail.com>
# Python3 wrapper for librf24 -- RF24 library for the RPi
# cython: language_level=3

from libcpp cimport bool

cdef extern from "RF24.h":		# Might need namespace
	ctypedef enum rf24_pa_dbm_e:
		RF24_PA_MIN = 0,RF24_PA_LOW, RF24_PA_HIGH, RF24_PA_MAX, RF24_PA_ERROR
	ctypedef enum rf24_datarate_e:
		RF24_1MBPS = 0, RF24_2MBPS, RF24_250KBPS
	ctypedef enum rf24_crclength_e:
		RF24_CRC_DISABLED = 0, RF24_CRC_8, RF24_CRC_16

	cdef cppclass RF24:
		RF24(char*, unsigned int, unsigned char) except +
		void begin()
		void resetcfg()
		void startListening()
		void stopListening()
		bool write(const void*, unsigned char)
		bool available()
		bool read(void*, unsigned char)
		void openWritingPipe(unsigned long long)
		void openReadingPipe(unsigned char, unsigned long long)
		void setRetries(unsigned char, unsigned char)
		void setChannel(unsigned char)
		void setPayloadSize(unsigned char)
		unsigned char getPayloadSize()
		unsigned char getDynamicPayloadSize()
		void enableAckPayload()
		void enableDynamicPayloads()
		bool isPVariant() 
		void setAutoAck(bool)
		void setAutoAck(unsigned char, bool) 
		void setPALevel(rf24_pa_dbm_e)
		rf24_pa_dbm_e getPALevel()
		bool setDataRate(rf24_datarate_e)
		rf24_datarate_e getDataRate() 
		void setCRCLength(rf24_crclength_e)
		rf24_crclength_e getCRCLength()
		void disableCRC() 
		void printDetails()
		void powerDown()
		void powerUp()
		bool available(unsigned char*)
		void startWrite(const void*, unsigned char)
		void writeAckPayload(unsigned char, const void*, unsigned char)
		bool isAckPayloadAvailable()
		void whatHappened(bool&, bool&, bool&)
		bool testCarrier()
		bool testRPD()

cdef class pyRF24:
	cdef RF24 *rf24
	def __cinit__(self, char* _spidevice, unsigned int _spispeed, unsigned char _cepin):
		self.rf24 = new RF24(_spidevice, _spispeed, _cepin)
	def __dealloc__(self):
		del self.rf24
	def begin(self):
		return self.rf24.begin()
	def resetcfg(self):
		return self.rf24.resetcfg()
	def startListening(self):
		return self.rf24.startListening()
	def stopListening(self):
		return self.rf24.stopListening()
	def write(self, const void* buf, unsigned char length):
		return self.rf24.write(buf, length)
	def available(self):
		return self.rf24.available()
	def read(self, void* buf, unsigned char length):
		return self.rf24.read(buf, length)
	def openWritingPipe(self, unsigned long long address):
		return self.rf24.openWritingPipe(address)
	def openReadingPipe(self, unsigned char number, unsigned long long address):
		return self.rf24.openReadingPipe(number, address)
	def setRetries(self, unsigned char delay, unsigned char count):
		return self.rf24.setRetries(delay, count)
	def setChannel(self, unsigned char channel):
		return self.rf24.setChannel(channel)
	def setPayloadSize(self, unsigned char size):
		return self.rf24.setPayloadSize(size)
	def getPayloadSize(self):
		return self.rf24.getPayloadSize()
	def getDynamicPayloadSize(self):
		return self.rf24.getDynamicPayloadSize()
	def enableAckPayload(self):
		return self.rf24.enableAckPayload()
	def enableDynamicPayloads(self):
		return self.rf24.enableDynamicPayloads()
	def isPVariant(self):
		return self.rf24.isPVariant()
	def setAutoAck(self, bool enable):
		return self.rf24.setAutoAck(enable)
	def setAutoAck(self, unsigned char pipe, bool enable):
		return self.rf24.setAutoAck(pipe, enable)
	def setPALevel(self, rf24_pa_dbm_e level):
		return self.rf24.setPALevel(level)
	def getPALevel(self):
		return self.rf24.getPALevel()
	def setDataRate(self, rf24_datarate_e speed):
		return self.rf24.setDataRate(speed)
	def getDataRate(self):
		return self.rf24.getDataRate()
	def setCRCLength(self, rf24_crclength_e length):
		return self.rf24.setCRCLength(length)
	def getCRCLength(self):
		return self.rf24.getCRCLength()
	def disableCRC(self):
		return self.rf24.disableCRC()
	def printDetails(self):
		return self.rf24.printDetails()
	def powerDown(self):
		return self.rf24.powerDown()
	def powerUp(self):
		return self.rf24.powerUp()
	def available(self, unsigned char* pipe_num):
		return self.rf24.available(pipe_num)
	def startWrite(self, const void* buf, unsigned char length):
		return self.rf24.startWrite(buf, length)
	def writeAckPayload(self, unsigned char pipe, const void* buf, unsigned char length):
		return self.rf24.writeAckPayload(pipe, buf, length)
	def isAckPayloadAvailable(self):
		return self.rf24.isAckPayloadAvailable()
	def whatHappened(self, bool& tx_ok, bool& tx_fail, bool& rx_ready):
		return self.rf24.whatHappened(tx_ok, tx_fail, rx_ready)
	def testCarrier(self):
		return self.rf24.testCarrier()
	def testRPD(self):
		return self.rf24.testRPD()