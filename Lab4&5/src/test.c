 __asm__(".code16gcc\n");
 __asm__("mov $0,%eax\n");
 __asm__("mov %ax,%ds\n");
 __asm__("mov %ax,%es\n");
 __asm__("jmpl $0,$_test\n");
#include "stdio.c"

//extern void change_int34h();
//extern void change_int35h();
//extern void change_int36h();

extern void change_int34to37();
extern void program_test();
extern void change_int21h();

void int_34_overide();
void int_35_overide();
void int_36_overide();
void int_37_overide();

void int_21h0_overide();//get time
void int_21h0_overide();//input and output string 
void int_21h0_overide();//out put "i love OS"
void int_21h_default();//print wrong information
void test();

void test()
{
    clear();
    change_int34to37();
    change_int21h();
    program_test();
    clear();
}
void int_21h0_overide()
{
    clear(); setgb(0,0);
    int date = getdate();

    int tmp_m = date/256; 
    int month = tmp_m>>4; 
    month = month*10+(tmp_m&=0x000F);

    int tmp_d = date%256;
    int day = tmp_d>>4;
    day = day*10+(tmp_d&=0x000F); 

    int now = getnow();

    int tmp_h = now/256;
    int hour = tmp_h>>4; 
    hour = hour*10+(tmp_h&=0x000F);

    int tmp_n = date%256;
    int minute = tmp_n>>4;
    minute = minute*10+(tmp_n&=0x000F);

    printstr("INT 21h,ah=0");CR();
    prints_color("now time: ",0x0E);
    printstr("2018/");printint(month);output('/');printint(day);
    printstr("  ");
    printint(hour);output(':');printint(minute);
    CR();printstr("press any key to continue");
    input();
}
void int_21h1_overide()
{
    clear();
    setgb(0,0);
    printstr("INT 21h , ah=1:");CR();
    prints_color("input the string:",0x0E);
    char str[100];
    scanf(str); 
    prints_color("output the string:",0x0E);
    prints_color(str,0x0E);CR();
    printstr("press any key to continue");
    input();
}
void int_21h2_overide()
{
    clear();
    setgb(0,0);
    printstr("INT 21h , ah=2:");
    prints_color("I love OS !!!",0x0E);CR();
    printstr("press any key to continue");
    input();
}
void int_21h_default()
{
    clear();
    setgb(0,0);
    prints_color("INT 21h,wrong ah you use, there is only 0,1,2 provided:",0x04);
    CR();printstr("press any key to continue");
    input();
}
void int_34_overide()
{
//    clear(1,1,14,40); //clear the area
    setgb(0,0);
    printstr("INT 34: press 'a' to stop:");CR();
    int pos[2] = {3,7};//x,y
    char info = 'Y';//display info
    int dir[2] = {1,1};//initial the direction
    char if_start;
    int color = 1;
    int tmp = getgb();
    int ox = tmp/256%256;
    int oy = tmp%256;
    
    while(if_start != 'a')
    {
        color = (color+1)%9;
        //delay
        for(int delay = 500000 ; delay > 0 ; delay--)
            for(int ddelay = 50 ; ddelay > 0 ; ddelay--);
        if_start = isinput();

        pos[0] += dir[0]; pos[1] += dir[1];
        //judging the boundary when the ball touch it
        if(pos[0] == 14) dir[0] = -1;
        if(pos[0] == 1)  dir[0] =  1;
        if(pos[1] == 40) dir[1] = -1;
        if(pos[1] == 1)  dir[1] =  1;
        //out put the ball on scan
        setgb(pos[0],pos[1]);
        output_color(info,color);
        setgb(ox,oy);
    }
    setgb(ox,oy);
}
void int_35_overide()
{
//    clear(1,15,14,80); //clear the area
    setgb(0,0);
    printstr("INT 35: press 'b' to stop");CR();
    int pos[2] = {3,70};//x,y
    char info = 'Z';//display info
    int dir[2] = {1,-1};//initial the direction
    char if_start;
    int color = 1;
    int tmp = getgb();
    int ox = tmp/256%256;
    int oy = tmp%256;
    
    while(if_start != 'b')
    {
        color = (color+1)%9;
        //delay
        for(int delay = 500000 ; delay > 0 ; delay--)
            for(int ddelay = 50 ; ddelay > 0 ; ddelay--);
        if_start = isinput();

        pos[0] += dir[0]; pos[1] += dir[1];
        //judging the boundary when the ball touch it
        if(pos[0] == 14) dir[0] = -1;
        if(pos[0] == 1)  dir[0] =  1;
        if(pos[1] == 41) dir[1] =  1;
        if(pos[1] == 79)  dir[1] =  -1;
        //out put the ball on scan
        setgb(pos[0],pos[1]);
        output_color(info,color);
        setgb(ox,oy);
    }
    setgb(ox,oy);
}
void int_36_overide()
{
//    clear(1,15,14,80); //clear the area
    setgb(0,0);
    printstr("INT 36: press 'c' to stop");CR();
    int pos[2] = {20,20};//x,y
    char info = 'C';//display info
    int dir[2] = {-1,-1};//initial the direction
    char if_start;
    int color = 1;
    int tmp = getgb();
    int ox = tmp/256%256;
    int oy = tmp%256;
    
    while(if_start != 'c')
    {
        color = (color+1)%9;
        //delay
        for(int delay = 500000 ; delay > 0 ; delay--)
            for(int ddelay = 50 ; ddelay > 0 ; ddelay--);
        if_start = isinput();

        pos[0] += dir[0]; pos[1] += dir[1];
        //judging the boundary when the ball touch it
        if(pos[0] == 24) dir[0] = -1;
        if(pos[0] == 15)  dir[0] =  1;
        if(pos[1] == 40) dir[1] =  -1;
        if(pos[1] == 1)  dir[1] =  1;
        //out put the ball on scan
        setgb(pos[0],pos[1]);
        output_color(info,color);
        setgb(ox,oy);
    }
    setgb(ox,oy);
}
void int_37_overide()
{
//    clear(1,15,14,80); //clear the area
    setgb(0,0);
    printstr("INT 37: press 'd' to stop");CR();
    int pos[2] = {20,70};//x,y
    char info = 'O';//display info
    int dir[2] = {-1,1};//initial the direction
    char if_start;
    int color = 1;
    int tmp = getgb();
    int ox = tmp/256%256;
    int oy = tmp%256;
    
    while(if_start != 'd')
    {
        color = (color+1)%9;
        //delay
        for(int delay = 500000 ; delay > 0 ; delay--)
            for(int ddelay = 50 ; ddelay > 0 ; ddelay--);
        if_start = isinput();

        pos[0] += dir[0]; pos[1] += dir[1];
        //judging the boundary when the ball touch it
        if(pos[0] == 24) dir[0] = -1;
        if(pos[0] == 15)  dir[0] =  1;
        if(pos[1] == 41) dir[1] =  1;
        if(pos[1] == 79)  dir[1] =  -1;
        //out put the ball on scan
        setgb(pos[0],pos[1]);
        output_color(info,color);
        setgb(ox,oy);
    }
    setgb(ox,oy);
}
