nasm -f bin leader.asm -o leader.bin
nasm -f elf32 IO.asm -o IO.o
gcc -march=i386 -m32 -mpreferred-stack-boundary=2 -ffreestanding -c kernal.c -o kernal.o 
ld.exe -m i386pe -N kernal.o IO.o -Ttext 0x7e00 -o kernal.tmp
objcopy -O binary kernal.tmp kernal.bin
