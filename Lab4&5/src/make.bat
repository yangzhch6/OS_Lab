nasm -f bin leader.asm -o leader.bin
dd if=leader.bin of=myos.flp bs=512 count=1

nasm -f elf32 IO.asm -o IO.o
gcc -march=i386 -m32 -mpreferred-stack-boundary=2 -ffreestanding -c kernal.c -o kernal.o 
ld.exe -m i386pe -N kernal.o IO.o -Ttext 0x7e00 -o kernal.tmp
objcopy -O binary kernal.tmp kernal.bin
dd if=kernal.bin of=myos.flp bs=512 count=31 seek=1

nasm -f elf32 IO.asm -o IO.o
gcc -march=i386 -m32 -mpreferred-stack-boundary=2 -ffreestanding -c ball.c -o ball.o
ld.exe -m i386pe -N ball.o IO.o -Ttext 0xB100 -o ball.tmp
objcopy -O binary ball.tmp ball.bin
dd if=ball.bin of=myos.flp bs=512 count=32 seek=32

nasm -f elf32 IO.asm -o IO.o
gcc -march=i386 -m32 -mpreferred-stack-boundary=2 -ffreestanding -c snake.c -o snake.o
ld.exe -m i386pe -N snake.o IO.o -Ttext 0xB100 -o snake.tmp
objcopy -O binary snake.tmp snake.bin
dd if=snake.bin of=myos.flp bs=512 count=32 seek=64

nasm -f elf32 IO.asm -o IO.o
nasm -f elf32 newint.asm -o newint.o
gcc -march=i386 -m32 -mpreferred-stack-boundary=2 -ffreestanding -c test.c -o test.o
ld.exe -m i386pe -N test.o newint.o IO.o -Ttext 0xB100 -o test.tmp
objcopy -O binary test.tmp test.bin
dd if=test.bin of=myos.flp bs=512 count=32 seek=96


