# Copyright August 2013 Jonathon Grigg <jonathongrigg@gmail.com>
# Python3 wrapper for librf24 -- RF24 library for the RPi
# cython: language_level=3

from libcpp cimport bool

cdef extern from "RF24.h":
	ctypedef enum rf24_pa_dbm_e:
		RF24_PA_MIN = 0, RF24_PA_LOW, RF24_PA_HIGH, RF24_PA_MAX, RF24_PA_ERROR
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
	RF24_PA_MIN = 0
	RF24_PA_LOW = 1
	RF24_PA_HIGH = 2
	RF24_PA_MAX = 3

	RF24_1MBPS = 0
	RF24_2MBPS = 1
	RF24_250KBPS = 2

	RF24_CRC_DISABLED = 0
	RF24_CRC_8 = 1
	RF24_CRC_16 = 2

	cdef RF24 *rf24
	def __cinit__(self, _spidevice, _spispeed, _cepin):
		self.rf24 = new RF24(_spidevice, _spispeed, _cepin)
		self.rf24.begin()
	def __dealloc__(self):
		del self.rf24
	def resetcfg(self):
		self.rf24.resetcfg()
	def startListening(self):
		self.rf24.startListening()
	def stopListening(self):
		self.rf24.stopListening()
	def write(self, data):
		cdef char *buf = data
		return self.rf24.write(buf, len(data))
	def available(self, pipe = -1):
		cdef unsigned char pipe_num
		if pipe == -1:
			return self.rf24.available(NULL)
		else:
			pipe_num = pipe	# Avoid potential issues if setting to -1
			return self.rf24.available(&pipe_num)
	def read(self, length):
		cdef char *buf = ''
		self.rf24.read(buf, length)
		return buf
	def openWritingPipe(self, address):
		self.rf24.openWritingPipe(address)
	def openReadingPipe(self, number, address):
		self.rf24.openReadingPipe(number, address)
	def setRetries(self, delay, count):
		self.rf24.setRetries(delay, count)
	def setChannel(self, channel):
		self.rf24.setChannel(channel)
	def setPayloadSize(self, size):
		self.rf24.setPayloadSize(size)
	def getPayloadSize(self):
		return self.rf24.getPayloadSize()
	def getDynamicPayloadSize(self):
		return self.rf24.getDynamicPayloadSize()
	def enableAckPayload(self):
		self.rf24.enableAckPayload()
	def enableDynamicPayloads(self):
		self.rf24.enableDynamicPayloads()
	def isPVariant(self):
		return self.rf24.isPVariant()
	def setAutoAck(self, bool enable):
		self.rf24.setAutoAck(enable)
	def setAutoAck(self, pipe, bool enable):
		self.rf24.setAutoAck(pipe, enable)
	def setPALevel(self, rf24_pa_dbm_e level):
		self.rf24.setPALevel(level)
	def getPALevel(self):
		return self.rf24.getPALevel()
	def setDataRate(self, rf24_datarate_e speed):
		return self.rf24.setDataRate(speed)
	def getDataRate(self):
		return self.rf24.getDataRate()
	def setCRCLength(self, rf24_crclength_e length):
		self.rf24.setCRCLength(length)
	def getCRCLength(self):
		return self.rf24.getCRCLength()
	def disableCRC(self):
		self.rf24.disableCRC()
	def printDetails(self):
		self.rf24.printDetails()
	def powerDown(self):
		self.rf24.powerDown()
	def powerUp(self):
		self.rf24.powerUp()
	def startWrite(self, data):
		cdef char *buf = data
		self.rf24.write(buf, len(data))
	def writeAckPayload(self, pipe, data):
		cdef char *buf = data
		self.rf24.writeAckPayload(pipe, buf, len(data))
	def isAckPayloadAvailable(self):
		return self.rf24.isAckPayloadAvailable()
	def whatHappened(self):
		cdef bool tx_ok = False, tx_fail = False, rx_ready = False
		self.rf24.whatHappened(tx_ok, tx_fail, rx_ready)
		return [tx_ok, tx_fail, rx_ready]
	def testCarrier(self):
		return self.rf24.testCarrier()
	def testRPD(self):
		return self.rf24.testRPD()