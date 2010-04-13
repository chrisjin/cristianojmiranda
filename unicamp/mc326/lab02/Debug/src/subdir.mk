################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/aluno.c \
../src/bundle.c \
../src/hashmap.c \
../src/lab02.c \
../src/log.c \
../src/utils.c 

OBJS += \
./src/aluno.o \
./src/bundle.o \
./src/hashmap.o \
./src/lab02.o \
./src/log.o \
./src/utils.o 

C_DEPS += \
./src/aluno.d \
./src/bundle.d \
./src/hashmap.d \
./src/lab02.d \
./src/log.d \
./src/utils.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


