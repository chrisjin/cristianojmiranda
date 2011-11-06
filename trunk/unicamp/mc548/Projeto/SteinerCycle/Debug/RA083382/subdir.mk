################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
O_SRCS += \
../RA083382/RA038508.o \
../RA083382/RA083382.o \
../RA083382/algExato.o \
../RA083382/alg_ze.o \
../RA083382/heuristicas.o 

CPP_SRCS += \
../RA083382/RA083382.cpp \
../RA083382/algExato.cpp \
../RA083382/heuristicas.cpp 

OBJS += \
./RA083382/RA083382.o \
./RA083382/algExato.o \
./RA083382/heuristicas.o 

CPP_DEPS += \
./RA083382/RA083382.d \
./RA083382/algExato.d \
./RA083382/heuristicas.d 


# Each subdirectory must supply rules for building sources it contributes
RA083382/%.o: ../RA083382/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


