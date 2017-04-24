CXX = /usr/bin/armv7a-hardfloat-linux-gnueabi-g++
AR = /usr/bin/armv7a-hardfloat-linux-gnueabi-ar
CXXFLAGS = -Os -s -mthumb -march=armv7-a -mtune=cortex-a8 -fPIC -std=c++0x -O0 -g3 -Wall -fmessage-length=0 -ffunction-sections -fdata-sections -fuse-linker-plugin

LINKERFLAGS= -Wl,--as-needed -fuse-linker-plugin -Wl,--gc-sections
INCLUDES="${INCLUDES} -IInclude"

OBJECTS = CliCommanderControl.o FORTEControl.o OutputSetterControl.o SMSMessageSenderControl.o EmailMessageSenderControl.o InputReaderControl.o RebooterControl.o

all: libFORTEControls.a

libFORTEControls.a: $(OBJECTS)
	$(AR) rvs $@ $(OBJECTS)
	
%.o: %.cpp
	@echo 'Building file: $*'
	$(CXX) $(INCLUDES) -c $(CXXFLAGS) $<
	@echo 'Finished building: $*'
	@echo ' ' 	
	
clean:
	rm -rf *.o libFORTEControls.a
	@echo ' '
