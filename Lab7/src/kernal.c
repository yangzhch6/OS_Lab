__asm__(".code16gcc\n");
__asm__("mov $0, %eax\n");
__asm__("mov %ax, %ds\n");
__asm__("mov %ax, %es\n");
__asm__("jmpl $0, $__main\n");


#include "stdio.c"

void help();
void infm();
void bounce();
void testfork();

void _main()
{
    initialPCB();
    change_int08h();
    INT33_to_36();
    change_int09h();
    char alp;
    char command[100];
    //what();

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
            testfork();
            //test();
            while(1){
                char t = isinput();
                if(t == 'q'){
                    delete_process();
                    break;
                }
            }
            printstr("test programe return to kernal");CR();
        }
        else if(compare(command,"clear"))
            clear();
        else if(compare(command,"ball"))
            bounce();
        else if(compare(command,"infm"))
            infm();
        else
        {
            prints_color("wrong commmand,using help to get more information",0x04);
            CR();
        } 
    }  
}

void testfork()
{
    loadp(161/36,(161%36)/18,(161%36)%18,32,0x3100,0x1000);
    pushPCB(1,0x3100);
}
void help()
{
    prints_color("|    you can use the folowing commands:",0x0E);CR();
    prints_color("|    1. [clear] : clear the scan ",0x0E);CR();
    prints_color("|    2. [ball]  : bounce the ball on your scan",0x0E);CR();
    prints_color("|    3. [infm]  : print the program information",0x0E);CR();
    prints_color("|    4. [test]  : test fork program   ",0x0E);CR();
    prints_color("|____________________________________________",0x0E);CR();
}

void infm()
{
    printstr("   |   the programe information below: ");CR();
    printstr("   |   location     address     size(byte)    name  ") ;CR();
    printstr("   |   0000h        7c00H       512           leader") ;CR();
    printstr("   |   0200h        7e00h       31*512        kernal") ;CR();
    printstr("   |   2400h   1000:B100h       512*16        bounceA");CR();
    printstr("   |   3400h   1000:3100h       512*16        bounceB");CR();
    printstr("   |   4400h   2000:B100h       512*16        bounceC");CR();
    printstr("   |   5400h   2000:3100h       512*16        bounceD");CR();
    //printstr("   |   6400h   0000:B100h       512*32        test   ");CR();
}

void bounce()
{
    clear();
    loadp(0,1,15,32,0x3100,0x1000);
    pushPCB(1,0x3100);
    loadp(65/36,(65%36)/18,(65%36)%18,32,0x3100,0x2000);
    pushPCB(2,0x3100);
    loadp(97/36,(97%36)/18,(97%36)%18,32,0x3100,0x3000);
    pushPCB(3,0x3100);
    loadp(129/36,(129%36)/18,(129%36)%18,32,0x3100,0x4000);
    pushPCB(4,0x3100);
    while(1)
    {
        char t = isinput();
        switch(t)
        {
            case 'q':
                stop_pro();
                clear();
                break;
            case 'a':
                if(PCBlist[1].status == 0) PCBlist[1].status = 1;
                else PCBlist[1].status = 0;
                break;
            case 'b':
                if(PCBlist[2].status == 0 ) PCBlist[2].status = 1;
                else PCBlist[2].status = 0;
                break;
            case 'c':
                if(PCBlist[3].status == 0 ) PCBlist[3].status = 1;
                else PCBlist[3].status = 0;
                break;
            case 'd':
                if(PCBlist[4].status == 0 ) PCBlist[4].status = 1;
                else PCBlist[4].status = 0;
                break;
        }
        if(t == 'q')
        {
            stop_pro();
            clear();
            break; 
        }    
    }
    for(int i = 0 ; i < 50000; i++)
        for(int j = 0 ; j < 500 ; j++);
    printstr("ball programe return to kernal");CR();
}