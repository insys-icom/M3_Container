CC = /usr/bin/armv7a-hardfloat-linux-gnueabi-gcc
CXX = /usr/bin/armv7a-hardfloat-linux-gnueabi-g++
CFLAGS = -Os -s -mthumb -march=armv7-a -mtune=cortex-a8 -fuse-linker-plugin -ffunction-sections -fdata-sections -std=c11 -O0 -g3 -Wall -c -fmessage-length=0 -fPIC
CXXFLAGS = -Os -s -mthumb -march=armv7-a -mtune=cortex-a8 -fuse-linker-plugin -ffunction-sections -fdata-sections -std=c++0x -O0 -g3 -Wall -fmessage-length=0 -fPIC
LINKERFLAGS= -Wl,--as-needed -fuse-linker-plugin -Wl,--gc-sections
EXT_INCLUDES =
INCLUDES="${INCLUDES} -IInclude"
LIBS = -lmcip

OBJECTS = 	CardInfoProvider.o EmailMessageSender.o InputReader.o OutputSetter.o OutputState.o Rebooter.o SMSMessageSender.o StringSplitter.o \
			m3_cli.o MRXEmailMessageSender.o MRXInputReader.o MRXOutputSetter.o MRXSMSMessageSender.o \
			MRXCliEmailMessageSender.o MRXCliOutputSetter.o MRXCliCliCommander.o MRXCliFactory.o MRXCliRebooter.o \
			MRXCliCommandSender.o MRXCliInputReader.o MRXCliSMSMessageSender.o \
			CommandSender.o
all: libmrx_control.so

libmrx_control.so: $(OBJECTS)
	$(CXX) $(LINKERFLAGS) -shared -o $@ $(OBJECTS)
	
%.o: %.cpp
	@echo 'Building file: $*'
	$(CXX) $(INCLUDES) -c $(CXXFLAGS) $(LINKERFLAGS) $<
	@echo 'Finished building: $*'
	@echo ' '
		
%.o: MRX/%.cpp
	@echo 'Building file: $<'
	$(CXX) $(INCLUDES) -c $(CXXFLAGS) $(LINKERFLAGS) $<
	@echo 'Finished building: $<'
	@echo ' ' 	
	
%.o: MRX_CLI/%.cpp
	@echo 'Building file: $<'
	$(CXX) $(INCLUDES) -c $(CXXFLAGS) $(LINKERFLAGS) $<
	@echo 'Finished building: $<'
	@echo ' '
	
%.o: MRX_CLI/%.c
	@echo 'Building file: $<'
	$(CC) -c $(CFLAGS) $(INCLUDES) $(EXT_INCLUDES) $(LINKERFLAGS) $< $(LIBS)
	@echo 'Finished building: $<'
	@echo ' ' 
	
%.o: MRX_CLI/%.cpp
	@echo 'Building file: $<'
	$(CXX) $(INCLUDES) -c $(CXXFLAGS) $(LINKERFLAGS) $<
	@echo 'Finished building: $<'
	@echo ' ' 
	
%.o: CommandSender/%.cpp
	@echo 'Building file: $<'
	$(CXX) $(INCLUDES) -c $(CXXFLAGS) $(LINKERFLAGS) $<
	@echo 'Finished building: $<'
	@echo ' ' 	
	
clean:
	rm -rf *.o libmrx_control.so
	@echo ' '
