################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
O_SRCS += \
../main.o \
../steiner_cycle_solver.o 

CPP_SRCS += \
../main.cpp \
../steiner_cycle_solver.cpp 

OBJS += \
./main.o \
./steiner_cycle_solver.o 

CPP_DEPS += \
./main.d \
./steiner_cycle_solver.d 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


