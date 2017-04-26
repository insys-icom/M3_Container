CC = $(CROSS_COMPILE)gcc
CXX = $(CROSS_COMPILE)g++
C_FLAGS = ${CFLAGS} -std=c11 -Wall -fPIC
CXXFLAGS = ${CFLAGS} -std=c++0x -Wall -fPIC
LINKERFLAGS = ${LDFLAGS}
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
	$(CC) -c $(C_FLAGS) $(INCLUDES) $(LINKERFLAGS) $< $(LIBS)
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
