 __asm__(".code16gcc\n");
 __asm__("mov $0,%eax\n");
 __asm__("mov %ax,%ds\n");
 __asm__("mov %ax,%es\n");
 __asm__("jmpl $0,$_bounce\n");
#include "stdio.c"
int _x[4] = {4,4,20,20};        //position x
int _y[4] = {4,60,4,60};        //position y
int _dirx[4] = {1,1,-1,-1};     //direction x
int _diry[4] = {1,-1,1,-1};     //direction y
int right[4] = {40,79,40,79};   //the boundary
int left[4]  = {0,41,0,41};
int up[4] = {0,0,14,14};
int down[4] = {13,13,24,24};   
int p[4] = {0,0,0,0};           //record the folowing pos
int color = 0;                  //colour
char info[10] = "123456789";    //the stirng we need to bounce    
void balls(int i)   // move one place a time
{   
        for(int delay = 500000 ; delay > 0 ; delay--)
            for(int ddelay = 50 ; ddelay > 0 ; ddelay--);
    
        p[i] = (p[i] + 1) % 9;    //change position   
        color = (color + 1)%16;   //change color
        _x[i] += _dirx[i];
        _y[i] += _diry[i];
        //judging the boundary when the ball touch it
        if(_x[i] == down[i]) _dirx[i] = -1;
        if(_x[i] == up[i])  _dirx[i] =  1;
        if(_y[i] == right[i]) _diry[i] = -1;
        if(_y[i] == left[i])  _diry[i] =  1;
        //out put the ball on scan
        changepos(_x[i],_y[i],color,info[p[i]]);
}

void bounce()   //control the four ball bouncing
{
    clear();
    char alp;
    int key[4] = {0,0,0,0};   // record whether to bounce the ball
    while(alp!='q')
    {
        alp = isinput();
        if(alp>='a' && alp<='d')
        {
            if(key[alp-'a'] == 1) key[alp-'a'] = 0;
            else key[alp-'a'] = 1;
        }
        for(int i = 0 ; i < 4 ; i++)
            if(key[i] != 0) balls(i); 
    }
    clear();
}