 __asm__(".code16gcc\n");
 __asm__("mov %cs,%ax\n");
 __asm__("mov %ax,%ds\n");
 __asm__("mov %ax,%es\n");
 __asm__("call _bounceB\n");
 __asm__("lret\n");
 
#include "stdio.c"
void bounceB()
{
    setgb(0,0);
    printstr(" press 'q' to stop");CR();
    int pos[2] = {3,70};//x,y
    char info = 'Z';//display info
    int dir[2] = {1,-1};//initial the direction
    char if_start;
    int color = 1;
    int tmp = getgb();
    int ox = tmp/256%256;
    int oy = tmp%256;
    
    while(1)
    {
        color = (color+1)%9;
        for(int delay = 500000 ; delay > 0 ; delay--)
            for(int ddelay = 50 ; ddelay > 0 ; ddelay--);
        pos[0] += dir[0]; pos[1] += dir[1];
        //judging the boundary when the ball touch it
        if(pos[0] == 14) dir[0] = -1;
        if(pos[0] == 1)  dir[0] =  1;
        if(pos[1] == 41) dir[1] =  1;
        if(pos[1] == 79) dir[1] = -1;
        //out put the ball on scan
        setgb(pos[0],pos[1]);
        output_color(info,color);
        setgb(ox,oy);
    }
    setgb(ox,oy);
    clear();
}