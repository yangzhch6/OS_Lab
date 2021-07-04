__asm__(".code16gcc\n");
__asm__("mov $0, %eax\n");
__asm__("mov %ax, %ds\n");
__asm__("mov %ax, %es\n");
__asm__("jmpl $0, $__main\n");

#include "stdio.c"
//#include "ball.c"

void help();
void infm();

void _main()
{
    char alp;
    char command[100];
//  changepos(3,3,4,'Y');
    CR();
    while(1)
    {
        output('>');
        output('>');

            scanf(command);
            if(compare(command,"help"))
                help();
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
    /*char helpa[60] = "|    you can use the folowing commands:";
    char helpb[60] = "|    1. [clear] : clear the scan ";
    char helpc[60] = "|    2. [ball ] : bounce the ball on your scan";
    char helpd[60] = "|    3. [infm ] : print the program information"; 
    char helpe[60] = "|    4. [flower]: game---tank's war            ";
    char nothing[60]="|____________________________________________";*/
    prints_color("|    you can use the folowing commands:",0x0E);CR();
    prints_color("|    1. [clear] : clear the scan ",0x0E);CR();
    prints_color("|    2. [ball ] : bounce the ball on your scan",0x0E);CR();
    prints_color("|    3. [infm ] : print the program information",0x0E);CR();
    prints_color("|    4. [snake]: see the beautiful flower           ",0x0E);CR();
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