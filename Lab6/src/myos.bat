nasm -f bin leader.asm -o leader.bin
dd if=leader.bin of=myos.flp bs=512 count=1

nasm -f elf32 IO.asm -o IO.o
gcc -march=i386 -m32 -mpreferred-stack-boundary=2 -ffreestanding -c kernal.c -o kernal.o 
ld.exe -m i386pe -N kernal.o IO.o -Ttext 0x7e00 -o kernal.tmp
objcopy -O binary kernal.tmp kernal.bin
dd if=kernal.bin of=myos.flp bs=512 count=31 seek=1

nasm -f elf32 IO.asm -o IO.o
gcc -march=i386 -m32 -mpreferred-stack-boundary=2 -ffreestanding -c bounceA.c -o bounceA.o
ld.exe -m i386pe -N bounceA.o IO.o -Ttext 0xB100 -o bounceA.tmp
objcopy -O binary bounceA.tmp bounceA.bin
dd if=bounceA.bin of=myos.flp bs=512 count=32 seek=32

nasm -f elf32 IO.asm -o IO.o
gcc -march=i386 -m32 -mpreferred-stack-boundary=2 -ffreestanding -c bounceB.c -o bounceB.o
ld.exe -m i386pe -N bounceB.o IO.o -Ttext 0x3100 -o bounceB.tmp
objcopy -O binary bounceB.tmp bounceB.bin
dd if=bounceB.bin of=myos.flp bs=512 count=32 seek=64

nasm -f elf32 IO.asm -o IO.o
gcc -march=i386 -m32 -mpreferred-stack-boundary=2 -ffreestanding -c bounceC.c -o bounceC.o
ld.exe -m i386pe -N bounceC.o IO.o -Ttext 0xB100 -o bounceC.tmp
objcopy -O binary bounceC.tmp bounceC.bin
dd if=bounceC.bin of=myos.flp bs=512 count=32 seek=96

nasm -f elf32 IO.asm -o IO.o
gcc -march=i386 -m32 -mpreferred-stack-boundary=2 -ffreestanding -c bounceD.c -o bounceD.o
ld.exe -m i386pe -N bounceD.o IO.o -Ttext 0x3100 -o bounceD.tmp
objcopy -O binary bounceD.tmp bounceD.bin
dd if=bounceD.bin of=myos.flp bs=512 count=32 seek=128

