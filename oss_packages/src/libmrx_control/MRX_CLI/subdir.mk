################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../MRX_CLI/m3_cli.c 

CPP_SRCS += \
../MRX_CLI/MRXCliCliCommander.cpp \
../MRX_CLI/MRXCliCommandSender.cpp \
../MRX_CLI/MRXCliEmailMessageSender.cpp \
../MRX_CLI/MRXCliFactory.cpp \
../MRX_CLI/MRXCliInputReader.cpp \
../MRX_CLI/MRXCliOutputSetter.cpp \
../MRX_CLI/MRXCliRebooter.cpp \
../MRX_CLI/MRXCliSMSMessageSender.cpp 

OBJS += \
./MRX_CLI/MRXCliCliCommander.o \
./MRX_CLI/MRXCliCommandSender.o \
./MRX_CLI/MRXCliEmailMessageSender.o \
./MRX_CLI/MRXCliFactory.o \
./MRX_CLI/MRXCliInputReader.o \
./MRX_CLI/MRXCliOutputSetter.o \
./MRX_CLI/MRXCliRebooter.o \
./MRX_CLI/MRXCliSMSMessageSender.o \
./MRX_CLI/m3_cli.o 

C_DEPS += \
./MRX_CLI/m3_cli.d 

CPP_DEPS += \
./MRX_CLI/MRXCliCliCommander.d \
./MRX_CLI/MRXCliCommandSender.d \
./MRX_CLI/MRXCliEmailMessageSender.d \
./MRX_CLI/MRXCliFactory.d \
./MRX_CLI/MRXCliInputReader.d \
./MRX_CLI/MRXCliOutputSetter.d \
./MRX_CLI/MRXCliRebooter.d \
./MRX_CLI/MRXCliSMSMessageSender.d 


# Each subdirectory must supply rules for building sources it contributes
MRX_CLI/%.o: ../MRX_CLI/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: Cross G++ Compiler'
	armv7a-hardfloat-linux-gnueabi-g++ -std=c++0x -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

MRX_CLI/%.o: ../MRX_CLI/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross GCC Compiler'
	armv7a-hardfloat-linux-gnueabi-gcc -std=c11 -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


