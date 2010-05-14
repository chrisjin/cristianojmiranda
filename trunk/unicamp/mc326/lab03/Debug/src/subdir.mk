################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
O_SRCS += \
../src/log.o 

C_SRCS += \
../src/aluno.c \
../src/bundle.c \
../src/hashmap.c \
../src/io.c \
../src/lab03.c \
../src/log.c \
../src/mem.c \
../src/mylist.c \
../src/utils.c 

OBJS += \
./src/aluno.o \
./src/bundle.o \
./src/hashmap.o \
./src/io.o \
./src/lab03.o \
./src/log.o \
./src/mem.o \
./src/mylist.o \
./src/utils.o 

C_DEPS += \
./src/aluno.d \
./src/bundle.d \
./src/hashmap.d \
./src/io.d \
./src/lab03.d \
./src/log.d \
./src/mem.d \
./src/mylist.d \
./src/utils.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


