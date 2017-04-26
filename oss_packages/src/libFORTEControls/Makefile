CXX = $(CROSS_COMPILE)g++
GCC_AR = ${AR}

CXXFLAGS = ${CFLAGS} -fPIC -std=c++0x
LINKERFLAGS = ${LDFLAGS}

INCLUDES="${INCLUDES} -IInclude"

OBJECTS = CliCommanderControl.o FORTEControl.o OutputSetterControl.o SMSMessageSenderControl.o EmailMessageSenderControl.o InputReaderControl.o RebooterControl.o

all: libFORTEControls.a

libFORTEControls.a: $(OBJECTS)
	$(GCC_AR) rvs $@ $(OBJECTS)
	
%.o: %.cpp
	@echo 'Building file: $*'
	$(CXX) $(INCLUDES) -c $(CXXFLAGS) $(LINKERFLAGS) $<
	@echo 'Finished building: $*'
	@echo ' ' 	
	
clean:
	rm -rf *.o libFORTEControls.a
	@echo ' '
