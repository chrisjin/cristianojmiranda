################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
O_SRCS += \
../RA038508/RA038508.o \
../RA038508/alg_ze.o 

CPP_SRCS += \
../RA038508/RA038508.cpp \
../RA038508/alg_ze.cpp 

OBJS += \
./RA038508/RA038508.o \
./RA038508/alg_ze.o 

CPP_DEPS += \
./RA038508/RA038508.d \
./RA038508/alg_ze.d 


# Each subdirectory must supply rules for building sources it contributes
RA038508/%.o: ../RA038508/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


