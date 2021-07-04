__asm__(".code16gcc\n");
__asm__("mov $0, %eax\n");
__asm__("mov %ax, %ds\n");
__asm__("mov %ax, %es\n");
__asm__("jmpl $0, $__main\n");

#include "stdio.c"
void help();
void infm();

void _main()
{
    change_int08h();
    change_int09h();
 //   change_int34to37();
 //   program_test();
    char alp;
    char command[100];
    CR();
    while(1)
    {
        output('>');
        output('>');
            scanf(command);

            if(compare(command,"help"))
                help();
            else if(compare(command,"test"))
            {
                loadp(97/36,(97%36)/18,(97%36)%18,32);
                runp();
                printstr("test programe return to kernal");CR();
            }
            else if(compare(command,"clear"))
                clear();
            else if(compare(command,"ball"))
            {
                loadp(0,1,15,32);
                runp();
                printstr("ball programe return to kernal");CR();
            }
            else if(compare(command,"snake"))
            {
                loadp(65/36,(65%36)/18,(65%36)%18,32);
                runp();
                printstr("snake programe return to kernal");CR();
            }
            else if(compare(command,"infm"))
                infm();
            else
            {
                prints_color("wrong commmand,using help to get more information",0x04);
                CR();
            } 
    }  
}

void help()
{
    prints_color("|    you can use the folowing commands:",0x0E);CR();
    prints_color("|    1. [clear] : clear the scan ",0x0E);CR();
    prints_color("|    2. [ball]  : bounce the ball on your scan",0x0E);CR();
    prints_color("|    3. [infm]  : print the program information",0x0E);CR();
    prints_color("|    4. [snake] : see the beautiful flower ",0x0E);CR();
    prints_color("|    4. [test]  : test INT 21h 34 35 36 37   ",0x0E);CR();
    prints_color("|____________________________________________",0x0E);CR();
}

void infm()
{
    printstr("   |   the programe information below: ");CR();
    printstr("   |   location address     size(byte)    name  ");CR();
    printstr("   |   0000h    7c00H       512           leader");CR();
    printstr("   |   0200h    7e00h       31*512        kernal");CR();
    printstr("   |   2400h    B100h       512*32        ball  ");CR();
    printstr("   |   8000h    B100h       512*10        snake ");CR();
}